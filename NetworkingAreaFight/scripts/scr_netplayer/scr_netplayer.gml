
function received_packet(_ip_addr, _port, _buffer){

	with obj_server {
		var msg_type = buffer_read(_buffer, buffer_u8)
		switch msg_type {
			// Handle client connection. Will try to see if the client is already connected. If yes, just send
			// an ACK. If no, will try to find the first available slot in the server and use it. Then sends
			// ACK. 
			// Error: If cannot find an available slot, will send an error.
			#region Client Connect
			case network.connect:
		
				var _key = string(_ip_addr) + ":" + string(_port)
				log("Connection Attempt from " + _key)
				
				var _client_idx = -1
				var _already_connected = false
				for (var i = 0; i < max_clients; i++) {
					log("Iteration")
					if all_clients[i].addr == _ip_addr and all_clients[i].port == _port {
						log("Already connected")
						_already_connected = true
						_client_idx = i
						break
					} else {
						if not all_clients[i].IsValid() {
							
							log("Will try to use " + string(i))
							if _client_idx < 0 {
								_client_idx = i	
							}
						} else {
							log(all_clients[i].addr+":"+string(all_clients[i].port)+ " -> " + string(all_clients[i].connected))
						}
					}
				}
				
				// Then, if not connected, create a new client and connect it.
				var _newClient = new Client(_ip_addr, _port)
				_newClient.connected = true
				_newClient.client_id = _client_idx
				if not _already_connected and _client_idx < 0 {
					// ERROR, cannot add more clients
					return
				}
				
				if not _already_connected {
					// Need to spawn the actual player
					var instance = instance_create_layer(200, 200, "Instances", obj_player)
					instance.player_id = _client_idx
					_newClient.player_instance = instance
					
				}
				
				all_clients[_client_idx] = _newClient
				
				// Then send the ack.
				current_connected += 1
				send_connect_ok(_ip_addr, _port, _client_idx)
			break
			#endregion
			
			// Just a small message to say "I'm alive"
			#region Hearbeat
			case network.heartbeat:
				var _client_id = buffer_read(_buffer, buffer_u8)
				if _client_id >= 0 and _client_id < max_clients {
					log("Valid heartbeat from " + string(_client_id))	
				}
			break
			
			#endregion
		
			// Receive input from the player
			#region Input from player
			case network.input:
				
				var _ts = buffer_read(_buffer, buffer_u32)
				var _client_id = buffer_read(_buffer, buffer_u8)
				if _client_id >= 0 and _client_id < max_clients {
					var _c = all_clients[_client_id]
					if _c.addr != _ip_addr or _c.port != _port {
						log("ERROR - Client tried to send input for wrong pid")	
					} else {
						// parsing left/right/...
						
						// Only apply the input if the time from the message is > from the last client time
						var _input_bits = buffer_read(_buffer, buffer_u8)
						var _left = (_input_bits & 1) != 0
						var _right = (_input_bits & (1 << 1)) != 0
						var _top = (_input_bits & (1 << 2)) != 0
						var _bottom =  (_input_bits & (1 << 3)) != 0
						if _ts >= _c.player_instance.last_client_time {
							_c.player_instance.add_input(_ts, [_left, _right, _top, _bottom])
							_c.player_instance.last_client_time = _ts
							log("Input for client [" + string(_ts) + " = " + string([_left, _right, _top, _bottom]))
						}
						
					}
				}
			break
			#endregion
		}
		
		// Update last connected time.
		var _msg_client_id = net_find_player(_ip_addr, _port) 
		if _msg_client_id >= 0 {
			var _client = all_clients[_msg_client_id]
			if _client.IsValid() {
				_client.last_server_time = server_time	
			}
			all_clients[_msg_client_id] = _client
		}
	}
	
}


function net_find_player(_addr, _port) {
	with obj_server {
		
		for (var _i=0; _i < max_clients; _i++) {
			var _c = all_clients[_i]
			if _c.addr == _addr and _c.port == _port and _c.connected {
				return _i	
			}
		}
		
	}
		return -1
}

function send_connect_ok(_addr, _port, _client_idx) {
	with obj_server {
		buffer_seek(server_buffer, buffer_seek_start, 0)
		buffer_write(server_buffer, buffer_u8, network.connect_ok) // message type
		buffer_write(server_buffer, buffer_u8, _client_idx) // ID of player
		network_send_udp(server_socket, _addr, _port, server_buffer, buffer_tell(server_buffer))	
	}
}

// Assuming the buffer is already populated.
function send_all() {
	with obj_server {
		for (var _i=0; _i < max_clients; _i++) {
			var _c = all_clients[_i]
			if _c.IsValid() {
				network_send_udp(server_socket, _c.addr, _c.port, server_buffer, buffer_tell(server_buffer))	
			}
		}
	}
}



function send_state(_pid, _ts, _x, _y) {	
	with obj_server {
		
		buffer_write(server_buffer, buffer_u8, current_connected)
		var _c = all_clients[_pid]
		if _c.IsValid() {
			if _c.player_instance != noone and _c.player_instance != undefined {
				buffer_seek(server_buffer, buffer_seek_start, 0)
				buffer_write(server_buffer, buffer_u8, network.state)
				buffer_write(server_buffer, buffer_u8, _pid)
				buffer_write(server_buffer, buffer_u32, _ts)
				buffer_write(server_buffer, buffer_u16,  _x)
				buffer_write(server_buffer, buffer_u16,  _y)
				send_all()
			}
		}
	}
	
}

function Client(_addr, _port) constructor
{
    addr = _addr
	port = _port
	connected = false
	last_server_time = 0
	client_id = -1
	player_instance = noone
	
	static IsValid = function()
    {
        return connected
    }
	
	static ToString = function()
	{
		return "Client[ID="+string(client_id)+ "IP="  + addr + ":" + string(port) + ", IsConnected=" + string(connected) + ", LastServerTime=" + string(last_server_time) + "]"
	}
} 