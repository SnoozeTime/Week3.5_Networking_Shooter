/// @description Extract all the colliders and print coordinates.

with obj_par_collision {
	var _name = object_get_name(id)
	log(string_interpolate("{}: x {} y {}", [_name, x, y]))	
	log(string_interpolate("{}: Bbox {}  {} {} {}", [_name, bbox_top, bbox_left, bbox_right, bbox_bottom]))	
}