/// @description

#macro view view_camera[0]

camera_set_view_size(view, view_width, view_height)


if target != noone and target != undefined {
	with (target) {
		var _buff = other.buff
		var _vw = other.view_width
		var _vh = other.view_height
		var _shake_remain = other.shake_remain
		// keep camera inside the room
		var _x = clamp(x - _vw/2, _buff, room_width-_vw-_buff)
		var _y =  clamp(y - _vh/2, _buff, room_height-_vh-_buff)
	
		// Screen shake
		_x += random_range(-_shake_remain, _shake_remain)
		_y += random_range(-_shake_remain, _shake_remain)
		other.shake_remain = max(0, _shake_remain - ((1/other.shake_length)*other.shake_magnitude))
	
	
		var _cur_x = camera_get_view_x(view)
		var _cur_y = camera_get_view_y(view)
	
		// Lerp position of camera to have smooth movement.
		var _spd = .1;
	
	
		//camera_set_view_pos(view, 
		//	lerp(_cur_x, _x, _spd),
		//	lerp(_cur_y, _y, _spd))
		camera_set_view_pos(view, _x, _y)
	}
}
