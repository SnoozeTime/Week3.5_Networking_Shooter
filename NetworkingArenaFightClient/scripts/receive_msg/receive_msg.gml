// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function receive_message(_buffer){
	with obj_client {
		var msg_type = buffer_read(_buffer, buffer_u8)
		var _seq_nb = buffer_read(_buffer, buffer_u16)
		
		if not net_seq_greater_than(_seq_nb, remote_seq_nb) {
			log("Received packet out of order. Discarding")
			return	
		}
		remote_seq_nb = _seq_nb
		
		switch msg_type {
			
			#region Connect Ack
			case network.connect_ok:
				player_id = buffer_read(_buffer, buffer_u8)
				myState = ClientState.connected
				// Stop the connect timesource to stop connection attempts
				time_source_stop(connect_timesource)
				log("Connected to server with player ID " + string(player_id))
				
				// Create the player.
				//var p = instance_create_layer(200, 200, "Instances", obj_player)
				//with p {
				//	player_id = other.player_id	
				//}
				
				// Start heartbeats to not lose the connection
				time_source_start(heartbeat_timesource)
			break
			#endregion
			
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
		}
	}
}