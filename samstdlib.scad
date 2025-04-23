module bolt_circle(num_bolts, circle_radius, hole_diameter, hole_height) {
    for (i = [0:num_bolts-1]) {
        angle = i * 360 / num_bolts;
        x = circle_radius * cos(angle);
        y = circle_radius * sin(angle);
        translate([x, y, 0]) {
            cylinder(h = hole_height, d = hole_diameter);
        }
    }
}

module bolt_square(num_x, num_y, spacing_x, spacing_y, hole_diameter, hole_height) {
    for (i = [0:num_x-1])
        for (j = [0:num_y-1]) {
            x = (i - (num_x - 1) / 2) * spacing_x;
            y = (j - (num_y - 1) / 2) * spacing_y;
            translate([x, y, 0]) {
                cylinder(h = hole_height, d = hole_diameter);
            }
        }
}

// M1 Nut Trap (w = 2.3mm, h = 0.8mm)
module m1_nut_trap (w = 2.3, h = 0.81) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M2 Nut Trap (w = 3.7mm, h = 1.6mm)
module m2_nut_trap (w = 3.7, h = 1.61) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M3 Nut Trap (w = 4.3mm, h = 1.8mm)
module m3_nut_trap (w = 4.3, h = 1.81) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M4 Nut Trap (w = 5.3mm, h = 2.2mm)
module m4_nut_trap (w = 5.3, h = 2.21) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M5 Nut Trap (w = 6.4mm, h = 2.5mm)
module m5_nut_trap (w = 6.4, h = 2.51) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M6 Nut Trap (w = 7.0mm, h = 2.8mm)
module m6_nut_trap (w = 7.0, h = 2.81) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M7 Nut Trap (w = 8.0mm, h = 3.0mm)
module m7_nut_trap (w = 8.0, h = 3.01) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// M8 Nut Trap (w = 9.0mm, h = 3.5mm)
module m8_nut_trap (w = 9.0, h = 3.51) {
    cylinder(r = w / 2 / cos(180 / 6) + 0.05, h = h, $fn = 6);
}

// Nut Trap Circle for M1 to M8
module nut_trap_circle(n, r, nut_type = "m2") {
    for (i = [0 : n-1]) {
        angle = 360 / n * i;  // Angle for each nut trap
        x = r * cos(angle);   // X position
        y = r * sin(angle);   // Y position

        translate([x, y, 0]) {
            if (nut_type == "m1") {
                m1_nut_trap();
            } else if (nut_type == "m2") {
                m2_nut_trap();
            } else if (nut_type == "m3") {
                m3_nut_trap();
            } else if (nut_type == "m4") {
                m4_nut_trap();
            } else if (nut_type == "m5") {
                m5_nut_trap();
            } else if (nut_type == "m6") {
                m6_nut_trap();
            } else if (nut_type == "m7") {
                m7_nut_trap();
            } else if (nut_type == "m8") {
                m8_nut_trap();
            }
        }
    }
}

module hollow_cylinder(outer_d, inner_d, h, center = false, fn = 64) {
    difference() {
        cylinder(d = outer_d, h = h, center = center, $fn = fn);
        translate([0, 0, -1]) cylinder(d = inner_d, h = h + 2, center = center, $fn = fn); // +2 to avoid coplanar face errors
    }
}

module hollow_cuboid(w, h, d, wall_thickness) {
    difference() {
        cube([w, h, d]);
        
        cube([w - 2 * wall_thickness, h - 2 * wall_thickness, d - 2 * wall_thickness], true);
    }
}

module gear20dp(n_teeth, thickness=5, pressure_angle=20, bore=5) {
    pitch_diameter = n_teeth / 20;
    base_diameter = pitch_diameter * cos(pressure_angle);
    outer_diameter = (n_teeth + 2) / 20;
    root_diameter = (n_teeth - 2.5) / 20;  // tweakable

    $fn=100;

    difference() {
        union() {
            // gear body
            cylinder(h=thickness, d=outer_diameter);
            
            // crude approximation of teeth
            for (i = [0:n_teeth-1]) {
                angle = 360 * i / n_teeth;
                rotate([0,0,angle])
                    translate([pitch_diameter * PI / n_teeth, 0, 0])
                        cube([0.6 * pitch_diameter * PI / n_teeth, 1.5, thickness], center=true);
            }
        }
        // bore
        cylinder(h=thickness + 1, d=bore, center=true);
    }
}

module hollow_hex(outer_radius=20, wall_thickness=3, height=10) {
    difference() {
        linear_extrude(height)
            polygon(points=regular_ngon(6, outer_radius));
        linear_extrude(height + 2)
            polygon(points=regular_ngon(6, outer_radius - wall_thickness));
        translate([0, 0, -0.1]) {
            union() {
                linear_extrude(1) {
                    polygon(points=regular_ngon(6, outer_radius - wall_thickness));
                } 
            }
        }
    }
}


module hollow_hex_capped(outer_radius=20, wall_thickness=3, height=10, dr = outer_radius - 2, dt = wall_thickness - 1, dh = height - 3, diff_translate=[0, 0, 8]) {
    difference() {
        linear_extrude(height)
            polygon(points=regular_ngon(6, outer_radius));
        linear_extrude(height + 2)
            polygon(points=regular_ngon(6, outer_radius - wall_thickness));
        translate([0, 0, -0.1]) {
            union() {
                linear_extrude(1) {
                    polygon(points=regular_ngon(6, outer_radius - wall_thickness));
                } 
            }
        }
    }
}

// helper function to make a regular N-gon
function regular_ngon(n, r) = 
    [ for (i = [0 : n-1]) 
        [ r*cos(360*i/n), r*sin(360*i/n) ] ];
