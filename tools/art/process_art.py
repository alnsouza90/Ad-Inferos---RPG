"""Turns original art (art_source/, never modified) into game assets
(game/assets/), following docs/art/asset-pipeline.md §1, §4 and ADR-0011.

Usage, from the repository root:
    python3 tools/art/process_art.py            # every job below
    python3 tools/art/process_art.py --check    # only report sizes

Needs Pillow. Development tool only: nothing here ships with the game.
"""
from __future__ import annotations

import sys
from collections import deque
from pathlib import Path

from PIL import Image, ImageFilter

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "art_source"
DST = ROOT / "game" / "assets"

# asset-pipeline §4: saint body 1024x1536, figure about 1200 px tall,
# feet 96 px above the bottom edge. Halo 512x512.
BODY_CANVAS = (1024, 1536)
BODY_FIGURE_HEIGHT = 1200
BODY_FEET_MARGIN = 96
HALO_SIZE = 512
PORTRAIT_SIZE = (768, 1024)

# How far (0-255 per channel) a pixel may be from the background grey and
# still count as background. The sticker-style white outline of the
# characters keeps the figure well apart from the grey.
BG_TOLERANCE = 22
# Width of the soft edge, in tolerance units above BG_TOLERANCE.
EDGE_SOFTNESS = 18
# A painted glow (the Consolation image has one behind the head) is grey,
# lighter than the background but darker than the white outline of the
# figure. The flood fill also crosses such pixels, so the glow goes and the
# outline stops it. The Art Direction asks for images without halo or glow.
GLOW_MAX_VALUE = 236
# Background enclosed by the figure (between an arm and the spear) is not
# reached from the border. Such holes go too when they are almost exactly
# the background colour and big enough not to be a detail of the drawing.
HOLE_TOLERANCE = 7
HOLE_MIN_PIXELS = 300
GLOW_MAX_CHROMA = 14

# (source, destination, kind). kind "body": flood fill from the border, so
# grey inside the figure stays; kind "glow": every background-grey pixel
# goes, including holes enclosed by the shape (the rays have one).
# kind "pose": like "body", but scaled with the same factor as the standing
# figure (POSE_REFERENCE), so a kneeling or crouching pose keeps its real
# size instead of being stretched to the full figure height.
POSE_REFERENCE = "characters/saints/saint_george/saint_george_body_idle_v02.jpg"
JOBS = [
    ("characters/saints/saint_george/saint_george_body_idle_v02.jpg",
     "characters/saints/saint_george/body/saint_george_body_idle.png", "pose"),
    ("characters/saints/saint_george/saint_george_body_attack_v01.jpg",
     "characters/saints/saint_george/body/saint_george_body_attack.png", "pose"),
    ("characters/saints/saint_george/saint_george_body_hit_v01.jpg",
     "characters/saints/saint_george/body/saint_george_body_hit.png", "pose"),
    ("characters/saints/saint_george/saint_george_body_fall_v01.jpg",
     "characters/saints/saint_george/body/saint_george_body_fall.png", "pose"),
    ("characters/saints/saint_george/saint_george_portrait_v02.jpg",
     "characters/saints/saint_george/portrait/saint_george_portrait.png", "portrait"),
    ("characters/saints/saint_george/saint_george_body_dark_night_v01.jpg",
     "characters/saints/saint_george/body/saint_george_body_dark_night.png", "body"),
    ("characters/saints/saint_george/saint_george_body_consolation_v01.jpg",
     "characters/saints/saint_george/body/saint_george_body_consolation.png", "body"),
    ("vfx/halo/vfx_halo_disk_v01.jpg", "vfx/halo/vfx_halo_disk.png", "halo_body"),
    ("vfx/halo/vfx_halo_rays_v01.jpg", "vfx/halo/vfx_halo_rays.png", "halo_glow"),
]


def background_colour(img: Image.Image) -> tuple[int, int, int]:
    """Median of the border pixels."""
    w, h = img.size
    px = img.load()
    border = [px[x, 0] for x in range(w)] + [px[x, h - 1] for x in range(w)]
    border += [px[0, y] for y in range(h)] + [px[w - 1, y] for y in range(h)]
    return tuple(sorted(c[i] for c in border)[len(border) // 2] for i in range(3))


def distance(a: tuple[int, int, int], b: tuple[int, int, int]) -> int:
    return max(abs(a[0] - b[0]), abs(a[1] - b[1]), abs(a[2] - b[2]))


def clear_holes(px, ap, w: int, h: int, bg: tuple[int, int, int], seen: bytearray) -> None:
    done = bytearray(w * h)
    for y in range(h):
        for x in range(w):
            i = y * w + x
            if seen[i] or done[i] or distance(px[x, y], bg) > HOLE_TOLERANCE:
                continue
            region = []
            queue = deque([(x, y)])
            done[i] = 1
            while queue:
                cx, cy = queue.popleft()
                region.append((cx, cy))
                for nx, ny in ((cx + 1, cy), (cx - 1, cy), (cx, cy + 1), (cx, cy - 1)):
                    if 0 <= nx < w and 0 <= ny < h:
                        j = ny * w + nx
                        if not done[j] and not seen[j] and distance(px[nx, ny], bg) <= HOLE_TOLERANCE:
                            done[j] = 1
                            queue.append((nx, ny))
            if len(region) >= HOLE_MIN_PIXELS:
                for rx, ry in region:
                    ap[rx, ry] = 0


def is_glow(c: tuple[int, int, int], bg: tuple[int, int, int]) -> bool:
    return min(c) > max(bg) and max(c) <= GLOW_MAX_VALUE and max(c) - min(c) <= GLOW_MAX_CHROMA


def alpha_from_distance(d: int) -> int:
    if d <= BG_TOLERANCE:
        return 0
    if d >= BG_TOLERANCE + EDGE_SOFTNESS:
        return 255
    return round(255 * (d - BG_TOLERANCE) / EDGE_SOFTNESS)


def remove_background(img: Image.Image, flood: bool) -> Image.Image:
    rgb = img.convert("RGB")
    w, h = rgb.size
    px = rgb.load()
    bg = background_colour(rgb)
    alpha = Image.new("L", (w, h), 255)
    ap = alpha.load()
    if flood:
        # Background = grey pixels connected to the border; the soft edge is
        # the ring of near-grey pixels around it.
        seen = bytearray(w * h)
        queue: deque[tuple[int, int]] = deque()
        for x in range(w):
            queue.extend(((x, 0), (x, h - 1)))
        for y in range(h):
            queue.extend(((0, y), (w - 1, y)))
        while queue:
            x, y = queue.popleft()
            i = y * w + x
            if seen[i]:
                continue
            seen[i] = 1
            d = distance(px[x, y], bg)
            if is_glow(px[x, y], bg):
                ap[x, y] = 0
                for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                    if 0 <= nx < w and 0 <= ny < h and not seen[ny * w + nx]:
                        queue.append((nx, ny))
                continue
            if d >= BG_TOLERANCE + EDGE_SOFTNESS:
                continue
            ap[x, y] = alpha_from_distance(d)
            if d > BG_TOLERANCE:
                continue  # edge pixel: keep it, do not spread through it
            for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
                if 0 <= nx < w and 0 <= ny < h and not seen[ny * w + nx]:
                    queue.append((nx, ny))
        clear_holes(px, ap, w, h, bg, seen)
    else:
        for y in range(h):
            for x in range(w):
                ap[x, y] = alpha_from_distance(distance(px[x, y], bg))
    # A light blur removes the stair-step on the cut edge.
    alpha = alpha.filter(ImageFilter.GaussianBlur(0.7))
    out = rgb.convert("RGBA")
    out.putalpha(alpha)
    return out


def fit_body(img: Image.Image, scale: float = 0.0) -> Image.Image:
    """Scales the figure (to BODY_FIGURE_HEIGHT, or by `scale`) and stands
    it on the canvas, feet BODY_FEET_MARGIN above the bottom."""
    figure = img.crop(img.getbbox())
    if scale <= 0.0:
        scale = BODY_FIGURE_HEIGHT / figure.height
    figure = figure.resize((round(figure.width * scale), round(figure.height * scale)), Image.LANCZOS)
    if figure.width > BODY_CANVAS[0]:
        print(f"  aviso: figura mais larga que a tela ({figure.width}px); reduzida")
        scale = BODY_CANVAS[0] / figure.width
        figure = figure.resize((BODY_CANVAS[0], round(figure.height * scale)), Image.LANCZOS)
    canvas = Image.new("RGBA", BODY_CANVAS, (0, 0, 0, 0))
    x = (BODY_CANVAS[0] - figure.width) // 2
    y = BODY_CANVAS[1] - BODY_FEET_MARGIN - figure.height
    canvas.paste(figure, (x, y), figure)
    return canvas


def fit_portrait(img: Image.Image) -> Image.Image:
    shape = img.crop(img.getbbox())
    scale = min(PORTRAIT_SIZE[0] / shape.width, PORTRAIT_SIZE[1] / shape.height)
    shape = shape.resize((round(shape.width * scale), round(shape.height * scale)), Image.LANCZOS)
    canvas = Image.new("RGBA", PORTRAIT_SIZE, (0, 0, 0, 0))
    canvas.paste(shape, ((PORTRAIT_SIZE[0] - shape.width) // 2, PORTRAIT_SIZE[1] - shape.height), shape)
    return canvas


def pose_scale() -> float:
    """Factor that brings the standing reference figure to BODY_FIGURE_HEIGHT."""
    ref = remove_background(Image.open(SRC / POSE_REFERENCE), flood=True)
    box = ref.getbbox()
    return BODY_FIGURE_HEIGHT / (box[3] - box[1])


def fit_halo(img: Image.Image) -> Image.Image:
    shape = img.crop(img.getbbox())
    side = max(shape.size)
    square = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    square.paste(shape, ((side - shape.width) // 2, (side - shape.height) // 2), shape)
    return square.resize((HALO_SIZE, HALO_SIZE), Image.LANCZOS)


def run(check_only: bool) -> int:
    scale = 0.0 if check_only else pose_scale()
    for src_rel, dst_rel, kind in JOBS:
        src = SRC / src_rel
        if not src.exists() or src.stat().st_size < 1024:
            print(f"falta o original (Git LFS?): {src_rel}")
            return 1
        img = Image.open(src)
        print(f"{src_rel}: {img.size}")
        if check_only:
            continue
        cut = remove_background(img, flood=kind != "halo_glow")
        if kind == "body":
            out = fit_body(cut)
        elif kind == "pose":
            out = fit_body(cut, scale)
        elif kind == "portrait":
            out = fit_portrait(cut)
        else:
            out = fit_halo(cut)
        dst = DST / dst_rel
        dst.parent.mkdir(parents=True, exist_ok=True)
        out.save(dst, optimize=True)
        print(f"  -> {dst_rel} {out.size}")
    return 0


if __name__ == "__main__":
    sys.exit(run("--check" in sys.argv))
