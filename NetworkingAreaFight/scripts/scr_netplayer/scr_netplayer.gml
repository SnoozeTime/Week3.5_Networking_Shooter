
function received_packet(_ip_addr, _port, _buffer){

	with obj_server {
		var msg_type = buffer_read(_buffer, buffer_u8)
		// remote seq number
		var _sq_nb = buffer_read(_buffer, buffer_u16)
		var _msg_client_id = net_find_player(_ip_addr, _port)
		var _ack = buffer_read(_buffer, buffer_u16)
		var _ack_bitfield = buffer_read(_buffer, buffer_u32)
		
		//159.223.52.17
		
		if _msg_client_id == 1 {
			log("Received packet from client 1=" + string(msg_type))	
		}
		

		// Validate packet (Checksum later, seq nb)
		if _msg_client_id >= 0 {
			if not net_seq_greater_than(_sq_nb, all_clients[_msg_client_id].remote_seq_nb) {
				log("ERROR - Packet out of order")
				return
			}
			all_clients[_msg_client_id].remote_seq_nb = _sq_nb
			
			// Ack
			with all_clients[_msg_client_id] {
				rtt = ack_check(rtt, acks, _ack, ackfield_fromu32(_ack, _ack_bitfield))
			}
		}

		switch msg_type {
			// Handle client connection. Will try to see if the client is already connected. If yes, just send
			// an ACK. If no, will try to find the first available slot in the server and use it. Then sends
			// ACK. 
			// Error: If cannot find an available slot, will send an error.
			#region Client Connect
			case network.connect:
		
				log(string_interpolate("Connection Attempt from {}:{}", [_ip_addr, _port]))
				if _msg_client_id < 0 {
					
					// Find first non valid client.
					for (var i = 0; i < max_clients; i++) {
						if not all_clients[i].IsValid() {
							_msg_client_id = i;
							break
						}
					}
					
					// If cannot find, it means the room is full
					if _msg_client_id < 0 {
						// ERROR, cannot add more clients
						return
					}
					
					var _connectInfo = new Connect()
					_connectInfo.Unpack(_buffer)
					// Then, if not connected, create a new client and connect it.
					var _newClient = new Client(_ip_addr, _port)
					_newClient.connected = true
					_newClient.client_id = _msg_client_id
					_newClient.pname = _connectInfo.player_name
					
					// Need to spawn the actual player
					var instance
					switch _connectInfo.hero_type {
						case Hero.Firehead:
							instance = instance_create_layer(200, 200, "Instances", obj_firehead)
						break
						
						case Hero.InvisibleSam:
							instance = instance_create_layer(200, 200, "Instances", obj_invisible_sam)
						break
					}
					instance.player_id = _msg_client_id
					_newClient.player_instance = instance
					
					log(string_interpolate("New Connection: PID={}, name={}", [_msg_client_id, _newClient.pname]))
				
					all_clients[_msg_client_id] = _newClient
				}
				
				// Then send the ack.
				send_connect_ok(_newClient)
			break
			#endregion
			
			// Just a small message to say "I'm alive"
			#region Hearbeat
			case network.heartbeat:
				var _heartbeat = new Heartbeat()
				_heartbeat.Unpack(_buffer)
			break
			
			#endregion
		
			// Receive input from the player
			#region Input from player
			case network.input:
			
				var _input_msg = new Input()
				_input_msg.Unpack(_buffer)
				
				if _msg_client_id == 1 {
					log("Input from client 1=" + _input_msg.ToString())	
				}
				
				if _input_msg.client_id != _msg_client_id {
					log("ERROR - Client tried to send input for wrong pid")	
				} else {
					var _c = all_clients[_msg_client_id]
					if _input_msg.ts >= _c.player_instance.last_client_time {
						_c.player_instance.add_input(_input_msg.ts, _input_msg.input)
						_c.player_instance.last_client_time = _input_msg.ts
						
					}
					
				}
			break
			#endregion
		}
		
		// Update last connected time.
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

function send_connect_ok(_client) {
	with obj_server {
		var _msg = new ConnectOk(_client.client_id)
		send_to(_client, _msg)
	}
}

function send_to(_client, _msg) {
	with obj_server {
		if _client.IsValid() {
			// Save the ack for later.
			ds_map_add(_client.acks, _client.local_seq_nb, get_timer()/1000)
			net_pack_message(server_buffer, _msg, _client)
			network_send_udp(server_socket, _client.addr, _client.port, server_buffer, buffer_tell(server_buffer))	
		}
	}
}


function send_all(_msg) {
	with obj_server {
		for (var _i=0; _i < max_clients; _i++) {
			var _c = all_clients[_i]
			send_to(_c, _msg)
		}
	}
}

function send_all_but(_msg, _pid) {
	with obj_server {
		for (var _i=0; _i < max_clients; _i++) {
			if _pid == _i {
				continue
			}
			var _c = all_clients[_i]
			send_to(_c, _msg)
		}
	}
}

function send_state(_player) {
	with obj_server {
		var _msg = new ClientState(_player)	
		send_all(_msg)
	}
	
}

function send_player_info() {
	with obj_server {
		for (var _i=0; _i < max_clients; _i++) {
			var _c = all_clients[_i]
			if _c.IsValid() {
				var _msg = new PlayerInfo(_i, _c.pname, _c.rtt)
				send_all(_msg)
			}
		}
	}
}

function send_shoot_event(_player, _shoot_at, _shot_dir) {
	with obj_server {
		var _msg = new ShootEvent(0, _player.player_id, _shoot_at, _shot_dir)
		send_all_but(_msg, _player.player_id)
	}
}

function Client(_addr, _port) constructor
{
    addr = _addr
	port = _port
	pname = ""
	connected = false
	last_server_time = 0
	client_id = -1
	player_instance = noone
	local_seq_nb = 1
	remote_seq_nb = 0
	
	rtt = 0
	acks = ds_map_create()

	static CleanUp = function() {
		ds_map_destroy(acks)
		if player_instance != noone {
			instance_destroy(player_instance)
			player_instance = noone
		}
	}

	static IsValid = function()
    {
        return connected
    }
	
	static ToString = function()
	{
		return "Client[ID="+string(client_id)+ "IP="  + addr + ":" + string(port) + ", IsConnected=" + string(connected) + ", LastServerTime=" + string(last_server_time) + "]"
	}
} 