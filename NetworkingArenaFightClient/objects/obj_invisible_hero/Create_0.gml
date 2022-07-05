event_inherited()

is_invisible = false

after_local_movement = function() {
}

after_remote_movement = function() {
}

on_click = function() {
	var _x = mouse_x - x
	var _y = mouse_y - (y-8)
	primary_action(_x, _y)
}

primary_action = function(_x, _y) {}

on_secondary_skill = function() {
	is_invisible = !is_invisible
	display_name = !is_invisible
}

on_death = function() {
	is_invisible = false
	display_name = true
}

on_respawn = function() {
	is_invisible = false
	display_name = true
}

custom_draw = function() {
	if is_invisible {
		shader_set(shd_invisibility)
	}
	
	draw_self()	
	shader_reset()
}