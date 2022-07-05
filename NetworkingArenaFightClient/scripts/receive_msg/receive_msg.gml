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

			break
			#endregion
			
			// X - Y at given client ts
			#region Update state for one player
			case network.state:
				var _state = new ClientState()
				_state.Unpack(_buffer)
				
				if _state.client_id >= 0 {
					var _found = false
						
					// Update x and y
					// TODO create map or array later
					with obj_par_player {
						if net_entity_id == _state.client_id {
							ApplyServerPos(_state.ts, _state.pos_x, _state.pos_y, _state.mouse_dir[0], _state.mouse_dir[1])
							_found = true
							update_health(_state.hp)
						}
						
					}
						
					if not _found {
						
						var p
						switch _state.hero_type {
							case Hero.Firehead:
								p = instance_create_layer(200, 200, "Instances", obj_firehead)
							break
							case Hero.InvisibleSam:
								p = instance_create_layer(200, 200, "Instances", obj_invisible_hero)
							break
						}
						
						with p {
							post_create(_state.client_id, _state.pos_x, _state.pos_y)
							hp = _state.hp
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