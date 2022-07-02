// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function receive_message(_buffer){
	with obj_client {
		var msg_type = buffer_read(_buffer, buffer_u8)
		var _seq_nb = buffer_read(_buffer, buffer_u16)
		
		// Store seq numbers from the server to send it back.
		ackfield_push(ackfield, _seq_nb)
		
		if not net_seq_greater_than(_seq_nb, remote_seq_nb) {
			log("Received packet out of order. Discarding")
			return	
		}
		remote_seq_nb = _seq_nb
		
		switch msg_type {
			
			// When receive, the client is considered connected to the server
			#region Connect Ack
			case network.connect_ok:
				player_id = buffer_read(_buffer, buffer_u8)
				myState = ClientState.connected
				// Stop the connect timesource to stop connection attempts
				time_source_stop(connect_timesource)
				with obj_HUD {
					my_state = HudState.Playing	
				}
				log("Connected to server with player ID " + string(player_id))
				
				// Create the player.
				//var p = instance_create_layer(200, 200, "Instances", obj_player)
				//with p {
				//	player_id = other.player_id	
				//}
				
				// Start heartbeats to not lose the connection
				//time_source_start(heartbeat_timesource)
			break
			#endregion
			
			// X - Y at given client ts
			#region Update state for one player
			case network.state:
				// How many are connected?
				var _pid = buffer_read(_buffer, buffer_u8)
				var _ts = buffer_read(_buffer, buffer_u32)
				var _x = buffer_read(_buffer, buffer_u16)	
				var _y = buffer_read(_buffer, buffer_u16)
				var mouse_dir_x = buffer_read(_buffer, buffer_u16)
				var mouse_dir_y = buffer_read(_buffer, buffer_u16)
				
				if _pid >= 0 {
					var _found = false
						
					// Update x and y
					// TODO create map or array later
					with obj_par_player {
						if net_entity_id == _pid {
							ApplyServerPos(_ts, _x, _y, mouse_dir_x, mouse_dir_y)
							_found = true
						}
					}
						
					if not _found {
						var p = instance_create_layer(200, 200, "Instances", obj_firehead)
						with p {
							post_create(_pid, _x, _y)
						}
						if p.is_local() {
							with obj_camera {
								target = p
							}
						}
					}
					
				}
			
			
			break
			#endregion
			
			// Somebody shot
			#region Shoot event
			case network.shoot_event:
				var _ev = new ShootEvent()
				_ev.Unpack(_buffer)
				var _pid = _ev.pid
				with obj_par_player {
					if net_entity_id == _pid {
						ApplyAction(_ev.ts, _ev.dir[0], _ev.dir[1])
					}
				}
				
			break
			#endregion
			
			// Names and pings of players
			#region Player information 
			case network.players_info:
				var _info = new PlayerInfo()
				_info.Unpack(_buffer)
				
				var found = false

				for (var _i = 0; _i < array_length(players_information); _i++) {
					if players_information[_i][0] == _info.pid {
						players_information[_i][1] = _info.player_name
						players_information[_i][2] = _info.ping
						found = true
						break	
					}
				}
				
				if not found {
					array_push(players_information, [_info.pid, _info.player_name, _info.ping])
				}
				
				with obj_par_player {
					if _info.pid == net_entity_id {
						player_name = _info.player_name	
					}
					
				}
				
				log(string(players_information))
			break
			#endregion
		}	
	}
}