/*
Support-free modular foam-filled planter shell.

Design intent:
- Minimum clear soil volume: 500 x 500 x 500 mm.
- Print on a Prusa CORE One class bed by splitting every face into small tiles.
- Avoid slicer supports: skins print as flat plates, spacers print as simple bars,
  corner posts print upright, and the assembled cavity is filled with foam later.
- Prevent foam bulging: distance ribs tie inner and outer skins and keep the
  cavity thickness even while the foam expands.

Export by changing `part` below, then rendering/exporting STL.
*/

$fn = 32;

// Main dimensions.
inner_x = 500;
inner_y = 500;
inner_z = 500;

skin_t = 3.2;
liner_t = 3.2;
foam_gap_t = 18;
wall_t = skin_t + foam_gap_t + liner_t;

bottom_skin_t = 4.8;
bottom_foam_gap_t = 20;
bottom_liner_t = 4.0;
bottom_t = bottom_skin_t + bottom_foam_gap_t + bottom_liner_t;

// Splitting tuned for Prusa CORE One build volume: 250 x 220 x 270 mm.
wall_cols = 3;
wall_rows = 3;
bottom_cols = 3;
bottom_rows = 3;
tile_clearance = 0.35;

// Structural and assembly features.
edge_flange_w = 12;
rib_w = 7;
rib_h = 4;
spacer_w = 10;
spacer_pitch = 65;
port_d = 12;
drain_d = 18;
corner_post_w = 34;
rim_h = 28;
rim_lip = 16;
key_w = 12;
key_h = 3.2;
key_len = 42;

// Select part to export:
// "assembly", "wall_outer_tile", "wall_outer_tile_ported",
// "wall_inner_tile", "wall_spacer",
// "bottom_outer_tile", "bottom_inner_tile", "bottom_spacer",
// "corner_post", "rim_rail_x", "rim_rail_y", "seam_key".
part = "assembly";

// Tile selector for export. Indexes are zero-based.
tile_col = 1;
tile_row = 1;
wall_side = "front"; // "front", "back", "left", "right"

module rounded_rect_2d(size, r) {
    x = size[0];
    y = size[1];
    hull() {
        translate([r, r]) circle(r = r);
        translate([x - r, r]) circle(r = r);
        translate([x - r, y - r]) circle(r = r);
        translate([r, y - r]) circle(r = r);
    }
}

module plate(size, t, r = 1.2) {
    linear_extrude(t) rounded_rect_2d(size, r);
}

module seam_key() {
    // Loose flat spline. Glue half into one tile recess and half into the next
    // tile recess to align neighboring tiles across a seam.
    plate([key_len, key_w], key_h, r = 0.8);
}

module key_recesses(size, t) {
    x = size[0];
    y = size[1];
    z = t + rib_h - key_h + 0.05;
    d = key_h + 0.2;

    for (px = [x * 0.28, x * 0.72]) {
        translate([px - key_len / 2, -key_w / 2, z]) cube([key_len, key_w, d]);
        translate([px - key_len / 2, y - key_w / 2, z]) cube([key_len, key_w, d]);
    }

    for (py = [y * 0.28, y * 0.72]) {
        translate([-key_w / 2, py - key_len / 2, z]) cube([key_w, key_len, d]);
        translate([x - key_w / 2, py - key_len / 2, z]) cube([key_w, key_len, d]);
    }
}

module flat_skin_tile(size, t, inner_face = false, with_ports = false) {
    difference() {
        union() {
            plate(size, t);

            // Perimeter gluing flange and shallow stiffeners. These are raised
            // features on a flat print, so no support is needed.
            translate([0, 0, t]) {
                cube([size[0], edge_flange_w, rib_h]);
                translate([0, size[1] - edge_flange_w, 0]) cube([size[0], edge_flange_w, rib_h]);
                cube([edge_flange_w, size[1], rib_h]);
                translate([size[0] - edge_flange_w, 0, 0]) cube([edge_flange_w, size[1], rib_h]);

                for (x = [spacer_pitch : spacer_pitch : size[0] - spacer_pitch])
                    translate([x - rib_w / 2, edge_flange_w, 0])
                        cube([rib_w, size[1] - edge_flange_w * 2, rib_h]);
                for (y = [spacer_pitch : spacer_pitch : size[1] - spacer_pitch])
                    translate([edge_flange_w, y - rib_w / 2, 0])
                        cube([size[0] - edge_flange_w * 2, rib_w, rib_h]);
            }

        }

        key_recesses(size, t);

        if (with_ports) {
            translate([size[0] * 0.18, size[1] * 0.82, -0.1])
                cylinder(h = t + rib_h + 0.4, d = port_d);
            translate([size[0] * 0.82, size[1] * 0.18, -0.1])
                cylinder(h = t + rib_h + 0.4, d = port_d);
        }
    }
}

module spacer_ladder(size, gap_t = foam_gap_t) {
    // Printed as a flat, support-free ladder. During assembly it stands between
    // the skins and fixes the exact foam cavity distance.
    x = size[0];
    y = size[1];

    cube([x, spacer_w, gap_t]);
    translate([0, y - spacer_w, 0]) cube([x, spacer_w, gap_t]);

    for (sx = [spacer_pitch / 2 : spacer_pitch : x - spacer_pitch / 2])
        translate([sx - spacer_w / 2, 0, 0]) cube([spacer_w, y, gap_t]);

    for (sy = [spacer_pitch : spacer_pitch : y - spacer_pitch])
        translate([0, sy - spacer_w / 2, 0]) cube([x, spacer_w, gap_t]);
}

module bottom_drain_cutouts(size, h) {
    translate([size[0] / 2, size[1] / 2, -0.1])
        cylinder(h = h + 0.2, d = drain_d);
    for (dx = [-42, 42])
        for (dy = [-42, 42])
            translate([size[0] / 2 + dx, size[1] / 2 + dy, -0.1])
                cylinder(h = h + 0.2, d = drain_d * 0.55);
}

module bottom_skin_tile(size, t, inner_face = false) {
    difference() {
        flat_skin_tile(size, t, inner_face = inner_face, with_ports = false);
        bottom_drain_cutouts(size, t + rib_h + 0.2);
    }
}

module bottom_spacer_ladder(size, gap_t = bottom_foam_gap_t) {
    difference() {
        spacer_ladder(size, gap_t);
        bottom_drain_cutouts(size, gap_t + 0.2);
    }
}

function wall_tile_size(side) =
    side == "left" || side == "right"
    ? [(inner_y + tile_clearance * (wall_cols - 1)) / wall_cols,
       (inner_z + tile_clearance * (wall_rows - 1)) / wall_rows]
    : [(inner_x + tile_clearance * (wall_cols - 1)) / wall_cols,
       (inner_z + tile_clearance * (wall_rows - 1)) / wall_rows];

function bottom_tile_size() =
    [(inner_x + tile_clearance * (bottom_cols - 1)) / bottom_cols,
     (inner_y + tile_clearance * (bottom_rows - 1)) / bottom_rows];

module corner_post() {
    h = inner_z + bottom_t + rim_h;
    difference() {
        cube([corner_post_w, corner_post_w, h]);
        translate([skin_t + foam_gap_t, skin_t + foam_gap_t, bottom_t])
            cube([corner_post_w, corner_post_w, inner_z + rim_h + 0.2]);
    }
}

module rim_rail(len) {
    difference() {
        cube([len, wall_t + rim_lip, rim_h]);
        translate([0, liner_t, -0.1])
            cube([len, foam_gap_t, rim_h + 0.2]);
    }
}

module assembly_wall(side = "front") {
    ts = wall_tile_size(side);
    span = side == "left" || side == "right" ? inner_y : inner_x;
    xoff = -span / 2;

    for (c = [0 : wall_cols - 1])
        for (r = [0 : wall_rows - 1]) {
            x = xoff + c * (ts[0] - tile_clearance);
            z = bottom_t + r * (ts[1] - tile_clearance);

            translate([x, -wall_t / 2 + skin_t, z])
                rotate([90, 0, 0])
                    flat_skin_tile(ts, skin_t, inner_face = false, with_ports = r == wall_rows - 1 && c == 0);

            translate([x, wall_t / 2, z])
                rotate([90, 0, 0])
                    flat_skin_tile(ts, liner_t, inner_face = true, with_ports = false);

            translate([x, wall_t / 2 - liner_t, z])
                rotate([90, 0, 0])
                    spacer_ladder(ts, foam_gap_t);
        }
}

module assembly() {
    // Bottom sandwich.
    bts = bottom_tile_size();
    for (c = [0 : bottom_cols - 1])
        for (r = [0 : bottom_rows - 1]) {
            x = -inner_x / 2 + c * (bts[0] - tile_clearance);
            y = -inner_y / 2 + r * (bts[1] - tile_clearance);
            translate([x, y, 0]) bottom_skin_tile(bts, bottom_skin_t, inner_face = false);
            translate([x, y, bottom_skin_t]) bottom_spacer_ladder(bts, bottom_foam_gap_t);
            translate([x, y, bottom_skin_t + bottom_foam_gap_t])
                bottom_skin_tile(bts, bottom_liner_t, inner_face = true);
        }

    // Four wall sandwiches.
    translate([0, -inner_y / 2 - wall_t / 2, 0]) assembly_wall("front");
    translate([0, inner_y / 2 + wall_t / 2, 0]) rotate([0, 0, 180]) assembly_wall("back");
    translate([-inner_x / 2 - wall_t / 2, 0, 0]) rotate([0, 0, 90]) assembly_wall("left");
    translate([inner_x / 2 + wall_t / 2, 0, 0]) rotate([0, 0, -90]) assembly_wall("right");

    // Corner posts.
    for (sx = [-1, 1])
        for (sy = [-1, 1])
            translate([sx * (inner_x / 2 + wall_t / 2) - corner_post_w / 2,
                       sy * (inner_y / 2 + wall_t / 2) - corner_post_w / 2, 0])
                corner_post();

    // Top rim rails tie wall panels together.
    translate([-inner_x / 2, -inner_y / 2 - wall_t, bottom_t + inner_z])
        rim_rail(inner_x);
    translate([inner_x / 2, inner_y / 2 + wall_t, bottom_t + inner_z])
        rotate([0, 0, 180]) rim_rail(inner_x);
    translate([-inner_x / 2 - wall_t, inner_y / 2, bottom_t + inner_z])
        rotate([0, 0, -90]) rim_rail(inner_y);
    translate([inner_x / 2 + wall_t, -inner_y / 2, bottom_t + inner_z])
        rotate([0, 0, 90]) rim_rail(inner_y);
}

module export_wall_outer_tile() {
    flat_skin_tile(wall_tile_size(wall_side), skin_t, inner_face = false, with_ports = false);
}

module export_wall_outer_tile_ported() {
    flat_skin_tile(wall_tile_size(wall_side), skin_t, inner_face = false, with_ports = true);
}

module export_wall_inner_tile() {
    flat_skin_tile(wall_tile_size(wall_side), liner_t, inner_face = true, with_ports = false);
}

module export_wall_spacer() {
    spacer_ladder(wall_tile_size(wall_side), foam_gap_t);
}

module export_bottom_outer_tile() {
    bottom_skin_tile(bottom_tile_size(), bottom_skin_t, inner_face = false);
}

module export_bottom_inner_tile() {
    bottom_skin_tile(bottom_tile_size(), bottom_liner_t, inner_face = true);
}

module export_bottom_spacer() {
    bottom_spacer_ladder(bottom_tile_size(), bottom_foam_gap_t);
}

module export_corner_post() {
    corner_post();
}

module export_rim_rail_x() {
    rim_rail(inner_x / wall_cols);
}

module export_rim_rail_y() {
    rim_rail(inner_y / wall_cols);
}

module export_seam_key() {
    seam_key();
}

if (part == "assembly") {
    assembly();
} else if (part == "wall_outer_tile") {
    export_wall_outer_tile();
} else if (part == "wall_outer_tile_ported") {
    export_wall_outer_tile_ported();
} else if (part == "wall_inner_tile") {
    export_wall_inner_tile();
} else if (part == "wall_spacer") {
    export_wall_spacer();
} else if (part == "bottom_outer_tile") {
    export_bottom_outer_tile();
} else if (part == "bottom_inner_tile") {
    export_bottom_inner_tile();
} else if (part == "bottom_spacer") {
    export_bottom_spacer();
} else if (part == "corner_post") {
    export_corner_post();
} else if (part == "rim_rail_x") {
    export_rim_rail_x();
} else if (part == "rim_rail_y") {
    export_rim_rail_y();
} else if (part == "seam_key") {
    export_seam_key();
}
