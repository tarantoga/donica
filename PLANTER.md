# Support-Free Foam-Filled Planter

This model keeps a clear internal soil volume of `500 x 500 x 500 mm`, but changes the construction method so the pieces can be printed without supports on a Prusa CORE One class printer.

Prusa lists the CORE One build volume as `250 x 220 x 270 mm`, so the planter is split into flat tiles and rails instead of large hollow wall sections.

## Files

- `planter_support_free.scad` - parametric OpenSCAD model.
- `parts/*.scad` - one ready-to-export wrapper file for each distinct printable element.
- `parts/README.md` - print orientation and suggested quantities.

## Main Idea

The planter is now a sandwich assembly:

- outer skin tiles
- inner liner tiles
- spacer ladder ribs between them
- loose seam keys for tile alignment
- corner posts
- top rim rails
- bottom skin, spacer, and liner tiles

The foam cavity is not printed as an enclosed hollow part. Instead, it is created during assembly by bonding the outer skin, spacer ladder, and inner liner together. That keeps every printable part simple and support-free. The bottom drain pattern passes through all bottom layers, so keep those holes open while sealing and foaming.

## Why The Random Cylinders Are Gone

The previous small cylinders were likely meant as connectors or pins, but scattered cylinders are weak for this scale and are confusing to assemble. This version replaces them with:

- loose rectangular seam keys and shallow recesses for tile alignment
- spacer ladder ribs that set the foam gap
- corner posts and rim rails that tie the whole box together

Cylinders are only used where they make sense: foam injection/vent holes and bottom drainage holes.

## Printing Orientation

Use these orientations:

- `wall_outer_tile_plain`, `wall_outer_tile_ported`, `wall_inner_liner_tile`, `bottom_outer_tile`, `bottom_inner_liner_tile`: print flat, large face on the bed, ribs upward.
- `wall_spacer_ladder`, `bottom_spacer_ladder`: print flat as ladder ribs.
- `corner_post`: print upright.
- `rim_rail_x`, `rim_rail_y`: print flat on the long rectangular face.
- `seam_key`: print flat.

These parts are designed to avoid overhangs that need support material.

## Exporting STLs

The easiest workflow is to open each file in `parts/` and export it directly as an STL.

You can also open `planter_support_free.scad`, set:

```scad
part = "wall_outer_tile_ported";
wall_side = "front";
```

Then render/export the STL. Repeat for:

- `wall_outer_tile`
- `wall_outer_tile_ported`
- `wall_inner_tile`
- `wall_spacer`
- `bottom_outer_tile`
- `bottom_inner_tile`
- `bottom_spacer`
- `corner_post`
- `rim_rail_x`
- `rim_rail_y`
- `seam_key`

`part = "assembly"` previews the complete planter.

## Strength Notes

The design assumes the dirt load is significant, so the printed plastic is used mostly as a shell and geometry carrier while the foam acts as a bonded core. The spacer ladders are important: they keep the wall gap even during foam expansion and improve panel stiffness after curing.

For a real outdoor planter, use PETG, ASA, or another moisture/temperature-resistant filament. Seal all seams before filling with expanding foam, fill gradually through the ports, and do not overfill one wall cavity in a single pass.
