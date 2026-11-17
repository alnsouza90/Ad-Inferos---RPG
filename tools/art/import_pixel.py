"""Brings the PixelLab clips into the game (ADR-0013, T64, D-367, D-368).

Each row of tools/art/pixel_clips.csv is one clip: a PixelLab sheet (a strip
of 256 x 256 frames, or the grid of frames the PixelLab gallery hands out)
and which of its frames to keep. For every clip the tool:

- checks that every frame is 256 x 256 and that every pixel is either opaque
  or empty (no half-transparent pixel);
- cleans what the generator invents: the white slash arc of the quick frames
  (D-368, "white_arc"), loose pixels away from the figure ("specks=N");
- brings every colour to the single palette (docs/fable/piloto-pixel/
  paleta.json) when the character asks for it ("palette" column);
- puts the feet of every clip of a character on one point (the feet of the
  first idle frame);

and writes one PNG sheet per clip in game/assets/pixel/characters/<id>/
plus the CharacterFrames resource the battle view reads, in
game/scenes/battle/combatants/pixel/<id>_frames.tres. The originals are never
changed.

Usage, from the repository root:
    python3 tools/art/import_pixel.py                  # every character
    python3 tools/art/import_pixel.py saint_benedict   # only one
    python3 tools/art/import_pixel.py --preview DIR    # also GIFs to show Alan

Needs Pillow and numpy. Development tool only (ADR-0011).
"""
from __future__ import annotations

import csv
import json
import sys
from collections import deque
from dataclasses import dataclass, field
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
CLIPS_CSV = Path(__file__).with_name("pixel_clips.csv")
CHARACTERS_CSV = Path(__file__).with_name("pixel_characters.csv")
PALETTE_JSON = ROOT / "docs" / "fable" / "piloto-pixel" / "paleta.json"
DST = ROOT / "game" / "assets" / "pixel" / "characters"
RES_DIR = ROOT / "game" / "scenes" / "battle" / "combatants" / "pixel"

# Every PixelLab character frame is this square (ADR-0013).
FRAME = 256
# Largest sheet side (safe on the phones we target).
MAX_SHEET = 4096
# An alpha at or above this is opaque, below it empty: PixelLab art has no
# half-transparent pixel, and the few it may bring are edge noise.
ALPHA_CUT = 128
# The slash arc PixelLab draws on quick frames is white with a light grey
# rim: neutral greys (channels at most this far apart) at least this light,
# in colours the character's idle clip never uses (so the beard of Bento,
# which is in the idle, stays).
ARC_GREY_SPREAD = 20
ARC_MIN_LUMA = 95
# The red splashes (D-428): a red at least this bright, this far above the
# other two channels.
RED_FX_MIN = 120
RED_FX_SPREAD = 70
# A clip whose feet stand more than this many pixels off the line of the
# first idle frame is reported: the frames would hop on screen.
FEET_TOLERANCE = 3
# Rows above the feet that count as "the feet" to find their centre.
FEET_ROWS = 6
# Every figure is shrunk by this factor after the cleaning, so the company
# and the enemies stand apart on the 960 x 540 screen with room between the
# two sides (D-384). The feet stay on the same point of the 256 frame.
# A character may have its own factor (`figure_scale` in the table): the
# elites stand taller than the common enemies (D-405).
FIGURE_SCALE = 0.72
# The bust for the portrait arch and the enemy sheet is cut from the idle
# frame at full size, before the shrink: width, height, and how far the
# corner sits left and above the halo point (saints) or the top of the
# figure (the others).
BUST_SIZE = (64, 96)
BUST_FROM_HALO = (30, 24)
BUST_ABOVE_TOP = 2
# Seconds a single pose holds (presentation timing, as in FrameClip).
POSE_TIME = 0.4


@dataclass
class Character:
    id: str
    display_scale: float
    attack_style: str
    spell_style: str
    blessing_style: str
    weight: str
    palette: str
    # Halo point measured on the figure cut to its outline (06-rumo-pixel §9):
    # x and y from the top-left of the figure, and the diameter.
    halo: tuple[float, float, float] | None
    # Every clip of the character gets the warm skin (D-388).
    warm: bool = False
    figure_scale: float = FIGURE_SCALE
    # Colour grade (D-416): gamma below 1 lifts the mid-tones; the three
    # factors warm the colours (Bento, closer to George's palette).
    grade_gamma: float = 1.0
    grade_warm: tuple[float, float, float] = (1.0, 1.0, 1.0)
    clips: list["Clip"] = field(default_factory=list)


@dataclass
class Clip:
    character: str
    clip: str
    source: Path
    frames: str
    fps: float
    mode: str
    impact: int
    cleanup: list[str]


@dataclass
class Sheet:
    clip: Clip
    path: Path
    count: int
    columns: int


def palette() -> np.ndarray:
    data = json.loads(PALETTE_JSON.read_text(encoding="utf-8"))
    return np.array([[int(c[i:i + 2], 16) for i in (1, 3, 5)] for c in data["completa"]], dtype=np.int32)


def read_characters() -> list[Character]:
    chars: dict[str, Character] = {}
    with CHARACTERS_CSV.open(encoding="utf-8") as f:
        for row in csv.DictReader(f):
            halo = None
            if row["halo_x"]:
                halo = (float(row["halo_x"]), float(row["halo_y"]), float(row["halo_size"]))
            chars[row["character"]] = Character(
                id=row["character"],
                display_scale=float(row["display_scale"]),
                attack_style=row["attack_style"],
                spell_style=row["spell_style"],
                blessing_style=row["blessing_style"],
                weight=row["weight"],
                palette=row["palette"],
                halo=halo,
                figure_scale=float(row.get("figure_scale") or FIGURE_SCALE),
                grade_gamma=float(row.get("grade_gamma") or 1.0),
                grade_warm=tuple(float(v) for v in (row.get("grade_warm") or "1|1|1").split("|")),
            )
    with CLIPS_CSV.open(encoding="utf-8") as f:
        for row in csv.DictReader(f):
            if "warm_skin" in row["cleanup"] and row["character"] in chars:
                chars[row["character"]].warm = True
            if row["character"] not in chars:
                raise SystemExit(f"{CLIPS_CSV.name}: personagem sem linha em {CHARACTERS_CSV.name}: {row['character']}")
            chars[row["character"]].clips.append(Clip(
                character=row["character"],
                clip=row["clip"],
                source=ROOT / row["source"],
                frames=row["frames"],
                fps=float(row["fps"] or 0),
                mode=row["mode"],
                impact=int(row["impact"]) if row["impact"] else -1,
                cleanup=[t for t in row["cleanup"].split("+") if t],
            ))
    for char in chars.values():
        if not char.clips or char.clips[0].clip != "idle":
            raise SystemExit(f"{char.id}: o primeiro clipe precisa ser o parado (idle), que dá a linha dos pés")
    return list(chars.values())


def source_frames(path: Path) -> list[np.ndarray]:
    """Every non-empty 256 x 256 cell of a PixelLab sheet, row by row."""
    image = Image.open(path).convert("RGBA")
    w, h = image.size
    if w % FRAME or h % FRAME:
        raise SystemExit(f"{path.name}: {w} x {h} não é feito de quadros de {FRAME}")
    data = np.array(image)
    cells = []
    for row in range(h // FRAME):
        for col in range(w // FRAME):
            cell = data[row * FRAME:(row + 1) * FRAME, col * FRAME:(col + 1) * FRAME].copy()
            if cell[:, :, 3].any():
                cells.append(cell)
    return cells


def pick(cells: list[np.ndarray], spec: str, name: str) -> list[np.ndarray]:
    """'all', one index ('4'), a range ('0-8') or a list ('0,2,4')."""
    if spec in ("", "all"):
        return cells
    indices: list[int] = []
    for part in spec.split(","):
        if "-" in part:
            a, b = part.split("-")
            indices += list(range(int(a), int(b) + 1))
        else:
            indices.append(int(part))
    bad = [i for i in indices if i >= len(cells)]
    if bad:
        raise SystemExit(f"{name}: quadros {bad} não existem (a folha tem {len(cells)})")
    return [cells[i] for i in indices]


def binarize(cell: np.ndarray) -> int:
    """Every pixel opaque or empty; returns how many were half-transparent."""
    alpha = cell[:, :, 3]
    half = int(((alpha > 0) & (alpha < 255)).sum())
    cell[:, :, 3] = np.where(alpha >= ALPHA_CUT, 255, 0)
    cell[cell[:, :, 3] == 0] = 0
    return half


def colour_set(cells: list[np.ndarray]) -> set[tuple[int, int, int]]:
    return {tuple(int(v) for v in p) for c in cells for p in c[c[:, :, 3] == 255][:, :3]}


def erase_white_arc(cell: np.ndarray, own: set[tuple[int, int, int]]) -> int:
    rgb = cell[:, :, :3].astype(np.int32)
    luma = rgb @ np.array([0.3, 0.59, 0.11])
    grey = (rgb.max(axis=2) - rgb.min(axis=2)) <= ARC_GREY_SPREAD
    candidate = (cell[:, :, 3] == 255) & grey & (luma >= ARC_MIN_LUMA)
    arc = np.zeros_like(candidate)
    for y, x in zip(*np.nonzero(candidate)):
        arc[y, x] = tuple(int(v) for v in rgb[y, x]) not in own
    cell[arc] = 0
    return int(arc.sum())


def erase_red_fx(cell: np.ndarray, own: set[tuple[int, int, int]]) -> int:
    """Removes the bright red splashes the generator adds to quick frames
    (D-428): saturated reds the idle clip never uses (the dark red of
    Asmodeus' wings is in the idle, so it stays). No blood in the game's
    sprites (prompts-pixel-m2.md §11)."""
    rgb = cell[:, :, :3].astype(np.int32)
    r, g, b = rgb[:, :, 0], rgb[:, :, 1], rgb[:, :, 2]
    candidate = (cell[:, :, 3] == 255) & (r >= RED_FX_MIN) & (r - np.maximum(g, b) >= RED_FX_SPREAD)
    fx = np.zeros_like(candidate)
    for y, x in zip(*np.nonzero(candidate)):
        fx[y, x] = tuple(int(v) for v in rgb[y, x]) not in own
    cell[fx] = 0
    return int(fx.sum())


def components(mask: np.ndarray) -> list[list[tuple[int, int]]]:
    """Groups of opaque pixels touching by side or corner."""
    seen = np.zeros_like(mask, dtype=bool)
    groups = []
    h, w = mask.shape
    for y, x in zip(*np.nonzero(mask)):
        if seen[y, x]:
            continue
        group = []
        queue = deque([(y, x)])
        seen[y, x] = True
        while queue:
            cy, cx = queue.popleft()
            group.append((cy, cx))
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    ny, nx = cy + dy, cx + dx
                    if 0 <= ny < h and 0 <= nx < w and mask[ny, nx] and not seen[ny, nx]:
                        seen[ny, nx] = True
                        queue.append((ny, nx))
        groups.append(group)
    return groups


def erase_specks(cell: np.ndarray, largest: int) -> int:
    """Removes loose groups of at most `largest` pixels (never the figure)."""
    groups = components(cell[:, :, 3] == 255)
    if len(groups) <= 1:
        return 0
    figure = max(len(g) for g in groups)
    removed = 0
    for g in groups:
        if len(g) <= largest and len(g) < figure:
            ys, xs = zip(*g)
            cell[list(ys), list(xs)] = 0
            removed += len(g)
    return removed


def snap_to_palette(cell: np.ndarray, colours: np.ndarray) -> int:
    """Each opaque colour becomes the nearest palette colour (in light, not
    in raw numbers, weighted like the eye sees it). Returns pixels changed."""
    opaque = cell[:, :, 3] == 255
    rgb = cell[:, :, :3][opaque].astype(np.int32)
    if rgb.size == 0:
        return 0
    unique, inverse = np.unique(rgb, axis=0, return_inverse=True)
    lin = lambda c: (c / 255.0) ** 2.2
    weight = np.array([0.3, 0.59, 0.11])
    dist = (((lin(unique)[:, None, :] - lin(colours)[None, :, :]) ** 2) * weight).sum(axis=2)
    nearest = colours[dist.argmin(axis=1)]
    new = nearest[inverse.reshape(-1)]
    changed = int((new != rgb).any(axis=1).sum())
    out = cell[:, :, :3].copy()
    out[opaque] = new.astype(np.uint8)
    cell[:, :, :3] = out
    return changed


def off_palette(cell: np.ndarray, colours: np.ndarray) -> int:
    rgb = cell[:, :, :3][cell[:, :, 3] == 255].astype(np.int32)
    if rgb.size == 0:
        return 0
    known = (rgb[:, None, :] == colours[None, :, :]).all(axis=2).any(axis=1)
    return int((~known).sum())


def feet(cell: np.ndarray) -> tuple[int, int]:
    """Centre of the lowest rows of the figure, and the line under them."""
    rows = np.nonzero(cell[:, :, 3].any(axis=1))[0]
    bottom = int(rows.max()) + 1
    band = cell[max(bottom - FEET_ROWS, 0):bottom, :, 3]
    xs = np.nonzero(band.any(axis=0))[0]
    return int(round((xs.min() + xs.max() + 1) / 2)), bottom


def outline(cell: np.ndarray) -> tuple[int, int, int, int]:
    ys, xs = np.nonzero(cell[:, :, 3])
    return int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1


def clean(clip: Clip, char: Character, colours: np.ndarray,
          idle_colours: set[tuple[int, int, int]]) -> list[np.ndarray]:
    name = f"{clip.character}/{clip.clip}"
    cells = pick(source_frames(clip.source), clip.frames, name)
    report = {"meio-tom": 0, "arco": 0, "soltos": 0, "paleta": 0}
    for cell in cells:
        report["meio-tom"] += binarize(cell)
        if "white_arc" in clip.cleanup:
            report["arco"] += erase_white_arc(cell, idle_colours)
        if "red_fx" in clip.cleanup:
            report["vermelho"] = report.get("vermelho", 0) + erase_red_fx(cell, idle_colours)
        if "warm_skin" in clip.cleanup:
            report["pele"] = report.get("pele", 0) + warm_skin(cell, clip.character)
        for token in clip.cleanup:
            if token.startswith("specks="):
                report["soltos"] += erase_specks(cell, int(token.split("=")[1]))
        grade(cell, char)
    return _finish(cells, clip, char, colours, report)


# The warm skin of Saint George (D-388): Bento and Teresinha in the new style
# came out greyish or pink; their skin tones are taken to this ramp by light.
# The warm skin of Saint George (D-388): each skin colour of the new
# drawings of Bento and Teresinha (measured on the face) becomes one of the
# palette colours of George's skin, the habit, the cloak and the veil keep
# their own colours.
SKIN_MAP = {
    "saint_benedict": {"#C8B396": "#C4A98D", "#A4927D": "#9A745A", "#8F7F6C": "#9A745A",
                       "#826E58": "#765B47", "#6F5C4A": "#765B47"},
    "saint_therese": {"#DABBA5": "#C4A98D", "#C6A691": "#C4A98D", "#A08371": "#9A745A",
                      "#836A5C": "#765B47", "#5D4439": "#553327"},
}


def grade(cell: np.ndarray, char: "Character") -> None:
    """Lifts the mid-tones and warms the colours of `char` in place (D-416);
    the palette snap afterwards keeps every colour on the game palette."""
    if char.grade_gamma == 1.0 and char.grade_warm == (1.0, 1.0, 1.0):
        return
    rgb = cell[:, :, :3].astype(np.float64) / 255.0
    graded = np.power(rgb, char.grade_gamma) * np.array(char.grade_warm)
    # The skin already has George's colours (warm_skin): left as it is, or
    # the warmer tone tips it into the gold of the palette.
    keep = np.zeros(cell.shape[:2], dtype=bool)
    for target in SKIN_MAP.get(char.id, {}).values():
        dst = np.array([int(target[k:k + 2], 16) for k in (1, 3, 5)])
        keep |= np.abs(cell[:, :, :3].astype(np.int32) - dst).sum(axis=2) <= 2
    graded[keep] = rgb[keep]
    cell[:, :, :3] = np.clip(graded * 255.0 + 0.5, 0, 255).astype(np.uint8)


def warm_skin(cell: np.ndarray, character: str) -> int:
    """The skin colours of `character` become George's; returns how many
    pixels changed."""
    changed = 0
    rgb = cell[:, :, :3].astype(np.int32)
    opaque = cell[:, :, 3] == 255
    for source, target in SKIN_MAP.get(character, {}).items():
        src = [int(source[k:k + 2], 16) for k in (1, 3, 5)]
        dst = [int(target[k:k + 2], 16) for k in (1, 3, 5)]
        hit = opaque & (np.abs(rgb - src).sum(axis=2) <= 6)
        cell[:, :, :3][hit] = dst
        changed += int(hit.sum())
    return changed


def shrink(cell: np.ndarray, scale: float) -> np.ndarray:
    """The frame at `scale`, averaged by area so no line is lost, back on a
    256 canvas with the bottom centre kept in place."""
    if scale >= 1.0:
        return cell
    image = Image.fromarray(cell, "RGBA")
    side = int(round(FRAME * scale))
    # Premultiplied, so the empty pixels do not darken the edges.
    small = image.convert("RGBa").resize((side, side), Image.BOX).convert("RGBA")
    out = Image.new("RGBA", (FRAME, FRAME), (0, 0, 0, 0))
    out.paste(small, ((FRAME - side) // 2, FRAME - side))
    return np.array(out)


def _finish(cells: list[np.ndarray], clip: Clip, char: Character, colours: np.ndarray,
            report: dict[str, int]) -> list[np.ndarray]:
    for i, cell in enumerate(cells):
        cell = shrink(cell, char.figure_scale)
        binarize(cell)
        if char.palette == "snap":
            report["paleta"] += snap_to_palette(cell, colours)
        cells[i] = cell
    name = f"{clip.character}/{clip.clip}"
    left = sum(off_palette(c, colours) for c in cells)
    notes = ", ".join(f"{k} {v}" for k, v in report.items() if v)
    print(f"  {clip.clip:8} {len(cells):2} quadros" + (f" · {notes}" if notes else "")
          + (f" · AVISO: {left} pixels fora da paleta" if left else ""))
    return cells


def write_sheet(clip: Clip, cells: list[np.ndarray]) -> Sheet:
    columns = min(len(cells), MAX_SHEET // FRAME)
    rows = -(-len(cells) // columns)
    sheet = np.zeros((rows * FRAME, columns * FRAME, 4), dtype=np.uint8)
    for i, cell in enumerate(cells):
        r, c = divmod(i, columns)
        sheet[r * FRAME:(r + 1) * FRAME, c * FRAME:(c + 1) * FRAME] = cell
    folder = DST / clip.character
    folder.mkdir(parents=True, exist_ok=True)
    path = folder / f"{clip.character}_{clip.clip}.png"
    Image.fromarray(sheet, "RGBA").save(path, optimize=True)
    return Sheet(clip, path, len(cells), columns)


def write_bust(char: Character, cell: np.ndarray, colours: np.ndarray) -> Path:
    """The head and shoulders at full size, for the portrait arch and the
    enemy sheet (the figures on the field are shrunk, D-384)."""
    full = cell.copy()
    binarize(full)
    if char.warm:
        warm_skin(full, char.id)
    grade(full, char)
    if char.palette == "snap":
        snap_to_palette(full, colours)
    x0, y0, x1, _ = outline(full)
    if char.halo is not None:
        left = int(x0 + char.halo[0] - BUST_FROM_HALO[0])
        top = int(y0 + char.halo[1] - BUST_FROM_HALO[1])
    else:
        left = int((x0 + x1) // 2 - BUST_SIZE[0] // 2)
        top = y0 - BUST_ABOVE_TOP
    left = min(max(left, 0), FRAME - BUST_SIZE[0])
    top = min(max(top, 0), FRAME - BUST_SIZE[1])
    bust = full[top:top + BUST_SIZE[1], left:left + BUST_SIZE[0]]
    folder = DST / char.id
    folder.mkdir(parents=True, exist_ok=True)
    path = folder / f"{char.id}_bust.png"
    Image.fromarray(bust, "RGBA").save(path, optimize=True)
    return path


def res_path(path: Path) -> str:
    return "res://" + path.relative_to(ROOT / "game").as_posix()


def write_resource(char: Character, sheets: list[Sheet], anchor: tuple[int, int],
                   figure: tuple[int, int, int, int]) -> Path:
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
        fps = s.clip.fps if s.count > 1 else 0.0
        lines += [
            f'[sub_resource type="Resource" id="{sub}"]',
            'script = ExtResource("2_clip")',
            f'id = &"{s.clip.clip}"',
            f'sheet_path = "{res_path(s.path)}"',
            f"frame_size = Vector2i({FRAME}, {FRAME})",
            f"columns = {s.columns}",
            f"count = {s.count}",
            f"fps = {fps:g}",
            f"looping = {'true' if s.clip.mode == 'loop' else 'false'}",
            f"anchor = Vector2({anchor[0]}, {anchor[1]})",
            f"impact_frame = {s.clip.impact}",
            f"pose_time = {POSE_TIME:g}",
            "",
        ]
    halo_center, halo_diameter = (0.0, 0.0), 0.0
    if char.halo is not None:
        # Measured on the full-size figure: shrunk with it.
        halo_center = (round(figure[0] + char.halo[0] * char.figure_scale), round(figure[1] + char.halo[1] * char.figure_scale))
        halo_diameter = round(char.halo[2] * char.figure_scale)
    lines += [
        "[resource]",
        'script = ExtResource("1_set")',
        f'character_id = &"{char.id}"',
        f"figure_height = {figure[3] - figure[1]:.1f}",
        f"display_scale = {char.display_scale:g}",
        f'attack_style = &"{char.attack_style}"',
        f'spell_style = &"{char.spell_style}"',
        f'blessing_style = &"{char.blessing_style}"',
        f'weight = &"{char.weight}"',
        f"halo_center = Vector2({halo_center[0]:g}, {halo_center[1]:g})",
        f"halo_diameter = {halo_diameter:g}",
        f'clips = Array[ExtResource("2_clip")]([{", ".join(ids)}])',
        "",
    ]
    RES_DIR.mkdir(parents=True, exist_ok=True)
    out = RES_DIR / f"{char.id}_frames.tres"
    out.write_text("\n".join(lines), encoding="utf-8")
    return out


def preview(char: Character, clips: dict[str, list[np.ndarray]], fps: dict[str, float], folder: Path) -> None:
    """One GIF per clip, 2x, on the dark ground of the game, feet on a line."""
    folder.mkdir(parents=True, exist_ok=True)
    ground = (23, 18, 20, 255)
    for name, cells in clips.items():
        frames = []
        for cell in cells:
            bg = Image.new("RGBA", (FRAME, FRAME), ground)
            bg.alpha_composite(Image.fromarray(cell, "RGBA"))
            frames.append(bg.convert("RGB").resize((FRAME * 2, FRAME * 2), Image.NEAREST))
        ms = int(1000 / fps[name]) if fps[name] > 0 else 600
        frames[0].save(folder / f"{char.id}_{name}.gif", save_all=True, append_images=frames[1:],
                       duration=ms, loop=0)


def run(only: list[str], preview_dir: Path | None) -> int:
    colours = palette()
    for char in read_characters():
        if only and char.id not in only:
            continue
        print(char.id)
        idle = char.clips[0]
        # The colours of the idle, before any change: what the arc is not.
        idle_cells = pick(source_frames(idle.source), idle.frames, idle.clip)
        idle_colours = colour_set(idle_cells)
        write_bust(char, idle_cells[0], colours)
        cleaned = {clip.clip: clean(clip, char, colours, idle_colours) for clip in char.clips}
        idle0 = cleaned["idle"][0]
        anchor = feet(idle0)
        for name, cells in cleaned.items():
            off = [i for i, c in enumerate(cells) if abs(feet(c)[1] - anchor[1]) > FEET_TOLERANCE]
            if off and name != "fall":
                print(f"  AVISO: {name}, quadros {off} com os pés fora da linha {anchor[1]}")
        sheets = [write_sheet(clip, cleaned[clip.clip]) for clip in char.clips]
        print("  ->", write_resource(char, sheets, anchor, outline(idle0)).relative_to(ROOT))
        if preview_dir is not None:
            preview(char, cleaned, {c.clip: c.fps for c in char.clips}, preview_dir)
    return 0


if __name__ == "__main__":
    args = sys.argv[1:]
    folder = None
    if "--preview" in args:
        i = args.index("--preview")
        folder = Path(args[i + 1])
        del args[i:i + 2]
    sys.exit(run(args, folder))
