# Printable Part Files

Open any `.scad` file in this directory and export it directly as an STL. The files are wrappers around `../planter_support_free.scad`, which remains the master parametric model.

| File | Element | Print orientation |
| --- | --- | --- |
| `wall_outer_tile_plain.scad` | Plain wall outer skin tile | Large outside face on bed; ribs upward. |
| `wall_outer_tile_ported.scad` | Wall outer skin tile with foam ports | Large outside face on bed; ribs upward. |
| `wall_inner_liner_tile.scad` | Wall inner liner tile | Large interior face on bed; ribs upward. |
| `wall_spacer_ladder.scad` | Wall foam-gap spacer | Print flat as shown; install between wall skins. |
| `bottom_outer_tile.scad` | Bottom outer skin tile with drain holes | Large underside face on bed; ribs upward. |
| `bottom_inner_liner_tile.scad` | Bottom liner tile with drains | Large soil-facing face on bed; ribs upward. |
| `bottom_spacer_ladder.scad` | Bottom foam-gap spacer with drain holes | Print flat as shown; install between bottom skins. |
| `corner_post.scad` | Vertical corner post | Print upright. |
| `rim_rail_x.scad` | Top rim rail for X sides | Print flat on long rectangular face; channel upward. |
| `rim_rail_y.scad` | Top rim rail for Y sides | Print flat on long rectangular face; channel upward. |
| `seam_key.scad` | Loose seam alignment key | Print flat. |

## Suggested Quantities

- Wall tile sandwiches: `36` total wall positions with a `3 x 3` grid on each of four sides.
- Wall outer tiles: use `4` ported outer tiles by default, one upper tile per wall; all remaining outer wall positions use plain tiles.
- Wall inner liner tiles: `36`.
- Wall spacer ladders: `36`.
- Bottom outer tiles: `9`.
- Bottom inner liner tiles: `9`.
- Bottom spacer ladders: `9`.
- Corner posts: `4`.
- Rim rails: `6` X-direction pieces and `6` Y-direction pieces if each side is built from three rail segments.
- Seam keys: print extras for alignment across tile seams.
