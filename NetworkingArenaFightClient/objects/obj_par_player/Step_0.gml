/// @description Movement
event_inherited()
/* Player movement; If local player, then send the state to the server
   and move to where the player is supposed to be. It is in "current time"
   Server will then send the real state and the correction can be done.
   
   For other players, positions are displayed in the past (100ms). The reason is to show
   a nice and smooth movement (interpolated) rather than an update every server tick.

*/
#region Player movement (local and online)
if is_local() {
	player_ts += 1

	// Capture and send input
	if my_state != player_state.dead {
		state[0] = keyboard_check(vk_left)
		state[1] = keyboard_check(vk_right)
		state[2] = keyboard_check(vk_up)
		state[3] = keyboard_check(vk_down)
		state[4] = mouse_check_button(mb_left)
	} else {
		state[0] = 0
		state[1] = 0
		state[2] = 0
		state[3] = 0
		state[4] = 0
	}

	send_input(player_ts, state)

	// Apply movement
	// -----------------------------
	
	// Then movement from input
	x += vel*(state[1] - state[0])
	y += vel*(state[3] - state[2])

	// Add to state buffer
	var _input_copy = array_create(array_length(state))
	array_copy(_input_copy, 0, state, 0, array_length(state))
	ringbuffer_push(rb, player_ts, _input_copy, [x, y])
	
	// Callback for character specific action
	after_local_movement()
}
#endregion

// Shooting
if is_local() {
	
	if prev_mouse_state != state[4] {
		is_mouse_clicked = state[4] == 1		
		is_mouse_released = state[4] == 0		
	} else {
		is_mouse_clicked = false	
		is_mouse_released = false	
	}
	
	prev_mouse_state = state[4]
	
	if is_mouse_clicked and my_state != player_state.dead {
		on_click()
	}
}


// Check if collision with projectile. - No collision if already dead
if my_state != player_state.dead {
	with obj_par_projectile {
		if my_parent != noone {
			if place_meeting(x, y, other) and my_parent != other.net_entity_id {
				instance_destroy()
				// burp
				other.my_state = player_state.hurt
				other.image_index = 0
			}
		}
	}
}

// Check direction of player and update sprite
#region Animation
if my_state != player_state.dead {
	// looking left or right?
	if x > prev_x {
		// going to the left
		image_xscale = 1
	} else if x < prev_x {
		image_xscale = -1
	}
	var _moving =  y != prev_y or x != prev_x

	if my_state != player_state.hurt {
		if _moving {
			my_state = player_state.running
		} else {
			my_state = player_state.idle
		}
	}
}

prev_x = x
prev_y = y

sprite_index = anim_array[my_state]
#endregion

// Dying.
#region Health
if hp == 0 {
	visible = false	
}
#endregion