/// @description Manage timeout and disconnections


for (var _i=0; _i < max_clients; _i++) {
	var _c = all_clients[_i]	
	if _c.IsValid() {
		if abs(_c.last_server_time-server_time) > client_timeout {
			log("TIMEOUT:"+_c.ToString())
			log(string(_c.last_server_time)+ "-" + string(server_time) + " > " + string(client_timeout))
			_c.connected = false
			
			if _c.player_instance != noone {
				instance_destroy(_c.player_instance)
				_c.player_instance = noone
			}
			all_clients[_i] = _c
			current_connected -= 1
		}
	}
}

alarm[1] = cleanup_framerate