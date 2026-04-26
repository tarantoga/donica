# Modular Foam-Fill Planter (OpenSCAD)

This repository contains a parametric OpenSCAD model for a large planter shell that:

- keeps at least **500×500×500 mm** internal soil volume,
- includes an intentional **foam cavity** between outer shell and inner liner,
- is split into printable modules for smaller printers,
- uses reinforcement ribs for improved load handling when filled with soil.

## File
- `planter_shell_modular.scad`

## Generate parts
Use OpenSCAD and set:

- `part = "piece"`
- `split_x`, `split_y` for total piece count
- `piece_ix`, `piece_iy` to export each piece

For example, with `split_x=2`, `split_y=2`, export 4 pieces:

1. `(piece_ix, piece_iy) = (0,0)`
2. `(piece_ix, piece_iy) = (1,0)`
3. `(piece_ix, piece_iy) = (0,1)`
4. `(piece_ix, piece_iy) = (1,1)`

## Strength notes
- Increase `liner_wall_t`, `outer_wall_t`, and `rib_t` for heavier soil loads.
- Increase `rib_count_per_side` for additional stiffness.
- Consider adhesive + mechanical fasteners at seams for final assembly.

## Foam fill
- Side foam ports are included by default.
- Fill after dry assembly; plug ports after cure/trim.
