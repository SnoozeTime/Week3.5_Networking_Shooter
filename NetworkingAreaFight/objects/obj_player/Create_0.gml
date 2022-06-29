/// @description 

player_id = -1

all_inputs = ds_list_create()

last_client_time = 0
input = [0,0,0,0]

add_input = function(_ts, _input) {
	last_client_time = _ts
	ds_list_add(all_inputs, [_ts, _input])	
}

reset_input = function() {
	ds_list_clear(all_inputs)
}


player_step = function() {
	if !ds_list_empty(all_inputs) {
		for (var _i = 0; _i < ds_list_size(all_inputs); _i++) {
			var _fromClient = ds_list_find_value(all_inputs, _i)
		    _input = _fromClient[1]	
			x += vel*(_input[1] - _input[0])
			y += vel*(_input[3] - _input[2])
		}
	}

	reset_input()

	// Send position to client
	send_state(self)
}