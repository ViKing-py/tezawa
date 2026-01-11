// ==========================================
// PROJECT: TEZAWA V2.0 (printed)
// ==========================================

// --- DIMENSIONS ---
sensor_width = 11.5;        // Sensor width
hole_center_distance = 15;  // Distance between holes
bolt_diameter = 4.8;        // Slightly larger than M4 for easy fit
slot_length = 3;            // Slot (oval) length
base_thickness = 5;         // Base thickness
handle_width = 20;          // Handle width
spacer_height = 3;          // Step height under the sensor

$fn = 60; // Smoothness

// Module for drilling an oval slot
module make_slot() {
    hull() {
        translate([slot_length/2, 0, 0]) cylinder(h=50, d=bolt_diameter, center=true);
        translate([-slot_length/2, 0, 0]) cylinder(h=50, d=bolt_diameter, center=true);
    }
}

// ------------------------------------------------
// PART 1: HANDLE
// ------------------------------------------------
module handle_part() {
    translate([-45, 0, 0]) { 
        difference() {
            // STEP 1: BUILD SOLID BODY (Union)
            union() {
                // 1. Main plate (long)
                translate([0, 0, base_thickness/2])
                    cube([90, handle_width, base_thickness], center=true);
                
                // 2. Step for the sensor (shifted forward)
                translate([90/2 - 15, 0, base_thickness + spacer_height/2])
                    cube([25, sensor_width, spacer_height], center=true);

                // 3. Handle thickening (ROUNDED)
                translate([-22, 0, handle_width/2.0]) // Raised center by 12.5 mm (radius)
                    rotate([0, 90, 0]) // Lay the cylinder on its side
                    cylinder(h=45, d=handle_width, center=true);
                
                // 4. Text (embossed, so it doesn’t cut the body)
                translate([22, -9, base_thickness - 0.2])
                    linear_extrude(1) text("TEZAWA", size=3);
            }

            // STEP 2: DRILL HOLES (Subtract from solid)
            // Front slot
            translate([90/2 - 15 + hole_center_distance/2, 0, 0]) make_slot();
            // Rear slot
            translate([90/2 - 15 - hole_center_distance/2, 0, 0]) make_slot();
        }
    }
}

// ------------------------------------------------
// PART 2: PROBE TIP
// ------------------------------------------------
module probe_part() {
    translate([35, 0, 0]) { 
        difference() {
            // STEP 1: SOLID BODY
            union() {
                // 1. Main plate
                translate([0, 0, base_thickness/2])
                    cube([35, handle_width, base_thickness], center=true);
                
                // 2. Step for the sensor (at the back)
                translate([-35/2 + 12, 0, base_thickness + spacer_height/2])
                    cube([20, sensor_width, spacer_height], center=true);

                // 3. Finger (extends from the front)
                translate([13, 0, base_thickness/2]) 
                    rotate([0, 90, 0])
                    cylinder(h=25, r=8); // r=8 means diameter 16 mm
                
                // 4. Ball at the end
                translate([13 + 25, 0, base_thickness/2])
                    sphere(r=8);
            }

            // STEP 2: DRILL HOLES
            // Since the part is mirrored, coordinates are mirrored relative to the mounting center
            translate([-35/2 + 12 + hole_center_distance/2, 0, 0]) make_slot();
            translate([-35/2 + 12 - hole_center_distance/2, 0, 0]) make_slot();
        }
    }
}

// RENDER
handle_part();
probe_part();
