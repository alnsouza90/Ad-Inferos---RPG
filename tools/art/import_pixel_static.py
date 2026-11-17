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

# Scenery layers the game shows (D-445, D-446): the sets of the three legs,
# the common skies and middles they mix, and the boss arena.
SCENERY = [
    "t1_back", "t1_mid", "t1_front",
    "t2_mid", "t2_front",
    "t3_back", "t3_mid", "t3_front",
    "common_back_storm", "common_back_storm_eye",
    "common_mid_plain", "common_mid_rock_wall",
    "boss_back", "boss_mid", "boss_front",
]
# Layers drawn at half size and shown 2x (D-446): name -> rows cut from the
# bottom, so that each one meets the ground line as in the approved previews.
DOUBLED_LAYERS = {
    "jury_hall": 34,
    "tigris": 62,
    "souls_crowd": 0,
    # The way to Minos (D-448): the paving of the wall under the feet; its
    # door is cut 22 rows higher still, so that it stands on the feet line.
    "jury_wall": 22,
}
# The door of the jury hall (D-448): only its arch and leaves, cut from the
# generated piece (left, top, right, bottom on the source), its colours taken
# to those of the wall, so it fits into one bay of the wall without a seam.
JURY_DOOR_BOX = (52, 92, 140, 230)
# Animated pieces (D-446): name -> (frames, frame side, height in the game).
ANIMATED = {
    "couple": (8, 256, 150),
    "fish": (8, 192, 110),
}
# The purple slabs as the floor of the jury hall (D-446, option B): shown
# 2x, only their top rows, laid under the feet.
FLOOR_SLAB_ROWS = 44
EVENT_ART = {
    "scene_raphael_binds": ROOT / "art_source/events/circle_02/scene_raphael_binds_px_v02.png",
    "event_c02_soul_lovers": ROOT / "art_source/events/circle_02/event_c02_soul_lovers_px_v01.png",
}
EVENTS_OUT = ROOT / "game/assets/events/circle_02"
# Saint Raphael at the victory with the liver (bosses.md §5.3, D-452): Alan's
# PixelLab drawing shrunk to RAPHAEL_HEIGHT, with a one-pixel gold edge, and
# the same shape in flat gold (he appears gold, flickers, becomes himself).
RAPHAEL_SOURCE = ROOT / "art_source/characters/archangels/archangel_raphael_px_v01.png"
RAPHAEL_HEIGHT = 190
RAPHAEL_OUT = ROOT / "game/assets/pixel/characters/archangel_raphael"
# The white stamp of each saint's miracle (D-424): Alan's images, reduced to
# the pixel grid; light pixels become flat angelic white, everything else
# empty (Art Bible §6.1: white, flat, hard edge, no outline).
STAMPS = {
    "saint_therese": ROOT / "art_source/vfx/stamps/stamp_saint_therese_src_v01.png",
    "saint_benedict": ROOT / "art_source/vfx/stamps/stamp_saint_benedict_src_v01.jpg",
    "saint_george": ROOT / "art_source/vfx/stamps/stamp_saint_george_src_v01.png",
}
# The stamps of the saints' abilities (D-452): one drawing each, moved by the
# engine (SaintStamp), with the share each is shrunk to; the first shield was the whole frame of the first sheet, its
# lower half mirrored from the upper (the sheet cut it).
ABILITY_STAMPS = {"shield": 0.75, "cross": 1.0, "ring": 1.0, "petal": 0.6}
# Sources in use (D-453, D-454): the shield drawn again on its own; one
# petal cut from the sheet of petals, scattered by the engine.
ABILITY_STAMP_VERSIONS = {"shield": 2}
# The enemies' ink (D-454): sheets of six frames in a grid of three columns
# and two rows on a flat light grey; each cell is cleaned and laid in a row.
# name -> (source, anchor): "centre" keeps each cell as drawn; "bottom" sets
# every cell's drawing on the same ground line (the stain rises from it).
INK_SHEETS = {"slash": ("ink_slash_px_v01.png", "centre"), "stain": ("ink_stain_px_v01.png", "bottom"), "pool": ("ink_pool_px_v01.png", "bottom")}
INK_GRID = (3, 2)
INK_BACKGROUND_TOLERANCE = 40
# Row of a grounded cell that stands on the feet (the rest hangs below).
INK_GROUND_LINE = 92
STAMP_HEIGHT = 220
STAMP_WHITE = (0xF1, 0xEC, 0xE0, 255)
STAMP_THRESHOLD = 150
EVENT_SIZE = (1920, 1080)


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
    "env_circle_02_wall": C02 / "env_circle_02_prop_wall_px_v01.png",
    "env_circle_02_arcade": C02 / "env_circle_02_prop_arcade_px_v01.png",
    "env_circle_02_pinnacle": C02 / "env_circle_02_prop_pinnacle_px_v01.png",
    "env_circle_02_slabs": C02 / "env_circle_02_prop_floor_slabs_px_v01.png",
    "prop_reliquary_closed": ROOT / "art_source/environments/props/pixel/prop_reliquary_closed_px_v01.png",
    "prop_reliquary_open": ROOT / "art_source/environments/props/pixel/prop_reliquary_open_px_v01.png",
}
# Props shown 2x (D-448): the tent was smaller than a saint; a pavilion
# someone walks into stands taller than them.
DOUBLED_PROPS = {"env_circle_02_tent"}
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
        piece = tidy(Image.open(source))
        if name in DOUBLED_PROPS:
            piece = piece.resize((piece.width * 2, piece.height * 2), Image.NEAREST)
        save(piece, SCENERY_OUT / f"{name}.png")
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
    for layer, cut in DOUBLED_LAYERS.items():
        image = tidy(Image.open(SCENERY_SOURCE / f"env_circle_02_{layer}_px_v01.png"))
        image = image.resize((image.width * 2, image.height * 2), Image.NEAREST)
        save(image.crop((0, 0, image.width, image.height - cut)), SCENERY_OUT / f"env_circle_02_{layer}.png")
    save(jury_door(), SCENERY_OUT / "env_circle_02_jury_door.png")
    slabs = tidy(Image.open(C02 / "env_circle_02_prop_floor_slabs_px_v01.png"))
    slabs = slabs.crop(slabs.getbbox())
    slabs = slabs.resize((slabs.width * 2, slabs.height * 2), Image.NEAREST)
    save(slabs.crop((0, 0, slabs.width, FLOOR_SLAB_ROWS)), SCENERY_OUT / "env_circle_02_jury_floor.png")
    for name, (count, side, height) in ANIMATED.items():
        save(animated_strip(C02 / f"env_circle_02_{name}_px_v01.png", count, side, height), SCENERY_OUT / f"env_circle_02_{name}.png")
    for name, times in ABILITY_STAMPS.items():
        version = ABILITY_STAMP_VERSIONS.get(name, 1)
        source = Image.open(ROOT / f"art_source/vfx/stamps/stamp_{name}_px_v{version:02d}.png")
        piece = tidy(source.crop(source.getbbox()), times) if times < 1.0 else tidy(source)
        piece = piece.crop(piece.getbbox())
        save(piece, ROOT / f"game/assets/pixel/vfx/stamp_{name}.png")
    for name, (file_name, anchor) in INK_SHEETS.items():
        save(ink_strip(ROOT / "art_source/vfx/stamps" / file_name, anchor), ROOT / f"game/assets/pixel/vfx/ink_{name}.png")
    for name, source in STAMPS.items():
        save(stamp(source), ROOT / f"game/assets/pixel/vfx/stamp_{name}.png")
    figure, gold = raphael()
    save(figure, RAPHAEL_OUT / "archangel_raphael.png")
    save(gold, RAPHAEL_OUT / "archangel_raphael_gold.png")
    for name, source in EVENT_ART.items():
        save(event_art(source), EVENTS_OUT / f"{name}.png")


def jury_door() -> Image.Image:
    """The arch and leaves of the door, each colour channel scaled so the
    stone matches the mean of the wall, back in the palette, shown 2x."""
    wall = np.array(Image.open(C02 / "env_circle_02_jury_wall_px_v01.png").convert("RGBA")).astype(float)
    door = Image.open(C02 / "env_circle_02_jury_door_px_v01.png").convert("RGBA").crop(JURY_DOOR_BOX)
    cell = np.array(door).astype(float)
    wall_mean = wall[wall[:, :, 3] > 0][:, :3].mean(0)
    door_mean = cell[cell[:, :, 3] > 0][:, :3].mean(0)
    cell[:, :, :3] = np.clip(cell[:, :, :3] * (wall_mean / door_mean), 0, 255)
    image = tidy(Image.fromarray(cell.round().astype(np.uint8), "RGBA"))
    return image.resize((image.width * 2, image.height * 2), Image.NEAREST)


def animated_strip(source: Path, count: int, side: int, height: int) -> Image.Image:
    """The frames cut to the box they share, shrunk to `height` by area and
    tidied, in one row."""
    sheet = Image.open(source).convert("RGBA")
    frames = [sheet.crop((i * side, 0, (i + 1) * side, side)) for i in range(count)]
    box = frames[0].getbbox()
    for frame in frames[1:]:
        b = frame.getbbox()
        box = (min(box[0], b[0]), min(box[1], b[1]), max(box[2], b[2]), max(box[3], b[3]))
    scale = height / (box[3] - box[1])
    cells = [tidy(frame.crop(box), scale) for frame in frames]
    strip = Image.new("RGBA", (cells[0].width * count, cells[0].height), (0, 0, 0, 0))
    for i, cell in enumerate(cells):
        strip.paste(cell, (i * cell.width, 0))
    return strip


def raphael() -> tuple[Image.Image, Image.Image]:
    """The figure with a one-pixel gold edge around it, and its flat gold
    silhouette (edge included)."""
    image = Image.open(RAPHAEL_SOURCE).convert("RGBA")
    image = image.crop(image.getbbox())
    image = tidy(image, RAPHAEL_HEIGHT / image.height)
    body = np.zeros((image.height + 2, image.width + 2), dtype=bool)
    body[1:-1, 1:-1] = np.array(image)[:, :, 3] > 0
    edge = np.zeros_like(body)
    for dy, dx in ((-1, 0), (1, 0), (0, -1), (0, 1)):
        edge |= np.roll(np.roll(body, dy, 0), dx, 1)
    edge &= ~body
    cell = np.zeros(body.shape + (4,), dtype=np.uint8)
    cell[edge] = GOLD
    figure = Image.fromarray(cell, "RGBA")
    figure.alpha_composite(image, (1, 1))
    flat = np.zeros_like(cell)
    flat[edge | body] = GOLD
    return figure, Image.fromarray(flat, "RGBA")


def ink_strip(source: Path, anchor: str = "centre") -> Image.Image:
    """The six cells of the grid, the flat grey around them made empty, all
    cells the same size, in one row (reading order)."""
    sheet = np.array(Image.open(source).convert("RGBA"))
    background = sheet[0, 0, :3].astype(int)
    empty = np.abs(sheet[:, :, :3].astype(int) - background).sum(2) <= INK_BACKGROUND_TOLERANCE
    sheet[empty] = 0
    image = Image.fromarray(sheet, "RGBA")
    columns, rows = INK_GRID
    cell_w, cell_h = image.width // columns, image.height // rows
    cells = [tidy(image.crop((c * cell_w, r * cell_h, (c + 1) * cell_w, (r + 1) * cell_h))) for r in range(rows) for c in range(columns)]
    if anchor == "bottom":
        # Each cell's widest row (the surface of the pool, the foot of the
        # column) goes to the same ground line; drips hang below it.
        grounded = []
        for cell in cells:
            alpha = np.array(cell)[:, :, 3] > 0
            moved = Image.new("RGBA", cell.size, (0, 0, 0, 0))
            if alpha.any():
                widest = int(np.argmax(alpha.sum(1)))
                moved.paste(cell, (0, INK_GROUND_LINE - widest))
            grounded.append(moved)
        cells = grounded
    strip = Image.new("RGBA", (cell_w * len(cells), cell_h), (0, 0, 0, 0))
    for i, cell in enumerate(cells):
        strip.paste(cell, (i * cell_w, 0))
    return strip


def stamp(source: Path) -> Image.Image:
    """Light and opaque pixels of the source, cut to their box and shrunk by
    area to STAMP_HEIGHT, become flat white; the rest is empty."""
    image = Image.open(source).convert("RGBA")
    flat = Image.new("RGBA", image.size, (0, 0, 0, 255))
    flat.alpha_composite(image)
    grey = flat.convert("L")
    grey = grey.crop(grey.point(lambda v: 255 if v >= STAMP_THRESHOLD else 0).getbbox())
    width = max(1, round(grey.width * STAMP_HEIGHT / grey.height))
    grey = grey.resize((width, STAMP_HEIGHT), Image.BOX)
    cell = np.zeros((STAMP_HEIGHT, width, 4), dtype=np.uint8)
    cell[np.array(grey) >= STAMP_THRESHOLD] = STAMP_WHITE
    return Image.fromarray(cell, "RGBA")


def event_art(source: Path) -> Image.Image:
    """A story panel in pixel (D-446): 4x by nearest, cut to the event
    screen from the middle."""
    image = Image.open(source).convert("RGBA")
    image = image.resize((image.width * 4, image.height * 4), Image.NEAREST)
    left = (image.width - EVENT_SIZE[0]) // 2
    top = (image.height - EVENT_SIZE[1]) // 2
    return image.crop((left, top, left + EVENT_SIZE[0], top + EVENT_SIZE[1]))


if __name__ == "__main__":
    main()
