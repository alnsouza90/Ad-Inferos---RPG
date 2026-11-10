"""Turns the animation originals (art_source/characters/, never modified)
into frame sheets for the game, following docs/art/asset-pipeline.md §7,
D-194 and the T35 pilot.

Each row of tools/art/animation_clips.csv is one clip: a stretch of a video
(Wan 3, D-225, D-226) or a single drawn pose (Minos, D-229). For every clip
the tool takes the frames, removes the grey background, scales and places
them so the feet of the character stay on one line in every clip, and writes
one sheet (a grid of frames) plus the CharacterFrames resource the battle
view reads (game/scenes/battle/combatants/<id>_frames.tres).

Usage, from the repository root:
    python3 tools/art/process_frames.py                 # every character
    python3 tools/art/process_frames.py saint_george    # only one
    python3 tools/art/process_frames.py --preview DIR   # also contact sheets

Needs Pillow, numpy and ffmpeg. Development tool only.
"""
from __future__ import annotations

import csv
import subprocess
import sys
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "art_source" / "characters"
DST = ROOT / "game" / "assets" / "characters"
RES_DIR = ROOT / "game" / "scenes" / "battle" / "combatants"
CLIPS_CSV = Path(__file__).with_name("animation_clips.csv")
# Per character: size on screen next to the saints (a boss is bigger: Alan,
# D-233) and how its attack reaches the target: "melee" slides to it,
# "ranged" stays and hits from afar (Asmodeus' smoke), "throne" leans where
# it sits (Minos never rises, D-219).
CHARACTERS_CSV = Path(__file__).with_name("animation_characters.csv")

# Frames are kept a little under the video size (figure ~575 px, D-224):
# enough for the figure on a 1080 px stage, lighter on the phone.
OUTPUT_SCALE = 0.9
# Largest figure kept, in output pixels: the stop-motion drawings are twice
# the video size, and more than the stage shows only weighs on the phone.
MAX_FIGURE_PX = 640
# The Wan 3 videos are 30 frames per second; a clip plays its kept frames
# at 30 / step, so its timing is the one of the video.
VIDEO_FPS = 30.0
# Stop-motion GIFs (Meta AI, a few drawings each, D-247): drawings per
# second when the clip has no in-betweens; "tween=N" adds N mixed frames
# between two drawings and plays N + 1 times faster, so the timing holds.
STOP_MOTION_FPS = 5.0
# Room around the union of the frames of a clip, in output pixels.
PAD = 4
# Largest sheet side (safe on the phones we target).
MAX_SHEET = 4096
# Sheets are stored as lossy WebP: the frames are painted art, and PNG made
# the set too heavy for the repository (LFS quota) and the web build.
WEBP_QUALITY = 88

# The videos came out dark next to the scenery (Alan, D-233): every frame
# gets a gamma lift (1.0 keeps the original).
LIGHTEN_GAMMA = 0.8

# Drawn poses share the framing of the drawn idle pose (same canvas at
# another resolution, D-229, D-230): they are scaled and placed by the
# canvas, through that idle drawing, so a raised tail does not shrink the
# figure.
STILL_REFERENCE = {"elite_minos": "elite_minos_body_idle_v01.jpg",
                   "elite_sin_vertigo": "elite_sin_vertigo_body_idle_v02.jpg"}

# Background: grey, connected to the border (same idea as process_art.py,
# vectorised because a video gives hundreds of frames).
BG_TOLERANCE = 20
EDGE_SOFTNESS = 18
# Enclosed background: pixels this close to the grey, in a patch at least
# 2 * HOLE_RADIUS + 1 pixels across, go too.
HOLE_TOLERANCE = 8
HOLE_RADIUS = 2
# Edge of the figure: how many pixels from the cut background are treated
# as a blend with the grey, and over what distance they become opaque.
FRINGE_DEPTH = 3
FRINGE_SOFTNESS = 80
# Treatment "veil_key" (Vertigo): grey lighter than VEIL_KEY_DARK fades out.
VEIL_KEY_CHROMA = 20
VEIL_KEY_DARK = 100
VEIL_KEY_MARGIN = 20
# Treatment "protect_head" (Vertigo's face is the background grey): the
# head box, as shares of the standing figure height above the feet, and the
# bigger hole size used inside it ("protect_all": the whole frame).
PROTECT_TOP = 1.06
PROTECT_BOTTOM = 0.70
PROTECT_FOLLOW_HEIGHT = 0.34
PROTECT_FOLLOW_MIN = 0.30
PROTECT_ROW_PIXELS = 12
PROTECT_HALF_WIDTH = 0.22
PROTECT_HOLE_RADIUS = 12
# "protect_all" on clean drawings (Vertigo's stop motion, D-247): the hole
# size follows the canvas width, between the whites of the eyes (kept) and
# the gaps between veils (cut).
DRAWING_HOLE_SHARE = 0.0045


def drawing_hole_radius(width: int) -> int:
    return max(3, round(width * DRAWING_HOLE_SHARE))
# Exact background grey left anywhere, even a single pixel.
SPECK_TOLERANCE = 6
# Treatment "fade_smoke_tail": the smoke fades over the last frames.
SMOKE_TAIL_FRAMES = 6
SMOKE_TAIL_MIN_SAT = 40
SMOKE_RIM_PX = 4
# Treatment "soft_smoke" (D-243): opacity of the smoke, blur of its edges
# and colours (pixels), how dark an outline pixel is (HSV value, 0-255), and
# how far behind the head's left edge in the first frame the smoke starts.
SOFT_SMOKE_ALPHA = 0.6
SOFT_SMOKE_BLUR = 3.0
SOFT_SMOKE_DARK = 70
SOFT_SMOKE_MARGIN = 20
# Treatment "smoke_darker": brightness kept on the breath video's violet.
SMOKE_EXTRA = 0.83
# Treatment "fade_left": width of the fade at the cut border of the video.
FADE_LEFT_PX = 90
# Treatment "fade_sides": the same on three sides of a stop-motion drawing.
FADE_SIDES_PX = 60
# Treatment "light_wisps" (Vertigo): pale grey streaks also count as
# background when they touch it.
WISP_MAX_CHROMA = 14
WISP_BELOW_BG = 12
# Feet: centre of the figure in its lowest rows, as a share of its height.
FEET_BAND = 0.06

# D-227: the violet smoke of Asmodeus is too light and saturated; light
# violet tones go down to ~38% of their brightness and ~55% of saturation.
SMOKE_VALUE = 0.38
SMOKE_SATURATION = 0.55
SMOKE_HUE = (180, 228)  # PIL hue, 0-255 (violet)
SMOKE_MIN_SAT = 0.22
SMOKE_MIN_VALUE = 0.45


@dataclass
class Clip:
    character: str
    group: str
    clip: str
    source: str
    start: int
    end: int
    step: int
    mode: str
    blend: int
    impact: int
    treatment: str

    @property
    def is_video(self) -> bool:
        """A source of many frames: a Wan 3 video or a stop-motion GIF."""
        return self.source.endswith((".mp4", ".gif"))

    @property
    def is_gif(self) -> bool:
        return self.source.endswith(".gif")

    @property
    def treatments(self) -> list[str]:
        return self.treatment.split("+") if self.treatment else []

    @property
    def tween(self) -> int:
        """In-betweens per pair of drawings ("tween=N"), 0 without."""
        for t in self.treatments:
            if t.startswith("tween="):
                return int(t.split("=")[1])
        return 0

    def fps(self, speed: float) -> float:
        if self.source.endswith(".mp4"):
            return VIDEO_FPS / self.step * speed
        # GIFs and lists of drawings ("a.jpg|b.jpg") are stop motion.
        return STOP_MOTION_FPS * (self.tween + 1) / self.step * speed


@dataclass
class Placed:
    """One frame in character space: feet of the reference at (0, 0)."""
    image: Image.Image
    offset: tuple[int, int]


@dataclass
class Character:
    id: str
    group: str
    clips: list[Clip] = field(default_factory=list)
    display_scale: float = 1.0
    attack_style: str = "melee"
    speed: float = 1.0
    spell_style: str = "orb"
    blessing_style: str = "ring"


def read_clips() -> list[Character]:
    chars: dict[str, Character] = {}
    with CLIPS_CSV.open(newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            def num(key: str, default: int) -> int:
                return int(row[key]) if row[key].strip() else default
            clip = Clip(row["character"], row["group"], row["clip"], row["source"],
                        num("start", 0), num("end", 0), num("step", 1), row["mode"],
                        num("blend", 0), num("impact", -1), row["treatment"].strip())
            chars.setdefault(clip.character, Character(clip.character, clip.group)).clips.append(clip)
    with CHARACTERS_CSV.open(newline="", encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if row["character"] in chars:
                chars[row["character"]].display_scale = float(row["display_scale"])
                chars[row["character"]].attack_style = row["attack_style"].strip()
                chars[row["character"]].speed = float(row["speed"])
                chars[row["character"]].spell_style = row["spell_style"].strip()
                chars[row["character"]].blessing_style = row["blessing_style"].strip()
    return list(chars.values())


# --- reading ------------------------------------------------------------------

def video_frames(path: Path) -> np.ndarray:
    if path.suffix == ".gif":
        with Image.open(path) as img:
            frames = []
            for i in range(getattr(img, "n_frames", 1)):
                img.seek(i)
                frames.append(np.asarray(img.convert("RGB")))
        return np.stack(frames)
    probe = subprocess.run(
        ["ffprobe", "-v", "error", "-select_streams", "v", "-show_entries",
         "stream=width,height", "-of", "csv=p=0", str(path)],
        capture_output=True, text=True, check=True).stdout.strip().split(",")
    w, h = int(probe[0]), int(probe[1])
    raw = subprocess.run(
        ["ffmpeg", "-v", "error", "-i", str(path), "-f", "rawvideo", "-pix_fmt", "rgb24", "-"],
        capture_output=True, check=True).stdout
    data = np.frombuffer(raw, np.uint8)
    n = data.size // (w * h * 3)
    return data[: n * w * h * 3].reshape(n, h, w, 3)


_video_cache: dict[Path, np.ndarray] = {}


def video(path: Path) -> np.ndarray:
    if path not in _video_cache:
        _video_cache.clear()  # one video at a time is enough (rows are grouped)
        _video_cache[path] = video_frames(path)
    return _video_cache[path]


def clip_cut_frames(clip: Clip) -> list[np.ndarray]:
    """The kept frames of a video clip, cut out. A loop with `blend` mixes
    its last frames with the ones just before its start, so the jump from
    the last frame back to the first does not show. The mix is made after
    the cut, so a part that moves leaves a faint copy, not a grey one."""
    treat = clip.treatment.split("+")
    wisps = "light_wisps" in treat
    veil = "veil_key" in treat
    inner = "border_only" not in treat
    frames = video(SRC / clip.group / clip.character / clip.source)
    protect = None
    if "protect_all" in treat:
        protect = (0, 0, frames.shape[2], frames.shape[1])
    elif "protect_head" in treat or "protect_follow" in treat:
        fx, fy, fh = feet_point(cut_out(frames[0]))
        protect = (int(fx - fh * PROTECT_HALF_WIDTH), int(fy - fh * PROTECT_TOP),
                   int(fx + fh * PROTECT_HALF_WIDTH), int(fy - fh * PROTECT_BOTTOM))
    follow = "protect_follow" in treat
    hr = drawing_hole_radius(frames.shape[2]) if clip.is_gif else PROTECT_HOLE_RADIUS
    out: list[np.ndarray] = []
    end = clip.end if clip.end > 0 else len(frames)
    for i in range(clip.start, end, clip.step):
        if follow:
            protect = head_box(frames[i], fx, fh)
            # Once the figure has sunk into the smoke there is no face left
            # to keep, and the box would only keep grey.
            if protect[1] > fy - fh * PROTECT_FOLLOW_MIN:
                protect = None
        f = cut_out(frames[i], wisps, veil, protect, inner, hr)
        if clip.mode == "loop" and clip.blend > 0 and i >= end - clip.blend:
            twin = clip.start - (end - i)
            if twin >= 0:
                t = (i - (end - clip.blend) + 1) / (clip.blend + 1)
                f = mix(f, cut_out(frames[twin], wisps, veil, protect, inner, hr), t)
        out.append(f)
    return out


def head_box(rgb: np.ndarray, fx: float, fh: float) -> tuple[int, int, int, int]:
    """"protect_follow": while she sinks (the fall), the head is the top of
    the figure in the middle columns; the box follows it frame by frame."""
    x0, x1 = int(fx - fh * PROTECT_HALF_WIDTH), int(fx + fh * PROTECT_HALF_WIDTH)
    bg = border_colour(rgb)
    dist = np.abs(rgb[:, max(x0, 0):x1].astype(np.float32) - bg).max(axis=2)
    rows = np.nonzero((dist > BG_TOLERANCE + EDGE_SOFTNESS).sum(axis=1) > PROTECT_ROW_PIXELS)[0]
    top = int(rows[0]) if rows.size else 0
    return (x0, top - 4, x1, top + int(fh * PROTECT_FOLLOW_HEIGHT))


def only_component(rgba: np.ndarray, x: int, y: int) -> np.ndarray:
    """Keeps the opaque piece connected to (x, y); the rest goes clear."""
    solid = rgba[..., 3] > 40
    seed = np.zeros_like(solid)
    seed[y, x] = True
    keep = grow(seed, solid)
    # A soft rim: the half-clear pixels right around the piece stay too.
    rim = keep.copy()
    rim[1:, :] |= keep[:-1, :]
    rim[:-1, :] |= keep[1:, :]
    rim[:, 1:] |= keep[:, :-1]
    rim[:, :-1] |= keep[:, 1:]
    out = rgba.copy()
    out[..., 3] = np.where(rim, out[..., 3], 0)
    return out


def centre_of(rgba: np.ndarray) -> tuple[float, float]:
    x0, y0, x1, y1 = figure_box(rgba)
    return (x0 + x1) / 2.0, (y0 + y1) / 2.0


def mix(a: np.ndarray, b: np.ndarray, t: float) -> np.ndarray:
    """Premultiplied mix of two RGBA frames."""
    fa, fb = a.astype(np.float32) / 255.0, b.astype(np.float32) / 255.0
    alpha = fa[..., 3:] * (1.0 - t) + fb[..., 3:] * t
    colour = fa[..., :3] * fa[..., 3:] * (1.0 - t) + fb[..., :3] * fb[..., 3:] * t
    colour = colour / np.maximum(alpha, 1e-4)
    return (np.dstack([colour, alpha]) * 255.0).clip(0, 255).astype(np.uint8)


# --- background -------------------------------------------------------------------

def border_colour(rgb: np.ndarray) -> np.ndarray:
    border = np.concatenate([rgb[0], rgb[-1], rgb[:, 0], rgb[:, -1]])
    return np.median(border, axis=0)


def grow(seeds: np.ndarray, mask: np.ndarray) -> np.ndarray:
    """Pixels of `mask` reachable from `seeds` through `mask`."""
    reach = seeds & mask
    while True:
        grown = reach.copy()
        grown[1:, :] |= reach[:-1, :]
        grown[:-1, :] |= reach[1:, :]
        grown[:, 1:] |= reach[:, :-1]
        grown[:, :-1] |= reach[:, 1:]
        grown &= mask
        if np.array_equal(grown, reach):
            return reach
        reach = grown


def erode(mask: np.ndarray, radius: int) -> np.ndarray:
    out = mask.copy()
    for _ in range(radius):
        inner = out.copy()
        inner[1:, :] &= out[:-1, :]
        inner[:-1, :] &= out[1:, :]
        inner[:, 1:] &= out[:, :-1]
        inner[:, :-1] &= out[:, 1:]
        out = inner
    return out


def cut_out(rgb: np.ndarray, wisps: bool = False, veil_key: bool = False,
            protect: tuple[int, int, int, int] | None = None, inner: bool = True,
            hole_radius: int = PROTECT_HOLE_RADIUS) -> np.ndarray:
    """RGBA with the grey background made transparent: the grey connected to
    the border, and enclosed patches of almost exactly the background grey
    big enough not to be a detail (between veils, under a wing). Edge pixels
    are un-mixed from the grey so no light fringe is left."""
    bg = border_colour(rgb)
    dist = np.abs(rgb.astype(np.float32) - bg).max(axis=2)
    soft = dist < BG_TOLERANCE + EDGE_SOFTNESS
    flat = dist <= BG_TOLERANCE
    if wisps:
        # Light streaks the video left around fast veils: lighter than the
        # grey, without colour. Only for figures with nothing white drawn.
        f = rgb.astype(np.float32)
        chroma = f.max(axis=2) - f.min(axis=2)
        flat |= (chroma <= WISP_MAX_CHROMA) & (f.mean(axis=2) >= bg.mean() - WISP_BELOW_BG)
    border = np.zeros_like(flat)
    border[0, :] = border[-1, :] = True
    border[:, 0] = border[:, -1] = True
    holes = erode(dist <= HOLE_TOLERANCE, HOLE_RADIUS)
    # Specks of the exact grey anywhere (a few pixels between a raven's
    # feet) go too: the art never uses that flat grey...
    specks = dist <= SPECK_TOLERANCE
    box = np.zeros_like(flat)
    if not inner:
        # "border_only" (Minos): the light belly of his tail is the grey of
        # the background; only the grey that reaches the border goes (D-240).
        holes = np.zeros_like(flat)
        specks = np.zeros_like(flat)
    if protect is not None:
        # ...except Vertigo's face, painted in that very grey (D-236): in the
        # box of the head only big patches go.
        x0, y0, x1, y1 = protect
        box[max(y0, 0):max(y1, 0), max(x0, 0):max(x1, 0)] = True
        big = erode(dist <= HOLE_TOLERANCE, hole_radius)
        holes = np.where(box, big, holes)
        specks &= ~box
    core = grow(border | holes | specks, flat)
    # The video blurs the step from the grey to the black outline: the
    # pixels a few steps from the cut background are a mix of the two, and
    # left opaque they draw a grey line around the figure on a dark screen
    # (Alan, D-235). They get an alpha from their distance to the grey and
    # are un-mixed from it.
    ring = np.zeros_like(core)
    grown = core.copy()
    for _ in range(FRINGE_DEPTH):
        nxt = grown.copy()
        nxt[1:, :] |= grown[:-1, :]
        nxt[:-1, :] |= grown[1:, :]
        nxt[:, 1:] |= grown[:, :-1]
        nxt[:, :-1] |= grown[:, 1:]
        grown = nxt
    ring = grown & ~core
    alpha = np.ones(dist.shape, np.float32)
    alpha[core] = 0.0
    alpha[ring] = np.clip((dist[ring] - BG_TOLERANCE) / FRINGE_SOFTNESS, 0.0, 1.0)
    if veil_key:
        # Veils the video drew see-through over the grey (Vertigo): grey
        # without colour is as transparent as it is light.
        f = rgb.astype(np.float32)
        chroma = f.max(axis=2) - f.min(axis=2)
        luma = f.mean(axis=2)
        key = np.clip((bg.mean() - luma) / (bg.mean() - VEIL_KEY_DARK), 0.0, 1.0)
        # Only see-through grey that reaches the background: a light face
        # closed by its dark outline stays.
        pale = (chroma <= VEIL_KEY_CHROMA) & (luma > VEIL_KEY_DARK + VEIL_KEY_MARGIN) & ~box
        veils = grow(core, core | pale) & ~core
        alpha = np.where(veils, np.minimum(alpha, key), alpha)
    colour = rgb.astype(np.float32)
    a = np.maximum(alpha, 1e-3)[..., None]
    colour = np.where(alpha[..., None] < 1.0, (colour - (1.0 - a) * bg) / a, colour)
    return np.dstack([colour.clip(0, 255), alpha * 255.0]).astype(np.uint8)


def violet_mask(rgba: np.ndarray) -> np.ndarray:
    hsv = np.asarray(Image.fromarray(rgba[..., :3]).convert("HSV")).astype(np.float32)
    return (hsv[..., 0] >= SMOKE_HUE[0]) & (hsv[..., 0] <= SMOKE_HUE[1]) & (hsv[..., 1] > SMOKE_TAIL_MIN_SAT)


def darken_violet(rgba: np.ndarray, factor: float) -> np.ndarray:
    """"smoke_darker": the breath video came out lighter than the smoke Alan
    approved (D-227); its violet goes down to the same tone (D-242)."""
    out = rgba.copy()
    m = violet_mask(rgba)
    out[..., :3] = np.where(m[..., None], (rgba[..., :3] * factor).astype(np.uint8), rgba[..., :3])
    return out


def soften_smoke(rgba: np.ndarray, limit_x: int) -> np.ndarray:
    """"soft_smoke": the breath looked too solid and too drawn (Alan,
    D-243). Ahead of the dragon's head the smoke loses its ink outline, gets
    see-through and its edges are blurred, like mist."""
    from PIL import ImageFilter
    out = rgba.copy()
    region = np.zeros(rgba.shape[:2], bool)
    region[:, :max(limit_x, 0)] = True
    violet = violet_mask(rgba) & region
    hsv = np.asarray(Image.fromarray(rgba[..., :3]).convert("HSV")).astype(np.float32)
    # The outline: dark pixels next to the smoke.
    near = violet.copy()
    for _ in range(SMOKE_RIM_PX):
        grown = near.copy()
        grown[1:, :] |= near[:-1, :]
        grown[:-1, :] |= near[1:, :]
        grown[:, 1:] |= near[:, :-1]
        grown[:, :-1] |= near[:, 1:]
        near = grown
    near &= region
    outline = near & ~violet & (hsv[..., 2] < SOFT_SMOKE_DARK)
    alpha = out[..., 3].astype(np.float32)
    alpha[outline] = 0.0
    alpha[violet] *= SOFT_SMOKE_ALPHA
    # Light lines inside the clouds: blend them into the smoke colour.
    rgb = Image.fromarray(out[..., :3]).filter(ImageFilter.GaussianBlur(SOFT_SMOKE_BLUR))
    out[..., :3] = np.where(near[..., None], np.asarray(rgb), out[..., :3])
    soft = np.asarray(Image.fromarray(alpha.clip(0, 255).astype(np.uint8)).filter(ImageFilter.GaussianBlur(SOFT_SMOKE_BLUR))).astype(np.float32)
    alpha = np.where(near, soft, alpha)
    out[..., 3] = alpha.clip(0, 255).astype(np.uint8)
    return out


def fade_smoke_tail(frames: list[np.ndarray], limit_x: int) -> list[np.ndarray]:
    """The smoke thins out over the last frames of the clip, so the breath
    ends instead of stopping (Asmodeus' breath video, D-242). Only violet
    pixels fade; the dragon stays."""
    n = min(SMOKE_TAIL_FRAMES, len(frames))
    out = list(frames)
    for j in range(n):
        i = len(frames) - n + j
        keep = 1.0 - (j + 1) / (n + 1)
        f = frames[i].copy()
        # The ink rim of the clouds fades with them (a dark ring stayed).
        violet = violet_mask(f)
        for _ in range(SMOKE_RIM_PX):
            grown = violet.copy()
            grown[1:, :] |= violet[:-1, :]
            grown[:-1, :] |= violet[1:, :]
            grown[:, 1:] |= violet[:, :-1]
            grown[:, :-1] |= violet[:, 1:]
            violet = grown
        violet[:, limit_x:] = False
        f[..., 3] = np.where(violet, (f[..., 3] * keep).astype(np.uint8), f[..., 3])
        out[i] = f
    return out


def fade_sides(rgba: np.ndarray, width: int) -> np.ndarray:
    """Fades the left, right and top edges of the canvas: a stop-motion
    drawing that leans out of its frame (Vertigo's lunge, D-247) dissolves
    instead of ending in a straight line. The bottom stays: the feet."""
    out = fade_left(rgba, width)
    out = fade_left(out[:, ::-1], width)[:, ::-1]
    # Narrower at the top: the hair's smoke nearly touches it when standing.
    h = max(1, width // 3)
    top = np.linspace(0.0, 1.0, h, dtype=np.float32)
    out[:h, :, 3] = (out[:h, :, 3].astype(np.float32) * top[:, None]).astype(np.uint8)
    return np.ascontiguousarray(out)


def tween(frames: list[np.ndarray], count: int, loop: bool) -> list[np.ndarray]:
    """Stop motion has few drawings (D-247): between two of them, `count`
    frames that dissolve one into the other, so a pose melts into the next
    instead of jumping. A loop also melts its last drawing into the first."""
    out: list[np.ndarray] = []
    pairs = len(frames) if loop else len(frames) - 1
    for i in range(len(frames)):
        out.append(frames[i])
        if i < pairs:
            nxt = frames[(i + 1) % len(frames)]
            for k in range(1, count + 1):
                out.append(mix(frames[i], nxt, k / (count + 1)))
    return out


def fade_left(rgba: np.ndarray, width: int) -> np.ndarray:
    """Fades the left edge out: what the video cut at its border (Asmodeus'
    smoke) dissolves instead of ending in a straight line."""
    out = rgba.copy()
    ramp = np.linspace(0.0, 1.0, width, dtype=np.float32)
    out[:, :width, 3] = (out[:, :width, 3].astype(np.float32) * ramp[None, :]).astype(np.uint8)
    return out


def lighten(rgba: np.ndarray) -> np.ndarray:
    if LIGHTEN_GAMMA == 1.0:
        return rgba
    rgb = (rgba[..., :3].astype(np.float32) / 255.0) ** LIGHTEN_GAMMA * 255.0
    return np.dstack([rgb.clip(0, 255).astype(np.uint8), rgba[..., 3]])


def darken_smoke(rgba: np.ndarray) -> np.ndarray:
    hsv = np.asarray(Image.fromarray(rgba[..., :3]).convert("HSV")).astype(np.float32)
    h, s, v = hsv[..., 0], hsv[..., 1] / 255.0, hsv[..., 2] / 255.0
    hue_in = (h >= SMOKE_HUE[0]) & (h <= SMOKE_HUE[1])
    weight = (hue_in
              * np.clip((s - SMOKE_MIN_SAT) / 0.15, 0.0, 1.0)
              * np.clip((v - SMOKE_MIN_VALUE) / 0.2, 0.0, 1.0))
    hsv[..., 1] = s * (1.0 - weight * (1.0 - SMOKE_SATURATION)) * 255.0
    hsv[..., 2] = v * (1.0 - weight * (1.0 - SMOKE_VALUE)) * 255.0
    rgb = np.asarray(Image.fromarray(hsv.clip(0, 255).astype(np.uint8), "HSV").convert("RGB"))
    return np.dstack([rgb, rgba[..., 3]])


def image_rgba(path: Path, inner: bool = True, frame: int = 0, big_holes: bool = False,
               size: tuple[int, int] | None = None) -> np.ndarray:
    """A drawing cut out. `frame` picks one drawing of a GIF; `size`
    (width, height) brings it to the canvas of the reference drawing first.
    `big_holes`: only big patches of grey go inside the figure, so the
    whites of the eyes, painted in that grey, stay (Vertigo, D-247)."""
    img = Image.open(path)
    if frame:
        img.seek(frame)
    if img.mode == "RGBA" and np.asarray(img)[..., 3].min() < 255:
        # Already cut (Minos poses, D-229).
        if size is not None and img.size != size:
            img = img.resize(size, Image.LANCZOS)
        return np.asarray(img).copy()
    img = img.convert("RGB")
    if size is not None and img.size != size:
        img = img.resize(size, Image.LANCZOS)
    rgb = np.asarray(img)
    protect = (0, 0, rgb.shape[1], rgb.shape[0]) if big_holes else None
    return cut_out(rgb, inner=inner, protect=protect, hole_radius=drawing_hole_radius(rgb.shape[1]))


# --- placing ------------------------------------------------------------------

def figure_box(rgba: np.ndarray) -> tuple[int, int, int, int]:
    ys, xs = np.nonzero(rgba[..., 3] > 128)
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def feet_point(rgba: np.ndarray) -> tuple[float, float, float]:
    """(x, y, figure height) of the feet: bottom of the figure, centred on
    its lowest rows."""
    x0, y0, x1, y1 = figure_box(rgba)
    height = y1 - y0
    band = rgba[max(y0, y1 - int(height * FEET_BAND)): y1, :, 3] > 128
    xs = np.nonzero(band.any(axis=0))[0]
    return float(xs.min() + xs.max() + 1) / 2.0, float(y1), float(height)


def place(rgba: np.ndarray, feet: tuple[float, float], k: float) -> Placed:
    img = Image.fromarray(rgba, "RGBA")
    w, h = max(1, round(img.width * k)), max(1, round(img.height * k))
    img = img.resize((w, h), Image.LANCZOS)
    return Placed(img, (round(-feet[0] * k), round(-feet[1] * k)))


def clip_frames(clip: Clip, ref_height: float) -> list[Placed]:
    if clip.is_video:
        # Every video starts on the reference pose: its first frame gives
        # the scale and the feet of the whole clip (the camera never moves).
        first = cut_out(video(SRC / clip.group / clip.character / clip.source)[0])
        fx, fy, fh = feet_point(first)
        frames = clip_cut_frames(clip)
    else:
        # "a.jpg|b.gif#4": a few drawn poses played in turn, "#k" being one
        # drawing of a GIF (Vertigo, D-247). Each is brought to the canvas of
        # the reference drawing, whose figure gives the scale and the feet.
        inner = "border_only" not in clip.treatments
        big = "protect_all" in clip.treatments
        folder = SRC / clip.group / clip.character
        still = STILL_REFERENCE.get(clip.character)
        ref = image_rgba(folder / still, inner, big_holes=big) if still is not None else None
        size = (ref.shape[1], ref.shape[0]) if ref is not None else None
        frames = []
        for item in clip.source.split("|"):
            name, _, k = item.partition("#")
            frames.append(image_rgba(folder / name, inner, int(k or 0), big, size))
        fx, fy, fh = feet_point(ref if ref is not None else frames[0])
    frames = [lighten(f) for f in frames]
    if "smoke_dark" in clip.treatment.split("+"):
        frames = [darken_smoke(f) for f in frames]
    if "fade_left" in clip.treatment.split("+"):
        frames = [fade_left(f, FADE_LEFT_PX) for f in frames]
    if "fade_sides" in clip.treatments:
        frames = [fade_sides(f, FADE_SIDES_PX) for f in frames]
    if "smoke_darker" in clip.treatment.split("+"):
        frames = [darken_violet(f, SMOKE_EXTRA) for f in frames]
    if "soft_smoke" in clip.treatment.split("+"):
        head_x = figure_box(first)[0] - SOFT_SMOKE_MARGIN if clip.is_video else 0
        frames = [soften_smoke(f, head_x) for f in frames]
    if "fade_smoke_tail" in clip.treatment.split("+"):
        # Only the smoke ahead of the dragon's head (its left edge in the
        # first frame of the video) fades; the violet aura on him stays.
        head_x = figure_box(first)[0] if clip.is_video else 0
        frames = fade_smoke_tail(frames, head_x)
    if clip.tween > 0:
        frames = tween(frames, clip.tween, clip.mode == "loop")
    k = OUTPUT_SCALE * ref_height / fh
    component = next((t for t in clip.treatment.split("+") if t.startswith("component=")), None)
    if component is not None:
        # "component=x:y": only the piece of the drawing that touches that
        # point of the video (one cloud of Asmodeus' smoke, D-241), with its
        # centre as the anchor; scaled like the character.
        px, py = (int(v) for v in component.split("=")[1].split(":"))
        frames = [only_component(f, px, py) for f in frames]
        return [place(f, centre_of(f), k) for f in frames]
    return [place(f, (fx, fy), k) for f in frames]


# --- writing -------------------------------------------------------------------

@dataclass
class Sheet:
    clip: Clip
    path: Path
    frame_size: tuple[int, int]
    columns: int
    count: int
    anchor: tuple[int, int]
    impact: int


def write_sheet(clip: Clip, frames: list[Placed]) -> Sheet:
    x0 = min(p.offset[0] for p in frames)
    y0 = min(p.offset[1] for p in frames)
    x1 = max(p.offset[0] + p.image.width for p in frames)
    y1 = max(p.offset[1] + p.image.height for p in frames)
    # Trim to what is drawn in any frame of the clip.
    boxes = [p.image.getbbox() for p in frames]
    drawn = [(p.offset[0] + b[0], p.offset[1] + b[1], p.offset[0] + b[2], p.offset[1] + b[3])
             for p, b in zip(frames, boxes) if b is not None]
    if drawn:
        x0, y0 = min(b[0] for b in drawn) - PAD, min(b[1] for b in drawn) - PAD
        x1, y1 = max(b[2] for b in drawn) + PAD, max(b[3] for b in drawn) + PAD
    fw, fh = x1 - x0, y1 - y0
    columns = max(1, min(len(frames), MAX_SHEET // fw))
    rows = -(-len(frames) // columns)
    if rows * fh > MAX_SHEET:
        raise SystemExit(f"{clip.character}/{clip.clip}: {len(frames)} frames of {fw}x{fh} do not fit one sheet")
    sheet = Image.new("RGBA", (columns * fw, rows * fh), (0, 0, 0, 0))
    for i, p in enumerate(frames):
        cx, cy = (i % columns) * fw, (i // columns) * fh
        sheet.alpha_composite(p.image, (cx + p.offset[0] - x0, cy + p.offset[1] - y0))
    out = DST / clip.group / clip.character / "frames" / f"{clip.character}_{clip.clip}.webp"
    out.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(out, "WEBP", quality=WEBP_QUALITY, method=6)
    impact = -1
    if clip.impact >= 0:
        if clip.is_video:
            impact = (clip.impact - clip.start) // clip.step * (clip.tween + 1)
        else:
            # A list of drawings: the impact is the index of its drawing.
            impact = clip.impact * (clip.tween + 1)
    return Sheet(clip, out, (fw, fh), columns, len(frames), (-x0, -y0), impact)


def res_path(path: Path) -> str:
    return "res://" + path.relative_to(ROOT / "game").as_posix()


def write_resource(char: Character, sheets: list[Sheet], ref_height: float) -> Path:
    lines = [
        '[gd_resource type="Resource" script_class="CharacterFrames" format=3]',
        "",
        '[ext_resource type="Script" path="res://scenes/battle/character_frames.gd" id="1_set"]',
        '[ext_resource type="Script" path="res://scenes/battle/frame_clip.gd" id="2_clip"]',
        "",
    ]
    ids: list[str] = []
    for s in sheets:
        sub = f"clip_{s.clip.clip}"
        ids.append(f'SubResource("{sub}")')
        # A clip of one frame is a pose: it holds for its pose time.
        fps = s.clip.fps(char.speed) if s.count > 1 else 0.0
        lines += [
            f'[sub_resource type="Resource" id="{sub}"]',
            'script = ExtResource("2_clip")',
            f'id = &"{s.clip.clip}"',
            f'sheet_path = "{res_path(s.path)}"',
            f"frame_size = Vector2i({s.frame_size[0]}, {s.frame_size[1]})",
            f"columns = {s.columns}",
            f"count = {s.count}",
            f"fps = {fps:g}",
            f"looping = {'true' if s.clip.mode == 'loop' else 'false'}",
            f"anchor = Vector2({s.anchor[0]}, {s.anchor[1]})",
            f"impact_frame = {s.impact}",
            "",
        ]
    lines += [
        "[resource]",
        'script = ExtResource("1_set")',
        f'character_id = &"{char.id}"',
        f"figure_height = {OUTPUT_SCALE * ref_height:.1f}",
        f"display_scale = {char.display_scale:g}",
        f'attack_style = &"{char.attack_style}"',
        f'spell_style = &"{char.spell_style}"',
        f'blessing_style = &"{char.blessing_style}"',
        f'clips = Array[ExtResource("2_clip")]([{", ".join(ids)}])',
        "",
    ]
    out = RES_DIR / f"{char.id}_frames.tres"
    out.write_text("\n".join(lines), encoding="utf-8")
    return out


def preview(char: Character, all_frames: dict[str, list[Placed]], folder: Path) -> None:
    """Every kept frame side by side on grey, feet on one red line: the
    check of asset-pipeline §7 (same scale, same ground line)."""
    cells = [(name, p) for name, frames in all_frames.items() for p in frames]
    x0 = min(p.offset[0] for _, p in cells)
    y0 = min(p.offset[1] for _, p in cells)
    x1 = max(p.offset[0] + p.image.width for _, p in cells)
    cw, top = x1 - x0, -y0
    scale = 160.0 / (top + 20)
    cols = 16
    rows = -(-len(cells) // cols)
    w, h = int(cw * scale), int((top + 20) * scale)
    out = Image.new("RGBA", (cols * w, rows * h), (110, 110, 110, 255))
    for i, (_, p) in enumerate(cells):
        cell = Image.new("RGBA", (cw, top + 20), (110, 110, 110, 255))
        cell.alpha_composite(p.image, (p.offset[0] - x0, p.offset[1] - y0))
        for x in range(cw):
            cell.putpixel((x, top), (255, 40, 40, 255))
        out.alpha_composite(cell.resize((w, h)), ((i % cols) * w, (i // cols) * h))
    folder.mkdir(parents=True, exist_ok=True)
    out.save(folder / f"{char.id}_frames.png")


def run(only: list[str], preview_dir: Path | None) -> int:
    for char in read_clips():
        if only and char.id not in only:
            continue
        ref = char.clips[0]  # the idle clip: its video sets the scale
        if ref.is_video:
            _, _, ref_height = feet_point(cut_out(video(SRC / ref.group / ref.character / ref.source)[0]))
        else:
            _, _, ref_height = feet_point(image_rgba(SRC / ref.group / ref.character / ref.source))
        ref_height = min(ref_height, MAX_FIGURE_PX / OUTPUT_SCALE)
        sheets: list[Sheet] = []
        placed: dict[str, list[Placed]] = {}
        for clip in char.clips:
            frames = clip_frames(clip, ref_height)
            placed[clip.clip] = frames
            sheets.append(write_sheet(clip, frames))
            s = sheets[-1]
            print(f"{char.id:20} {clip.clip:7} {s.count:3} frames {s.frame_size[0]}x{s.frame_size[1]} "
                  f"{s.path.stat().st_size // 1024} KB")
        print("  ->", write_resource(char, sheets, ref_height).relative_to(ROOT))
        if preview_dir is not None:
            preview(char, placed, preview_dir)
    return 0


if __name__ == "__main__":
    args = sys.argv[1:]
    folder = None
    if "--preview" in args:
        i = args.index("--preview")
        folder = Path(args[i + 1])
        del args[i: i + 2]
    sys.exit(run(args, folder))
