/// @description Entity Interpolation

if not is_local() {
	
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

				x = lerp( _initialState[0], _final_state[0], l)
				y = lerp( _initialState[1], _final_state[1], l)
				// not perfect, would be better to interpolate angle...
				look_at[0] = lerp( _initialState[2], _final_state[2], l)
				look_at[1] = lerp( _initialState[3], _final_state[3], l)
				
			}
		} else {
			debug(string_interpolate("_rb_idx {} == buffer_end {}", [_rb_idx, rb]))	
		}
		
	} else {
		debug(string_interpolate("Cannot find state: {} and {}", [current_interpolated_ts, rb]))
	}
	
	// Let's see if can find action.
	var _action_idx = ringbuffer_findexact(action_rb, current_interpolated_ts)
	if _action_idx >= 0 {
		var _shoot_dir = action_rb.buffer[_action_idx][rb_state_idx]
		primary_action(_shoot_dir[0], _shoot_dir[1])
	}
	
	if state_received == 2 {
		
		current_interpolated_ts += 1// min(last_remote_ts ,current_interpolated_ts + 1)
		debug("new interpolated TS = " + string(current_interpolated_ts))
	}
	
	after_remote_movement()
}