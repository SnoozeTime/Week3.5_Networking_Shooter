/// @description Create the player

// Server ID for the player
player_id = -1
rb = ringbuffer_create()

IsLocal = function() {
	return player_id == obj_client.player_id
}

player_ts = 0
serverX = x
serverY = y

state[0] = 0 
state[1] = 0
state[2] = 0
state[3] = 0

// Only when not network master
first_ts = 0
current_interpolated_ts = 0

// This is to display the correct animation
prev_x = x

state_received = 0
debug_txt = ""

ApplyServerPos = function(_ts, _x, _y) {


	/*
		Quite important :D
	
		Whenever we receive an update from the server, reapply all inputs from this update to get the current 
		player position
	*/
	if is_network_master(player_id) {
		var _rb_idx = ringbuffer_find(rb, _ts)
		if _rb_idx >= 0 {
			var _idx = (_rb_idx + 1) % max_buffer_size
			if _idx != rb.buffer_end {
				x = _x
				y = _y
				while true {
					var _input = rb.buffer[_idx][rb_input_idx]
					x += vel*(_input[1] - _input[0])
					y += vel*(_input[3] - _input[2])
					rb.buffer[_idx][rb_state_idx] = [x, y]
				
					_idx = (_idx + 1) % max_buffer_size
					if _idx == rb.buffer_end {
						break	
					}
				}
			}
		}
	} else {
		
		/*
			Entity interpolation.
			Interpolate between previous received position and new received position so that movement is not choppy
			Keep a list of last known positions.
		*/
		ringbuffer_push(rb, _ts, [], [_x, _y])
		
		if state_received < 1 {
			state_received += 1	
			first_ts = _ts
		} else if state_received == 1 {
			current_interpolated_ts = first_ts
			state_received += 1
			log(string_interpolate("Received states at {} and {}. Will set ts to {}", [first_ts, _ts, first_ts]))
			log(rb.ToString())
		}
	}
}