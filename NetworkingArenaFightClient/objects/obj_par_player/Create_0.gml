/// @description Create the player
event_inherited()

enum player_state {
	idle,
	running,
	hurt,
	dead
}
my_state = player_state.idle
anim_array[player_state.idle] = idle_anim
anim_array[player_state.hurt] = hurt_anim
anim_array[player_state.running] = run_anim
anim_array[player_state.dead] = run_anim
player_ts = 0

// 0 to 3 is direction
state[0] = 0 
state[1] = 0
state[2] = 0
state[3] = 0
// Click left button
state[4] = 0

hp = 5

// This is to display the correct animation
prev_x = x
prev_y = y

state_received = 0
debug_txt = ""
player_name = ""

// Detect whether mouse is clicked or not. Instead of using built-in mouse_check_pressed
// It's easier to transfer mouse state rather than even since the server need to receive it 
is_mouse_clicked = false
is_mouse_released = false
prev_mouse_state = 0

apply_simulation = function(_input) {
	var _dx = vel*(_input[1] - _input[0])
	var _dy = vel*(_input[3] - _input[2])
				
	if !place_meeting(x+_dx, y, obj_par_collision) {	
		x += _dx
	}
	if !place_meeting(x, y+_dy, obj_par_collision) {		
		y += _dy
	}
}

update_health = function(_hp) {
	hp = _hp
	if hp == 0 {
		visible = false	
		my_state = player_state.dead
		on_death()
	}
	
	// RESPAWN
	if my_state == player_state.dead and hp > 0 {
		visible = true	
		my_state = player_state.idle
		on_respawn()
	}
}
// CALLBACKS
on_click = function() {}
on_respawn = function() {}
on_death = function() {}