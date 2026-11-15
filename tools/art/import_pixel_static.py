#!/usr/bin/env python3
"""Still pixel art of the game (T65, ADR-0013): cuts the cathedral interface
pieces out of the approved sheets and brings the converted Circle 2 scenery
into game/assets/pixel/ (outside Git LFS). Development tool: run from the
repository root, `python3 tools/art/import_pixel_static.py`. It generates no
art; it only cuts and copies what Alan approved (D-368, D-378 to D-380).
"""
import math
from pathlib import Path

from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[2]
SHEETS = ROOT / "docs/fable/piloto-pixel"
SCENERY_SOURCE = ROOT / "art_source/environments/circles/circle_02/pixel"
UI_OUT = ROOT / "game/assets/pixel/ui"
SCENERY_OUT = ROOT / "game/assets/pixel/environments/circle_02"

# Gold reserved for grace (paleta.json, D-367).
GOLD = (0xD9, 0xA5, 0x20, 255)

# piece -> (sheet, x, y, width, height), measured on the approved sheets.
UI_PIECES = {
    "ui_lancet_off": ("ui_a.png", 16, 9, 65, 153),
    "ui_lancet_on": ("ui_a.png", 96, 9, 64, 153),
    "ui_lancet_chosen": ("ui_a.png", 175, 9, 65, 153),
    "ui_rose_off": ("ui_a.png", 45, 170, 79, 78),
    "ui_rose_on": ("ui_a.png", 132, 170, 79, 78),
    "ui_portrait_arch": ("ui_b.png", 17, 6, 103, 169),
    "ui_broken_frame": ("ui_b.png", 146, 16, 92, 119),
    "ui_hook_bag": ("ui_b.png", 186, 150, 34, 92),
    "ui_candle_rack": ("ui_b.png", 14, 189, 150, 53),
}

# Scenery layers the game shows now: leg 1 and the boss arena. The other
# converted layers stay in art_source until their screens use them.
SCENERY = [
    "t1_back", "t1_mid", "t1_front",
    "boss_back", "boss_mid", "boss_front",
]


def save(image: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    alpha = image.getchannel("A")
    if alpha.getextrema() not in ((0, 255), (255, 255)):
        raise SystemExit(f"{path.name}: half transparent pixels (ADR-0013)")
    image.save(path, optimize=True)
    print(f"{path.relative_to(ROOT)}  {image.size[0]} x {image.size[1]}")


def halo_disk(diameter: int) -> Image.Image:
    """The halo as in the approved battle preview (v2): a flat disc of the
    gold reserved for grace."""
    image = Image.new("RGBA", (diameter, diameter), (0, 0, 0, 0))
    ImageDraw.Draw(image).ellipse((0, 0, diameter - 1, diameter - 1), fill=GOLD)
    return image


def halo_rays(side: int) -> Image.Image:
    """Consolation: sixteen thin gold spokes around the disc, drawn by rule."""
    image = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    draw = ImageDraw.Draw(image)
    centre = (side - 1) / 2.0
    for k in range(16):
        angle = math.tau * k / 16
        reach = centre if k % 2 == 0 else centre * 0.8
        draw.line((centre, centre, centre + math.cos(angle) * reach, centre + math.sin(angle) * reach), fill=GOLD, width=1)
    return image


def main() -> None:
    save(halo_disk(44), ROOT / "game/assets/pixel/vfx/halo_disk.png")
    save(halo_rays(71), ROOT / "game/assets/pixel/vfx/halo_rays.png")
    for name, (sheet, x, y, w, h) in UI_PIECES.items():
        piece = Image.open(SHEETS / sheet).convert("RGBA").crop((x, y, x + w, y + h))
        save(piece, UI_OUT / f"{name}.png")
    for layer in SCENERY:
        source = SCENERY_SOURCE / f"env_circle_02_{layer}_px_v01.png"
        save(Image.open(source).convert("RGBA"), SCENERY_OUT / f"env_circle_02_{layer}.png")


if __name__ == "__main__":
    main()
