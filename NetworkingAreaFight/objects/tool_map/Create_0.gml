/// @description Insert description here
// You can write your code in this editor

/*
12594: <undefined>: x 194 y 322
12594: <undefined>: Bbox 305  151 232.00 322.00
12594: <undefined>: x 72 y 152
12594: <undefined>: Bbox 146  61 83.00 151.00
12594: <undefined>: x 48 y 152
12594: <undefined>: Bbox 146  37 59.00 151.00
12594: <undefined>: x 24 y 152
12594: <undefined>: Bbox 146  13 35.00 151.00
*/


var _objs = [[151, 305, 232, 322], [61, 146, 83, 151], [37, 146, 59, 151], [13, 146, 35, 151]]
for (var _i=0; _i < array_length(_objs); _i++) {
	var _data = _objs[_i]
	with instance_create_layer(_data[0], _data[1], "Instances", obj_collider) {
		var w = _data[2]-_data[0]
		var h = _data[3]-_data[1]
		image_xscale = w
		image_yscale = h
	}	
}