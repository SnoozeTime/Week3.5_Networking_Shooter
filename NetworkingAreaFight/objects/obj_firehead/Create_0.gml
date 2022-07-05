/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

primary_skill = function(_fromClient) {
	var _input = _fromClient[1]
	var _mouse_dir = [_input[6], _input[7]]
	var _x = _mouse_dir[0] - x
	var _y = _mouse_dir[1] - (y-8)
	var b = instance_create_depth(x, y, layer, obj_par_projectile, { dir_x: _x, dir_y: _y } )
	b.my_parent = self
	return new ShootEvent(0, player_id, _fromClient[0]	, b.dir)
}