# Modular Foam-Fill Planter (OpenSCAD)

This repository contains a parametric OpenSCAD model for a large planter shell that:

- keeps at least **500×500×500 mm** internal soil volume,
- includes an intentional **foam cavity** between outer shell and inner liner,
- is split into printable modules for smaller printers,
- uses reinforcement ribs for improved load handling when filled with soil.

## Files
- `planter_support_free.scad` - master parametric model and assembly preview.
- `parts/*.scad` - separate ready-to-export OpenSCAD file for each distinct printable element.
- `parts/README.md` - print orientation and suggested quantities.

## Generate parts
Open any file in `parts/` and export it directly as STL. Each file names one printable element, for example:

- `parts/wall_outer_tile_plain.scad`
- `parts/wall_outer_tile_ported.scad`
- `parts/wall_inner_liner_tile.scad`
- `parts/wall_spacer_ladder.scad`
- `parts/bottom_outer_tile.scad`
- `parts/bottom_inner_liner_tile.scad`
- `parts/bottom_spacer_ladder.scad`
- `parts/corner_post.scad`
- `parts/rim_rail_x.scad`
- `parts/rim_rail_y.scad`
- `parts/seam_key.scad`

## Strength notes
- Increase `skin_t`, `liner_t`, `bottom_skin_t`, or `bottom_liner_t` for heavier soil loads.
- Reduce `spacer_pitch` or increase `rib_w` / `spacer_w` for additional stiffness.
- Consider adhesive + mechanical fasteners at seams for final assembly.

## Foam fill
- Side foam ports are included by default.
- Fill after dry assembly; plug ports after cure/trim.
