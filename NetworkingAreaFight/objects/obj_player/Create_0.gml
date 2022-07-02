/// @description 

player_id = -1

all_inputs = ds_list_create()

last_client_time = 0
input = [0,0,0,0]
mouse_dir = [1, 0]
is_mouse_clicked = false
is_mouse_released = false
prev_mouse_state = 0

add_input = function(_ts, _input) {
	last_client_time = _ts
	ds_list_add(all_inputs, [_ts, _input])	
}

reset_input = function() {
	ds_list_clear(all_inputs)
}


player_step = function() {
	
	var _has_shot = false
	var _shoot_at = 0
	var _shot_dir = [1, 0]
	
	if !ds_list_empty(all_inputs) {
		// Apply inputs from the player
		for (var _i = 0; _i < ds_list_size(all_inputs); _i++) {
			var _fromClient = ds_list_find_value(all_inputs, _i)
		    _input = _fromClient[1]	
			x += vel*(_input[1] - _input[0])
			y += vel*(_input[3] - _input[2])
			mouse_dir = [_input[5], _input[6]]
			
			// Check whether we need to shoot.
			if prev_mouse_state != _input[4] {
				is_mouse_clicked = _input[4] == 1		
				is_mouse_released = _input[4] == 0		
			} else {
				is_mouse_clicked = false	
				is_mouse_released = false	
			}
	
			prev_mouse_state = _input[4]
			
			if player_id == 1 {
				log(string_interpolate("Apply input at  {} (last ts ={})", [_fromClient[0], last_client_time]))
			}
			
			// Cannot shoot too fast.
			if is_mouse_clicked and not _has_shot {
				var _x = mouse_dir[0] - x
				var _y = mouse_dir[1] - (y-8)
				var b = instance_create_depth(x, y, layer, obj_par_projectile, { dir_x: _x, dir_y: _y } )
				b.my_parent = self
				_shot_dir = b.dir
				_shoot_at = _fromClient[0]	
				// at what time?
				_has_shot = true
			}
			
			
			// bullet collision
			
			// Check if collision with projectile.
			with obj_par_projectile {
				if place_meeting(x, y, other) and my_parent != other  {
					instance_destroy()	
				}
			}
		}
		
		
	}

	reset_input()

	// Send position to client
	if player_id == 1 {
		log(string_interpolate("Will send state at {}", [last_client_time]))
	}
	
	send_state(self)
	
	if _has_shot {
		send_shoot_event(self, _shoot_at, _shot_dir)	
	}
}