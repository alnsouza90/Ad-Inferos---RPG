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

# Frames are kept a little under the video size (figure ~575 px, D-224):
# enough for the figure on a 1080 px stage, lighter on the phone.
OUTPUT_SCALE = 0.9
# The Wan 3 videos are 30 frames per second; a clip plays its kept frames
# at 30 / step, so its timing is the one of the video.
VIDEO_FPS = 30.0
# Room around the union of the frames of a clip, in output pixels.
PAD = 4
# Largest sheet side (safe on the phones we target).
MAX_SHEET = 4096
# Sheets are stored as lossy WebP: the frames are painted art, and PNG made
# the set too heavy for the repository (LFS quota) and the web build.
WEBP_QUALITY = 88

# Characters that never leave their place: Minos never rises from the
# throne (D-219), so his attack is played where he sits.
STATIONARY = {"elite_minos"}

# Drawn poses share the framing of the drawn idle pose (same canvas at
# another resolution, D-229, D-230): they are scaled and placed by the
# canvas, through that idle drawing, so a raised tail does not shrink the
# figure.
STILL_REFERENCE = {"elite_minos": "elite_minos_body_idle_v01.jpg"}

# Background: grey, connected to the border (same idea as process_art.py,
# vectorised because a video gives hundreds of frames).
BG_TOLERANCE = 20
EDGE_SOFTNESS = 18
# Enclosed background: pixels this close to the grey, in a patch at least
# 2 * HOLE_RADIUS + 1 pixels across, go too.
HOLE_TOLERANCE = 9
HOLE_RADIUS = 5
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
        return self.source.endswith(".mp4")


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
    return list(chars.values())


# --- reading ------------------------------------------------------------------

def video_frames(path: Path) -> np.ndarray:
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
    frames = video(SRC / clip.group / clip.character / clip.source)
    out: list[np.ndarray] = []
    for i in range(clip.start, clip.end, clip.step):
        f = cut_out(frames[i])
        if clip.mode == "loop" and clip.blend > 0 and i >= clip.end - clip.blend:
            twin = clip.start - (clip.end - i)
            if twin >= 0:
                t = (i - (clip.end - clip.blend) + 1) / (clip.blend + 1)
                f = mix(f, cut_out(frames[twin]), t)
        out.append(f)
    return out


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


def cut_out(rgb: np.ndarray) -> np.ndarray:
    """RGBA with the grey background made transparent: the grey connected to
    the border, and enclosed patches of almost exactly the background grey
    big enough not to be a detail (between veils, under a wing). Edge pixels
    are un-mixed from the grey so no light fringe is left."""
    bg = border_colour(rgb)
    dist = np.abs(rgb.astype(np.float32) - bg).max(axis=2)
    soft = dist < BG_TOLERANCE + EDGE_SOFTNESS
    flat = dist <= BG_TOLERANCE
    border = np.zeros_like(flat)
    border[0, :] = border[-1, :] = True
    border[:, 0] = border[:, -1] = True
    holes = erode(dist <= HOLE_TOLERANCE, HOLE_RADIUS)
    core = grow(border | holes, flat)
    # The soft ring counts only next to the cut background.
    near = np.zeros_like(core)
    near[1:, :] |= core[:-1, :]
    near[:-1, :] |= core[1:, :]
    near[:, 1:] |= core[:, :-1]
    near[:, :-1] |= core[:, 1:]
    ring = soft & near & ~core
    alpha = np.ones(dist.shape, np.float32)
    alpha[core] = 0.0
    alpha[ring] = np.clip((dist[ring] - BG_TOLERANCE) / EDGE_SOFTNESS, 0.0, 1.0)
    colour = rgb.astype(np.float32)
    a = np.maximum(alpha, 1e-3)[..., None]
    colour = np.where(alpha[..., None] < 1.0, (colour - (1.0 - a) * bg) / a, colour)
    return np.dstack([colour.clip(0, 255), alpha * 255.0]).astype(np.uint8)


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


def image_rgba(path: Path) -> np.ndarray:
    img = Image.open(path)
    if img.mode == "RGBA" and np.asarray(img)[..., 3].min() < 255:
        return np.asarray(img).copy()  # already cut (Minos poses, D-229)
    return cut_out(np.asarray(img.convert("RGB")))


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
        frames = [image_rgba(SRC / clip.group / clip.character / clip.source)]
        fx, fy, fh = feet_point(frames[0])
        still = STILL_REFERENCE.get(clip.character)
        if still is not None:
            ref = image_rgba(SRC / clip.group / clip.character / still)
            rx, ry, rh = feet_point(ref)
            ratio = frames[0].shape[0] / ref.shape[0]
            fx, fy, fh = rx * ratio, ry * ratio, rh * ratio
    if clip.treatment == "smoke_dark":
        frames = [darken_smoke(f) for f in frames]
    k = OUTPUT_SCALE * ref_height / fh
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
        impact = (clip.impact - clip.start) // clip.step if clip.is_video else 0
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
        fps = VIDEO_FPS / s.clip.step if s.clip.is_video else 0.0
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
        f"stationary = {'true' if char.id in STATIONARY else 'false'}",
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
