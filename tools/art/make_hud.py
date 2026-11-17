"""Prepares the finishing pieces of the interface (T44, D-440, D-441).

The pieces come from PixelLab (docs/art/reference/hud/, approved by Alan):
stone panel background, iron tile frame, nine-slice plate, map tablet,
node medallion, bar frames, top band, mini-map rail. The tool crops them,
clears the white the generator left around the map tablet, darkens its
stone and writes them to game/assets/pixel/ui/. The sources never change.

    python3 tools/art/make_hud.py

Needs Pillow. Development tool only (ADR-0011).
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageEnhance

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / "docs" / "art" / "reference" / "hud"
UI = ROOT / "game" / "assets" / "pixel" / "ui"
# Brightness of the map's stone, so the nodes read on it (Alan saw it at 0.62).
TABLET_BRIGHTNESS = 0.62


def load(name: str) -> Image.Image:
    return Image.open(SRC / f"{name}.png").convert("RGBA")


def x2(img: Image.Image) -> Image.Image:
    return img.resize((img.width * 2, img.height * 2), Image.NEAREST)


def main() -> None:
    # The panel's stone, shown 2× like the scenery; repeats sideways.
    x2(load("panel_bg")).crop((0, 6, 512, 186)).save(UI / "ui_panel_stone.png", optimize=True)
    load("tile").crop((4, 0, 63, 53)).save(UI / "ui_tile_frame.png", optimize=True)
    load("plate9").crop((2, 2, 62, 62)).save(UI / "ui_plate9.png", optimize=True)
    load("medallion").save(UI / "ui_medallion.png", optimize=True)
    load("bar_frame").crop((7, 0, 89, 16)).save(UI / "ui_bar_frame.png", optimize=True)
    load("boss_bar").crop((2, 0, 255, 32)).save(UI / "ui_boss_bar.png", optimize=True)
    load("top_band").crop((0, 4, 256, 20)).save(UI / "ui_top_band.png", optimize=True)
    load("rail").crop((0, 4, 160, 37)).save(UI / "ui_rail.png", optimize=True)
    tablet = load("map_tablet")
    px = tablet.load()
    for y in range(tablet.height):
        for x in range(tablet.width):
            r, g, b, a = px[x, y]
            if r > 215 and g > 215 and b > 200:
                px[x, y] = (0, 0, 0, 0)
    tablet = ImageEnhance.Brightness(tablet).enhance(TABLET_BRIGHTNESS)
    x2(tablet).save(UI / "ui_map_tablet.png", optimize=True)
    print("peças do acabamento em", UI)


if __name__ == "__main__":
    main()
