/*
  Modular foam-fill planter shell (OpenSCAD)

  Goals:
  - Minimum internal soil volume: 500x500x500 mm (configurable, set >= 500)
  - Double-wall construction with an intentional foam cavity between outer shell and inner liner
  - Split into grid pieces so smaller printers can produce parts
  - Added structural ribs and thick base/walls for heavy soil loads
*/

$fn = 48;

// ---------------------------
// Core dimensions (mm)
// ---------------------------
inner_x = 500;   // minimum 500
inner_y = 500;   // minimum 500
inner_z = 500;   // minimum 500

// Structural thicknesses (tune for strength)
liner_wall_t = 8;    // inner wall touching soil
liner_base_t = 10;   // bottom of soil cavity
foam_gap_t   = 18;   // intentional void for polyurethane foam fill
outer_wall_t = 6;    // external shell wall
outer_base_t = 10;   // external shell base

// Reinforcement between outer shell and liner
rib_t = 6;
rib_count_per_side = 3;

// Split settings for small printers
split_x = 2;
split_y = 2;
piece_ix = 0;      // [0 : split_x-1]
piece_iy = 0;      // [0 : split_y-1]
part = "piece";    // ["piece", "full_preview"]

// Seam connectors
pin_d = 10;
pin_len = 12;
pin_clearance = 0.35;
pin_edge_offset = 22;

// Foam fill / vent ports
port_d = 16;
port_z_from_base = 40;

// ---------------------------
// Derived dimensions
// ---------------------------
ox = inner_x + 2*(liner_wall_t + foam_gap_t + outer_wall_t);
oy = inner_y + 2*(liner_wall_t + foam_gap_t + outer_wall_t);
oz = inner_z + liner_base_t + foam_gap_t + outer_base_t;

liner_ox = inner_x + 2*liner_wall_t;
liner_oy = inner_y + 2*liner_wall_t;
liner_oz = inner_z + liner_base_t;

soil_bottom_z = -oz/2 + outer_base_t + foam_gap_t + liner_base_t;

function x_min(i) = -ox/2 + i*ox/split_x;
function x_max(i) = -ox/2 + (i+1)*ox/split_x;
function y_min(j) = -oy/2 + j*oy/split_y;
function y_max(j) = -oy/2 + (j+1)*oy/split_y;

module outer_shell_only() {
  difference() {
    cube([ox, oy, oz], center=true);
    translate([0, 0, outer_base_t/2])
      cube([ox - 2*outer_wall_t, oy - 2*outer_wall_t, oz - outer_base_t + 0.02], center=true);
  }
}

module inner_liner_only() {
  difference() {
    translate([0, 0, -oz/2 + outer_base_t + foam_gap_t + liner_oz/2])
      cube([liner_ox, liner_oy, liner_oz], center=true);

    // Soil chamber (open top)
    translate([0, 0, -oz/2 + outer_base_t + foam_gap_t + liner_base_t + inner_z/2])
      cube([inner_x, inner_y, inner_z + 0.02], center=true);
  }
}

module tie_ribs() {
  // Ribs connect outer shell and inner liner for load transfer.
  // They are sparse so foam can still flow around/through during fill.

  z0 = -oz/2 + outer_base_t + 8;
  z1 = oz/2 - 24;
  step = (inner_y) / (rib_count_per_side + 1);

  // X-direction walls (left/right)
  for (k = [1 : rib_count_per_side]) {
    yy = -inner_y/2 + k*step;
    for (sx = [-1, 1]) {
      x_mid = sx*(inner_x/2 + liner_wall_t + foam_gap_t/2);
      translate([x_mid, yy, (z0+z1)/2])
        cube([foam_gap_t, rib_t, z1-z0], center=true);
    }
  }

  // Y-direction walls (front/back)
  stepx = (inner_x) / (rib_count_per_side + 1);
  for (k = [1 : rib_count_per_side]) {
    xx = -inner_x/2 + k*stepx;
    for (sy = [-1, 1]) {
      y_mid = sy*(inner_y/2 + liner_wall_t + foam_gap_t/2);
      translate([xx, y_mid, (z0+z1)/2])
        cube([rib_t, foam_gap_t, z1-z0], center=true);
    }
  }
}

module foam_ports() {
  // Ports into foam cavity; can be plugged after foam expansion.
  for (sx = [-1, 1]) {
    translate([sx*(ox/2 - outer_wall_t/2), 0, -oz/2 + outer_base_t + port_z_from_base])
      rotate([0, 90, 0])
        cylinder(h=outer_wall_t + 0.8, d=port_d, center=true);
  }
}

module full_planter() {
  difference() {
    union() {
      outer_shell_only();
      inner_liner_only();
      tie_ribs();
    }
    foam_ports();
  }
}

module piece_bounds(ix, iy) {
  x0 = x_min(ix);
  x1 = x_max(ix);
  y0 = y_min(iy);
  y1 = y_max(iy);
  translate([(x0+x1)/2, (y0+y1)/2, 0])
    cube([x1-x0, y1-y0, oz + 2], center=true);
}

module seam_pins_male(ix, iy) {
  za = -oz/2 + 50;
  zb = oz/2 - 40;

  if (ix < split_x-1) {
    for (zz = [za, zb])
      translate([x_max(ix) - pin_edge_offset, 0, zz])
        rotate([0, 90, 0])
          cylinder(h=pin_len, d=pin_d, center=false);
  }

  if (iy < split_y-1) {
    for (zz = [za, zb])
      translate([0, y_max(iy) - pin_edge_offset, zz])
        rotate([-90, 0, 0])
          cylinder(h=pin_len, d=pin_d, center=false);
  }
}

module seam_pins_female(ix, iy) {
  za = -oz/2 + 50;
  zb = oz/2 - 40;

  if (ix > 0) {
    for (zz = [za, zb])
      translate([x_min(ix) + pin_edge_offset - pin_len, 0, zz])
        rotate([0, 90, 0])
          cylinder(h=pin_len + 0.8, d=pin_d + pin_clearance, center=false);
  }

  if (iy > 0) {
    for (zz = [za, zb])
      translate([0, y_min(iy) + pin_edge_offset - pin_len, zz])
        rotate([-90, 0, 0])
          cylinder(h=pin_len + 0.8, d=pin_d + pin_clearance, center=false);
  }
}

module piece(ix, iy) {
  difference() {
    union() {
      intersection() {
        full_planter();
        piece_bounds(ix, iy);
      }
      seam_pins_male(ix, iy);
    }
    seam_pins_female(ix, iy);
  }
}

if (part == "full_preview") {
  full_planter();
} else {
  piece(piece_ix, piece_iy);
}
