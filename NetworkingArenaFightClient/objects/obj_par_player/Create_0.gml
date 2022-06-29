/// @description Create the player
event_inherited()

player_ts = 0

// 0 to 3 is direction
state[0] = 0 
state[1] = 0
state[2] = 0
state[3] = 0
// Click left button
state[4] = 0

// This is to display the correct animation
prev_x = x
prev_y = y

state_received = 0
debug_txt = ""

// Detect whether mouse is clicked or not. Instead of using built-in mouse_check_pressed
// It's easier to transfer mouse state rather than even since the server need to receive it 
is_mouse_clicked = false
is_mouse_released = false
prev_mouse_state = 0

apply_simulation = function(_input) {
	x += vel*(_input[1] - _input[0])
	y += vel*(_input[3] - _input[2])
}

// CALLBACKS
on_click = function() {}