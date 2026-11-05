"""Cuts a character's neutral pose (rig_base) into parts for the 2D skeleton
(T35, D-176, D-180, docs/art/asset-pipeline.md §7).

Usage, from the repository root:
    python3 tools/art/rig_cut.py tools/art/rigs/saint_george.json
    python3 tools/art/rig_cut.py tools/art/rigs/saint_george.json --preview out.png

The cut map (JSON) lists each part with its outline (polygons, ellipses and
thick lines in source pixels), its joint (pivot), its parent and the parts in
front of it whose pixels it must paint over (optionally copying from an
offset, for thin objects like a spear). The script:

1. removes the grey background (process_art.remove_background);
2. scales the figure to the body scale of asset-pipeline §4 (1200 px tall);
3. cuts every part; where a part in front covered it, the hidden pixels are
   painted from the part's own colours (push-pull fill), so nothing shows a
   hole when the front part moves;
4. writes one PNG per part and a RigDef resource (.tres) for the game.

Needs Pillow only (ADR-0011). Development tool: nothing here ships with the
game. Never modifies art_source/.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw

sys.path.insert(0, str(Path(__file__).resolve().parent))
import process_art  # noqa: E402  (same folder, development tool)

ROOT = process_art.ROOT
SRC = process_art.SRC
DST = process_art.DST
FIGURE_HEIGHT = process_art.BODY_FIGURE_HEIGHT
# Pixels of a part that sit under a front part but are this close to the
# part's own visible pixels still count as the part (joints overlap a bit).
FILL_ALPHA_MIN = 8
RIG_SCRIPT = "res://scenes/battle/rig/rig_def.gd"


def outline_mask(size: tuple[int, int], spec: dict, scale: float) -> Image.Image:
    mask = Image.new("L", size, 0)
    draw = ImageDraw.Draw(mask)
    for poly in spec.get("polys", []):
        draw.polygon([(x * scale, y * scale) for x, y in poly], fill=255)
    for x0, y0, x1, y1 in spec.get("ellipses", []):
        draw.ellipse([x0 * scale, y0 * scale, x1 * scale, y1 * scale], fill=255)
    for a, b, half in spec.get("lines", []):
        draw.line([(a[0] * scale, a[1] * scale), (b[0] * scale, b[1] * scale)], fill=255, width=int(half * 2 * scale))
    return mask


def push_pull_fill(img: Image.Image) -> Image.Image:
    """Opaque colours everywhere, spread from the visible pixels of `img`."""
    levels = [img]
    while min(levels[-1].size) > 2:
        w, h = levels[-1].size
        small = levels[-1].convert("RGBa").resize((max(1, w // 2), max(1, h // 2)), Image.Resampling.BOX)
        levels.append(small.convert("RGBA"))
    top = levels[-1].copy()
    top.putalpha(255)
    filled = top
    for level in reversed(levels[:-1]):
        up = filled.resize(level.size, Image.Resampling.BILINEAR)
        filled = Image.alpha_composite(up, level)
    filled.putalpha(255)
    return filled


def cut(config_path: Path) -> dict:
    cfg = json.loads(config_path.read_text(encoding="utf-8"))
    src = Image.open(SRC / cfg["source"])
    figure = process_art.remove_background(src, flood=True)
    bbox = figure.getchannel("A").point(lambda a: 255 if a > 32 else 0).getbbox()
    scale = FIGURE_HEIGHT / (bbox[3] - bbox[1])
    size = (round(figure.width * scale), round(figure.height * scale))
    figure = figure.resize(size, Image.Resampling.LANCZOS)
    silhouette = figure.getchannel("A")
    # Origin of the rig: centre of the figure at the feet line.
    origin = ((bbox[0] + bbox[2]) * 0.5 * scale, bbox[3] * scale)

    masks = {p["name"]: ImageChops.multiply(outline_mask(size, p, scale), silhouette) for p in cfg["parts"]}
    out_dir = DST / cfg["out_dir"]
    out_dir.mkdir(parents=True, exist_ok=True)
    parts_out = []
    for z, part in enumerate(cfg["parts"]):
        name = part["name"]
        own = masks[name]
        # Pixels covered by parts in front: not this part's colour.
        hidden = Image.new("L", size, 0)
        clones: list[tuple[Image.Image, tuple[int, int]]] = []
        for front in part.get("fill_under", []):
            # "name", or ["name", dx, dy]: a thin object (a spear). Its pixels
            # count as this part only where the part shows on at least one
            # side of it (at +offset or -offset), and they are painted by
            # copying from that side, which keeps vertical folds and pleats
            # straight.
            front_name = front if isinstance(front, str) else front[0]
            hidden = ImageChops.lighter(hidden, masks[front_name])
            if not isinstance(front, str):
                clones.append((masks[front_name], (round(front[1] * scale), round(front[2] * scale))))
        visible = ImageChops.subtract(own, hidden)
        piece = figure.copy()
        piece.putalpha(visible)
        if hidden.getbbox() is not None:
            area = ImageChops.multiply(own, hidden.point(lambda a: 255 if a > FILL_ALPHA_MIN else 0))
            painted = push_pull_fill(piece)
            solid = visible.point(lambda a: 255 if a > 200 else 0)
            for front_mask, (dx, dy) in clones:
                ahead = ImageChops.offset(solid, -dx, -dy)
                behind = ImageChops.offset(solid, dx, dy)
                inside = ImageChops.multiply(ImageChops.lighter(ahead, behind), front_mask)
                # Thin-object pixels with the part on neither side stick out
                # of its outline: they are not this part.
                area = ImageChops.subtract(area, ImageChops.subtract(front_mask, inside))
                from_behind = ImageChops.multiply(behind, front_mask)
                from_ahead = ImageChops.multiply(ahead, front_mask)
                painted = Image.composite(ImageChops.offset(piece, dx, dy), painted, from_behind)
                painted = Image.composite(ImageChops.offset(piece, -dx, -dy), painted, from_ahead)
            piece = Image.composite(painted, piece, area)
            piece.putalpha(ImageChops.lighter(visible, area))
        box = piece.getchannel("A").getbbox()
        if box is None:
            raise SystemExit(f"{name}: empty part, check its outline")
        crop = piece.crop(box)
        file_name = f"{cfg['id']}_{name}.png"
        crop.save(out_dir / file_name)
        parts_out.append({
            "name": name,
            "parent": part["parent"],
            "z": z,
            "file": file_name,
            "offset": (box[0] - origin[0], box[1] - origin[1]),
            "pivot": (part["pivot"][0] * scale - origin[0], part["pivot"][1] * scale - origin[1]),
        })
    root = (cfg["root_pivot"][0] * scale - origin[0], cfg["root_pivot"][1] * scale - origin[1])
    head = (cfg["head_point"][0] * scale - origin[0], cfg["head_point"][1] * scale - origin[1])
    write_tres(out_dir / f"{cfg['id']}_rig.tres", cfg, parts_out, root, head, figure.size, scale)
    return {"figure": figure, "parts": parts_out, "out_dir": out_dir, "origin": origin}


def vec(v: tuple[float, float]) -> str:
    return f"Vector2({v[0]:.1f}, {v[1]:.1f})"


def write_tres(path: Path, cfg: dict, parts: list[dict], root: tuple, head: tuple, size: tuple, scale: float) -> None:
    res_dir = "res://assets/" + cfg["out_dir"]
    lines = [f'[gd_resource type="Resource" script_class="RigDef" load_steps={len(parts) + 2} format=3]', ""]
    lines.append(f'[ext_resource type="Script" path="{RIG_SCRIPT}" id="1_rig"]')
    for i, p in enumerate(parts):
        lines.append(f'[ext_resource type="Texture2D" path="{res_dir}/{p["file"]}" id="{i + 2}_{p["name"]}"]')
    lines += ["", "[resource]", 'script = ExtResource("1_rig")']
    lines.append(f'character_id = &"{cfg["id"]}"')
    lines.append(f"root_pivot = {vec(root)}")
    lines.append(f"head_point = {vec(head)}")
    entries = []
    for i, p in enumerate(parts):
        entries.append(
            "{\n"
            f'"name": &"{p["name"]}",\n'
            f'"offset": {vec(p["offset"])},\n'
            f'"parent": &"{p["parent"]}",\n'
            f'"pivot": {vec(p["pivot"])},\n'
            f'"texture": ExtResource("{i + 2}_{p["name"]}"),\n'
            f'"z": {p["z"]}\n'
            "}"
        )
    lines.append("parts = Array[Dictionary]([" + ", ".join(entries) + "])")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def preview(result: dict, out: Path) -> None:
    """Parts reassembled at rest, with pivots marked: the cut must look whole."""
    fig = result["figure"]
    canvas = Image.new("RGBA", fig.size, (60, 60, 70, 255))
    ox, oy = result["origin"]
    draw = ImageDraw.Draw(canvas)
    for p in result["parts"]:
        piece = Image.open(result["out_dir"] / p["file"])
        canvas.alpha_composite(piece, (round(p["offset"][0] + ox), round(p["offset"][1] + oy)))
    for p in result["parts"]:
        x, y = p["pivot"][0] + ox, p["pivot"][1] + oy
        draw.ellipse([x - 5, y - 5, x + 5, y + 5], outline=(255, 60, 60), width=2)
    canvas.save(out)


def main(argv: list[str]) -> int:
    if not argv:
        print(__doc__)
        return 1
    result = cut(Path(argv[0]))
    if "--preview" in argv:
        preview(result, Path(argv[argv.index("--preview") + 1]))
    print(f"{len(result['parts'])} parts written to {result['out_dir'].relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
