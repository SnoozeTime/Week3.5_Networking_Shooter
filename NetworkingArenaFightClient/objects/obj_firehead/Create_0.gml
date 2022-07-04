event_inherited()


// Instantiate one fireball that follows the mouse.
my_fireball = instance_create_layer(x, y, layer, obj_firehead_hand)
my_fireball.my_player = self


after_local_movement = function() {
	adjust_fireball_pos(mouse_x, mouse_y)
}

after_remote_movement = function() {
	adjust_fireball_pos(look_at[0], look_at[1])
}

adjust_fireball_pos = function(_mouse_x, _mouse_y) {
	
	var _x = _mouse_x - x
	var _y = _mouse_y - (y-8)
	
	if _x != 0 || _y != 0 {
		var _l = sqrt(_x*_x + _y*_y)
		my_fireball.x = x + 10*_x/_l
		my_fireball.y = (y-8) + 10*_y/_l
	}
}

on_click = function() {
	var _x = mouse_x - x
	var _y = mouse_y - (y-8)
	primary_action(_x, _y)
	//instance_create_layer(my_fireball.x, my_fireball.y, layer, obj_fireball, {dir_x: _x, dir_y: _y})
}


primary_action = function(_x, _y) {
	var _bullet = instance_create_layer(my_fireball.x, my_fireball.y, layer, obj_fireball, {dir_x: _x, dir_y: _y})
	with _bullet {
		init(other.net_entity_id)
	}
}

on_death = function() {
	my_fireball.visible = false	
}

on_respawn = function() {
	my_fireball.visible = true
}