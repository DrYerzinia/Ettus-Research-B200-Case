// Board Thickness: 1.56mm
// Board Length: 154.66mm
// Board Width: 99.9mm
// Hole Width Seperation: 93mm
// Hole Length Seperation: 120mm
// Hole Short Edge Distance: 14.5mm
// DC Jack Width: 9mm
// DC Jack Height: 11mm
// DC Jack Center From Edge: 10.25mm
// USB Jack Width: 12mm
// USB Jack Height: 12.7mm
// USB Jack Center From Edge: 48mm
// Jack Protursion: 2.9mm
// SMA protrusion: 0.5mm
// SMA Diameter: 6.3mm
// SMA Board Offset: 0.5mm
// SMA Width: 9.5mm
// SMA Height: 7.9mm
// SMA Below Board Protrusion: 2mm
// SMA Seperation: 20 mm
// SMA Antenna Board Edge: 11.6mm
// SMA GPS Board Edge: 9.4mm
// SMA PPS Board Edge: 24mm

board_width = 99.9;
board_length = 154.66;
board_thickness = 1.56;

hole_seperation_width = 93;
hole_seperation_length = 120;
hole_edge_distance = 14.5;

dc_width = 9.4;
dc_height = 12.5;
dc_length = 14.1;
dc_edge_distance = 10.25;

usb_width = 12.5;
usb_height = 14.2;
usb_length = 18.5;
usb_edge_distance = 48;

jack_protrusion = 2.8 + 2;

sma_base_thick = 1.5;
sma_length = 11;
sma_diameter = 7.3;
sma_board_offset = 0.5;
sma_width = 9.5;
sma_height = 7.9;
sma_below_board = 2;
sma_protrusion = 0.5;
sma_spacing = 20;

sma_antenna_edge = 11.6;
sma_pps_edge = 24;
sma_gps_edge = 9.4;

screw_shank_length = 12.2;
screw_shank_diameter = 2.8;

screw_port_offset = 25;
screw_padding = 2;
wall_thickness = 1.7;
side_thickness = 3.5;
edge_space = 1;

module sma(center_offset){
	translate([
		center_offset,
		board_length / 2 - (sma_base_thick / 2) + sma_protrusion,
		(-(board_thickness / 2)) + (sma_height / 2) - sma_below_board
	]){
		cube(
			size =
				[
					sma_width,
					sma_base_thick,
					sma_height
				],
			center = true
		);
		rotate([90,0,0]){
			translate([0,0,-sma_length/2]){
				cylinder(
					h = sma_length,
					r = sma_diameter / 2,
					center = true,
					$fn = 100
				);
			}
		}
	}
}

module board(){
	// PCB
	cube(
		size =
			[
				board_width,
				board_length,
				board_thickness
			],
		center = true
	);
	// DC Jack
	translate([
		(-(board_width / 2)) + dc_edge_distance,
		board_length / 2 - dc_length / 2 + jack_protrusion,
		(board_thickness / 2) + (dc_height / 2)
	]){
		cube(
			size =
				[
					dc_width,
					dc_length,
					dc_height
				],
			center = true
		);
	}
	// USB Jack
	translate([
		(-(board_width / 2)) + usb_edge_distance,
		board_length / 2 - usb_length / 2 + jack_protrusion,
		(board_thickness / 2) + (usb_height / 2)
	]){
		cube(
			size =
				[
					usb_width,
					usb_length,
					usb_height
				],
			center = true
		);
	}
	// SMA
	// GPS ANT
	sma(board_width / 2 - sma_width / 2 - sma_gps_edge);
	// 10MHz
	sma(board_width / 2 - sma_width / 2 - sma_gps_edge - sma_spacing);
	// PPS
	sma(-board_width / 2 + sma_width / 2 + sma_pps_edge);
	// Antennas
	rotate([0,0,180]){
		sma(board_width / 2 - sma_width / 2 - sma_antenna_edge);
		sma(board_width / 2 - sma_width / 2 - sma_antenna_edge - sma_spacing);
	}
}

module edge1(offset, sub=0){
	translate([0,offset,0]){
		cube(
			size =
				[
					board_width + ((edge_space + side_thickness) * 2) - sub,
					side_thickness,
					wall_thickness * 2
					+ screw_shank_length + board_thickness + usb_height
				],
			center = true
		);
	}
}

module edge2(offset){
	translate([offset,0,0]){
		cube(
			size =
				[
					side_thickness,
					board_length + ((edge_space + side_thickness) * 2),
					wall_thickness * 2
					+ screw_shank_length + board_thickness + usb_height
				],
			center = true
		);
	}
}

module screw_port(x, y){
	translate([x - (screw_shank_diameter / 2 + screw_padding),y,
		usb_height - screw_shank_length / 2 + board_thickness * 1.5 + wall_thickness - 3.5
	]){
		difference(){
			difference(){
				union(){
					cylinder(
						h = screw_shank_length + 7,
						r = screw_shank_diameter / 2 + screw_padding,
						center = true,
						$fn = 100
					);
					translate([screw_shank_diameter / 4 + screw_padding / 2,0,0]){
						cube(
							[
								screw_shank_diameter / 2 + screw_padding,
								screw_shank_diameter + screw_padding * 2,
								screw_shank_length + 7
							],
							center = true
						);
					}
				}
				cylinder(
					h = screw_shank_length + 8,
					r = screw_shank_diameter / 2,
					center = true,
					$fn = 100
				);
			}
			translate([0,0,-10.5]){
				rotate([0,-45,0]){
					cube(
						[
							screw_shank_diameter / 2 + screw_padding + 6,
							screw_shank_diameter + screw_padding * 2 + 1,
							(screw_shank_diameter + screw_padding * 2)*2+7
						],
						center = true
					);
				}
			}
		}
	}
}

module shank(x, y, z_offset = 0){
	translate([x,y,
		- wall_thickness / 2 + board_thickness / 2 - screw_shank_length / 2
	]){
		difference(){
			cylinder(
				h = screw_shank_length,
				r = screw_shank_diameter / 2 + screw_padding,
				center = true,
				$fn = 100
			);
			cylinder(
				h = screw_shank_length + 1,
				r = screw_shank_diameter / 2,
				center = true,
				$fn = 100
			);
		}
	}
}

long_edge_offset = board_length / 2 + edge_space + side_thickness / 2;
short_edge_offset = board_width / 2 + edge_space + side_thickness / 2;

module base(){
	cube(
		size =
			[
				board_width + ((edge_space + side_thickness) * 2),
				board_length + ((edge_space + side_thickness) * 2),
				wall_thickness
			],
		center = true
	);
}

module case_slide(extra_width=0){
	translate([board_width / 2 + edge_space - wall_thickness * 1.5,0,
		usb_height - wall_thickness * 0.5 + board_thickness * 1.5]){
		difference(){
			cube([
				wall_thickness * 3,
				board_length + ((edge_space + side_thickness) * 2)+extra_width,
				wall_thickness * 3
			], center = true);
			rotate([0,45,0]){
				translate([0,0,- wall_thickness * 1.5]){
					cube([
						wall_thickness * 9,
						board_length + ((edge_space + side_thickness) * 2)+1+extra_width,
						wall_thickness * 3
					], center = true);
				}
			}
		}
	}
}

module case1(){
	// Bottom
	translate([0,0,
		- wall_thickness / 2
		+ board_thickness / 2
		- screw_shank_length]
	){
		base();
	}
	// Walls
	translate([0,0,
		usb_height / 2 + board_thickness - screw_shank_length / 2
	]){
		//edge1(long_edge_offset);
		edge1(-long_edge_offset);
		edge2(short_edge_offset);
		edge2(-short_edge_offset);
	}
	// Shanks
	shank(
		hole_seperation_width / 2,
		board_length / 2 - hole_edge_distance);
	shank(
		hole_seperation_width / 2,
		board_length / 2 - hole_edge_distance - hole_seperation_length);
	shank(
		- hole_seperation_width / 2,
		board_length / 2 - hole_edge_distance);
	shank(
		-  hole_seperation_width / 2,
		board_length / 2 - hole_edge_distance - hole_seperation_length);
	// Top Holders
/*	screw_port(
		board_width / 2 + edge_space,
		board_length / 2 - screw_port_offset);
	screw_port(
		board_width / 2 + edge_space,
		-board_length / 2 + screw_port_offset - 15);
	mirror([1,0,0]){
		screw_port(
			board_width / 2 + edge_space,
			board_length / 2 - screw_port_offset);
		screw_port(
			board_width / 2 + edge_space,
			-board_length / 2 + screw_port_offset - 15);
	}*/
	case_slide();
	mirror([1,0,0]) case_slide();
}

module top1(thick, thin=0, shift=0){
	translate([0,0,
		wall_thickness * 0.5
		+ usb_height
		+ board_thickness * 1.5
		+ shift
	]){
	cube(
		size =
			[
				board_width + ((edge_space + thin) * 2 - 0.2),
				board_length + ((edge_space + side_thickness) * 2),
				thick
			],
		center = true
	);
	}
}

module case_top(){
	difference(){
		union(){
			top1(wall_thickness*2.1);
			top1(wall_thickness*0.5, side_thickness, wall_thickness*0.8);
			translate([0,long_edge_offset, + wall_thickness * 2]){
				cube(
					size =
						[
							board_width + edge_space * 2,
							side_thickness,
wall_thickness
+ screw_shank_length + board_thickness + usb_height
//							screw_shank_length + board_thickness
//							+ usb_height - side_thickness * 0.5
						],
					center = true
				);
			}
		}
		union(){
			board();
			case_bottom();
		}
	}
}

module case_bottom(){
	difference(){
		case1();
		board();
	}
}

case_top();
//board();
//case_bottom();