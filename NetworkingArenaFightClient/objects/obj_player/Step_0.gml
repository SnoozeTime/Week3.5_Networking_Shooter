/// @description Movement

/* Player movement; If local player, then send the state to the server
   and move to where the player is supposed to be. It is in "current time"
   Server will then send the real state and the correction can be done.
   
   For other players, positions are displayed in the past (100ms). The reason is to show
   a nice and smooth movement (interpolated) rather than an update every server tick.

*/
#region Player movement (local and online)
if IsLocal() {
	player_ts += 1

	// Capture and send input
	state[0] = keyboard_check(vk_left)
	state[1] = keyboard_check(vk_right)
	state[2] = keyboard_check(vk_up)
	state[3] = keyboard_check(vk_down)

	send_input(player_ts, state)
	
	// Apply movement
	// -----------------------------
	
	// Then movement from input
	x += vel*(state[1] - state[0])
	y += vel*(state[3] - state[2])

	// Add to state buffer
	var _input_copy = array_create(4)
	array_copy(_input_copy, 0, state, 0, 4)
	ringbuffer_push(rb, player_ts, _input_copy, [x, y])
} else {
	
	var _rb_idx = ringbuffer_find(rb, current_interpolated_ts)
	
	if _rb_idx >= 0 {
		
		// Let's try next state to interpolate
		if _rb_idx != rb.buffer_end {
			var _idx = _rb_idx - 1
			// case where _rb_idx = 0
			if _idx < 0 {
				_idx = max_buffer_size-1
			}
			
			if rb.buffer[_idx] != noone {
				var _initialState = rb.buffer[_idx][rb_state_idx]
				var _final_state = rb.buffer[_rb_idx][rb_state_idx]
				var _end_ts =  rb.buffer[_rb_idx][rb_ts_idx]
				var _start_ts =  rb.buffer[_idx][rb_ts_idx]
			
				// now interpolate.
				var l = (current_interpolated_ts - _start_ts) / real(_end_ts - _start_ts)
				x = l * (_final_state[0] - _initialState[0]) +  _initialState[0]
				y = l * (_final_state[1] - _initialState[1]) +  _initialState[1]

			}
		}
		
	} 
	
	if state_received == 2 {
		current_interpolated_ts += 1
	}
}
#endregion


// Check direction of player and update sprite
#region Animation

if x > prev_x {
	// going to the left
	image_xscale = 1
} else if x < prev_x {
	image_xscale = -1
}

prev_x = x

#endregion