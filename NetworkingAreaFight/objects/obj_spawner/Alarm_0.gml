/// @description Spawn players 

for (var _i = 0; _i < array_length(player_to_spawn); _i++) {
	
	player_to_spawn[_i] = max(-1, player_to_spawn[_i]-1)
	if player_to_spawn[_i] == 0 {
		// Spawn the player.	
		with obj_server {
			var _c = all_clients[_i]
			if _c.IsValid() {
				_c.player_instance.respawn()
			}
		}
	}
	
}


alarm[0] = room_speed
