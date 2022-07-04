/// @description Initialize array of player to spawn.

player_to_spawn = array_create(obj_server.max_clients, -1)

add_player_to_spawn = function(_pid, _tts) {
	if _pid >= 0 and _pid < array_length(player_to_spawn) {
		player_to_spawn[_pid] = _tts	
	}
}

alarm[0] = room_speed