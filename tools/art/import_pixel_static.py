#!/usr/bin/env python3
"""Still pixel art of the game (T65, ADR-0013): cuts the cathedral interface
pieces out of the approved sheets and brings the converted Circle 2 scenery
into game/assets/pixel/ (outside Git LFS). Development tool: run from the
repository root, `python3 tools/art/import_pixel_static.py`. It generates no
art; it only cuts and copies what Alan approved (D-368, D-378 to D-380).
"""
import json
import math
import sys
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parent))
from import_pixel import snap_to_palette  # noqa: E402

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


# Pieces generated for T65 (D-385): sheet, box, shrink and the name in the
# game. Shrunk pieces are averaged by area and taken back to the palette.
PIXEL_UI = ROOT / "art_source/ui/pixel"
SHEET_PIECES = {
    "ui_lantern_off": ("ui_c_lume_px_v01.png", (16, 14, 76, 167), 0.4),
    "ui_lantern_on": ("ui_c_lume_px_v01.png", (118, 14, 77, 167), 0.4),
    "ui_lume_rod": ("ui_c_lume_px_v01.png", (217, 11, 24, 231), 0.9),
    "ui_oculus": ("ui_d_intent_claw_button_px_v01.png", (14, 15, 69, 69), 0.5),
    "ui_oculus_cracked": ("ui_d_intent_claw_button_px_v01.png", (93, 15, 70, 69), 0.5),
    "ui_claw_grip": ("ui_d_intent_claw_button_px_v01.png", (182, 15, 53, 69), 0.5),
    "ui_claw_dead": ("ui_d_intent_claw_button_px_v01.png", (179, 97, 59, 67), 0.5),
    "ui_button": ("ui_d_intent_claw_button_px_v01.png", (8, 180, 116, 68), 1.0),
    "ui_button_pressed": ("ui_d_intent_claw_button_px_v01.png", (132, 180, 116, 68), 1.0),
}
C02 = ROOT / "art_source/environments/circles/circle_02/pixel"
PROPS = {
    "env_circle_02_entry_door": C02 / "env_circle_02_entry_door_px_v01.png",
    "env_circle_02_entry_cave": C02 / "env_circle_02_entry_cave_px_v01.png",
    "env_circle_02_entry_stair": C02 / "env_circle_02_entry_stair_px_v01.png",
    "env_circle_02_entry_straight": C02 / "env_circle_02_entry_straight_px_v01.png",
    "env_circle_02_tent": C02 / "env_circle_02_tent_px_v01.png",
    "env_circle_02_camp": C02 / "env_circle_02_camp_px_v01.png",
    "prop_reliquary_closed": ROOT / "art_source/environments/props/pixel/prop_reliquary_closed_px_v01.png",
    "prop_reliquary_open": ROOT / "art_source/environments/props/pixel/prop_reliquary_open_px_v01.png",
}
SOULS = (C02 / "env_circle_02_souls_px_v01.png", [(0, 0, 79, 91), (86, 23, 88, 89), (171, 18, 71, 93)])
ICONS_SRC = ROOT / "art_source/ui/pixel/icons"
ICONS_OUT = ROOT / "game/assets/pixel/icons"


def palette_colours() -> np.ndarray:
    data = json.loads((SHEETS / "paleta.json").read_text(encoding="utf-8"))["completa"]
    return np.array([[int(c[i:i + 2], 16) for i in (1, 3, 5)] for c in data], dtype=np.int32)


def tidy(image: Image.Image, scale: float = 1.0) -> Image.Image:
    """Shrinks by area when asked, then every pixel full or empty and in
    the palette (ADR-0013)."""
    image = image.convert("RGBA")
    if scale < 1.0:
        size = (max(1, round(image.size[0] * scale)), max(1, round(image.size[1] * scale)))
        image = image.convert("RGBa").resize(size, Image.BOX).convert("RGBA")
    cell = np.array(image)
    cell[:, :, 3] = np.where(cell[:, :, 3] >= 128, 255, 0)
    cell[cell[:, :, 3] == 0] = 0
    snap_to_palette(cell, palette_colours())
    return Image.fromarray(cell, "RGBA")


def main() -> None:
    for name, (sheet, (x, y, w, h), scale) in SHEET_PIECES.items():
        piece = Image.open(PIXEL_UI / sheet).crop((x, y, x + w, y + h))
        save(tidy(piece, scale), UI_OUT / f"{name}.png")
    for name, source in PROPS.items():
        save(tidy(Image.open(source)), SCENERY_OUT / f"{name}.png")
    for i, (x, y, w, h) in enumerate(SOULS[1]):
        save(tidy(Image.open(SOULS[0]).crop((x, y, x + w, y + h))), SCENERY_OUT / f"env_circle_02_soul_{i + 1}.png")
    for source in sorted(ICONS_SRC.glob("*.png")):
        save(tidy(Image.open(source)), ICONS_OUT / source.name)
    save(halo_disk(26), ROOT / "game/assets/pixel/vfx/halo_disk.png")
    save(halo_rays(42), ROOT / "game/assets/pixel/vfx/halo_rays.png")
    for name, (sheet, x, y, w, h) in UI_PIECES.items():
        piece = Image.open(SHEETS / sheet).convert("RGBA").crop((x, y, x + w, y + h))
        save(piece, UI_OUT / f"{name}.png")
    for layer in SCENERY:
        source = SCENERY_SOURCE / f"env_circle_02_{layer}_px_v01.png"
        save(Image.open(source).convert("RGBA"), SCENERY_OUT / f"env_circle_02_{layer}.png")


if __name__ == "__main__":
    main()
