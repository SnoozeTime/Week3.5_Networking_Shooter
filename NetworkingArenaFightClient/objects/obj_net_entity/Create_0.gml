/// @description Insert description here
// You can write your code in this editor

net_entity_id = -1

// Only when not network master
first_ts = 0
current_interpolated_ts = 0
state_received = 0
look_at = [1, 0]

is_local = function() {
	return net_entity_id == obj_client.player_id
}


post_create = function(_net_entity_id, _x, _y) {
	log("Create with " + string(_net_entity_id))
	net_entity_id = _net_entity_id
	rb = ringbuffer_create()
	action_rb = ringbuffer_create()
	x = _x
	y = _y
}


ApplyServerPos = function(_ts, _x, _y, _mouse_x, _mouse_y) {

	/*
		Quite important :D
	
		Whenever we receive an update from the server, reapply all inputs from this update to get the current 
		player position
	*/
	if is_local() {
		log("Local applyserverpos")
		var _rb_idx = ringbuffer_find(rb, _ts)
		if _rb_idx >= 0 {
			var _idx = (_rb_idx + 1) % max_buffer_size
			if _idx != rb.buffer_end {
				x = _x
				y = _y
				while true {
					var _input = rb.buffer[_idx][rb_input_idx]
					
					// Need to set that in the children class
					apply_simulation(_input)
					
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
		ringbuffer_push(rb, _ts, [], [_x, _y, _mouse_x, _mouse_y])
		
		if state_received < 1 {
			state_received += 1	
			first_ts = _ts
		} else if state_received == 1 {
			current_interpolated_ts = first_ts
			state_received += 1
		}
	}
}

ApplyAction = function(_ts, _x, _y) {
	ringbuffer_push(action_rb, _ts, [], [_x, _y])
}


// CALLBACKS
after_local_movement = function() {}
after_remote_movement = function() {}
primary_action = function() {}