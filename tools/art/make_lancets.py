"""Bakes the lancet and rose windows of the battle panel (T44, D-436 to D-438).

Each kind of ability has its stained-glass mosaic (docs/art/reference/mosaicos/
mosaic_<kind>.png, PixelLab, approved by Alan); each saint has the medallion
of their miracle (rose_<saint>.png). The tool puts each mosaic in the glass of
the approved lancet and rose pieces and writes the three states the panel
shows:

- off: dark glass, almost no colour (cannot be used now);
- on: the colours of the glass, lit pale from behind;
- chosen: warm amber light through the glass.

Writes game/assets/pixel/ui/lancets/lancet_<kind>_<state>.png and
game/assets/pixel/ui/roses/rose_<saint id>_<state>.png. The sources are never
changed. Usage, from the repository root:

    python3 tools/art/make_lancets.py

Needs Pillow. Development tool only (ADR-0011).
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageEnhance

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "docs" / "art" / "reference" / "mosaicos"
UI = ROOT / "game" / "assets" / "pixel" / "ui"
KINDS = ["strike", "exorcism", "heal", "relief", "ward", "strength", "cleanse", "raise", "displace", "strip"]
ROSES = {"saint_george": "rose_george.png", "saint_benedict": "rose_benedict.png", "saint_therese": "rose_therese.png"}
# The glass of the lancet piece (64 × 153): under the tracery, inside the
# iron frame; measured on ui_lancet_on.png.
GLASS = (12, 52, 52, 142)
# The rose piece (79 × 78): the round glass inside the iron ring.
ROSE_CENTER = (39.5, 39.0)
ROSE_RADIUS = 29.5
ROSE_MEDALLION = 60


def lit(img: Image.Image, state: str) -> Image.Image:
    if state == "off":
        return ImageEnhance.Brightness(ImageEnhance.Color(img).enhance(0.2)).enhance(0.45)
    if state == "chosen":
        warm = img.copy()
        warm.alpha_composite(Image.new("RGBA", img.size, (255, 170, 60, 80)))
        return ImageEnhance.Brightness(warm).enhance(1.15)
    return img


def shield_strike(mosaic: Image.Image) -> Image.Image:
    """The shield of Amparo in a blood tint (D-440): only the grey and bone
    glass of the shield turns red; the violet and blue ground stays."""
    out = mosaic.copy()
    px = out.load()
    for y in range(out.height):
        for x in range(out.width):
            r, g, b, a = px[x, y]
            if a and max(r, g, b) - min(r, g, b) < 40 and max(r, g, b) > 60:
                light = (r + g + b) / 3 / 255
                px[x, y] = (int(90 + 140 * light), int(28 + 40 * light), int(28 + 30 * light), a)
    return out


def lancet(mosaic: Image.Image, state: str) -> Image.Image:
    frame = Image.open(UI / "ui_lancet_on.png").convert("RGBA")
    x0, y0, x1, y1 = GLASS
    glass = lit(mosaic.resize((x1 - x0 + 2, y1 - y0 + 2), Image.NEAREST), state)
    frame.paste(glass.crop((1, 1, x1 - x0 + 1, y1 - y0 + 1)), (x0, y0))
    return frame


def rose(medallion: Image.Image, state: str) -> Image.Image:
    piece = Image.open(UI / "ui_rose_on.png").convert("RGBA")
    m = lit(medallion.resize((ROSE_MEDALLION, ROSE_MEDALLION), Image.NEAREST), state)
    px, mp = piece.load(), m.load()
    cx, cy = ROSE_CENTER
    ox, oy = int(cx - ROSE_MEDALLION / 2), int(cy - ROSE_MEDALLION / 2)
    for y in range(piece.height):
        for x in range(piece.width):
            if (x - cx) ** 2 + (y - cy) ** 2 < ROSE_RADIUS ** 2:
                mx, my = x - ox, y - oy
                if 0 <= mx < ROSE_MEDALLION and 0 <= my < ROSE_MEDALLION:
                    px[x, y] = mp[mx, my]
    return piece


def main() -> None:
    (UI / "lancets").mkdir(exist_ok=True)
    (UI / "roses").mkdir(exist_ok=True)
    for kind in KINDS:
        mosaic = Image.open(SRC / f"mosaic_{kind}.png").convert("RGBA")
        for state in ("off", "on", "chosen"):
            lancet(mosaic, state).save(UI / "lancets" / f"lancet_{kind}_{state}.png", optimize=True)
    shield = shield_strike(Image.open(SRC / "mosaic_ward.png").convert("RGBA"))
    for state in ("off", "on", "chosen"):
        lancet(shield, state).save(UI / "lancets" / f"lancet_shield_strike_{state}.png", optimize=True)
    for saint, file_name in ROSES.items():
        medallion = Image.open(SRC / file_name).convert("RGBA")
        for state in ("off", "on"):
            rose(medallion, state).save(UI / "roses" / f"rose_{saint}_{state}.png", optimize=True)
    print(f"{len(KINDS) * 3} lancetas e {len(ROSES) * 2} rosáceas em {UI}")


if __name__ == "__main__":
    main()
