

function net_pack_message(_msg) {
	with obj_client {
		buffer_seek(send_buffer, buffer_seek_start, 0)
		buffer_write(send_buffer, buffer_u8,_msg.MessageId()) // message type
		buffer_write(send_buffer, buffer_u16, local_seq_nb) // seq number from server side.
		// acks.
		buffer_write(send_buffer, buffer_u16, remote_seq_nb)
		// ack bitfield
		buffer_write(send_buffer, buffer_u32, ackfield_tou32(ackfield, remote_seq_nb))
		
		_msg.Pack(send_buffer)
		local_seq_nb= (local_seq_nb+1) %  65535
	}
}



/**
	Send a connection request to the server. Server returns a random ID
*/
function connect_to_server(_name){
	var _msg = new Connect(_name)
	send_to_server(_msg)
}

function Connect(_player_name="") constructor 
{
	player_name = _player_name	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_string, player_name)
	}
	
	static Unpack = function(_buf) {
		player_name = buffer_read(_buf, buffer_string)
	}
	
	static MessageId = function() {
		return network.connect	
	}
}

/*
	Say hello
*/
function Heartbeat(_client_id) constructor
{
	client_id = _client_id
	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_u8, client_id)
	}
	
	static MessageId = function() {
		return network.heartbeat	
	}
	
	// Size if one u8
	static Size = function() {
		return 1	
	}
}

function send_heartbeat() {
	with obj_client {
		var _msg = new Heartbeat(player_id)
		send_to_server(_msg)
	}
}

function Input(_client_id, _ts, _input, _look_at) constructor
{
	client_id = _client_id
	ts = _ts
	input = _input
	look_at = _look_at
	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_u32, ts)
		buffer_write(_buf, buffer_u8, client_id)
		var _input_bits = 0
		for (var _i = 0; _i < array_length(input); _i++) {	
			_input_bits += input[_i] << _i
		}
		
		buffer_write(_buf, buffer_u8, _input_bits)
		// mouse
		buffer_write(_buf, buffer_u16, look_at[0])
		buffer_write(_buf, buffer_u16, look_at[1])
	}
	
	static MessageId = function() {
		return network.input	
	}
	
	// Size if one u8
	static Size = function() {
		return 6
	}
}

/*
	Input is current array of player input.
*/ 
function send_input(_ts, _input) {
	with obj_client {
		var _msg = new Input(player_id, _ts, _input, [mouse_x, mouse_y])
		send_to_server(_msg)
	}
}

function send_to_server(_msg) {
	with obj_client {
		net_pack_message(_msg)
		network_send_udp(client_socket, server_addr, port, send_buffer, buffer_tell(send_buffer))
	}
}


function ShootEvent(_shoot_id = 0, _pid = 0, _ts = 0, _dir = []) constructor 
{
	shoot_id = _shoot_id
	pid = _pid // who shot
	ts = _ts
	dir = _dir
	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_u8, shoot_id)
		buffer_write(_buf, buffer_u8, pid)
		buffer_write(_buf, buffer_u32, ts)
		buffer_write(_buf, buffer_f16, dir[0])
		buffer_write(_buf, buffer_f16, dir[1])
	}
	
	static Unpack = function(_buf) {
		shoot_id = buffer_read(_buf, buffer_u8)
		pid = buffer_read(_buf, buffer_u8)
		ts = buffer_read(_buf, buffer_u32)	
		var _x = buffer_read(_buf, buffer_f16)
		var _y = buffer_read(_buf, buffer_f16)
		dir = [_x, _y]
		log("Unpacked " + string(dir))
	}
	
	static MessageId = function() {
		return network.shoot_event	
	}
	
	static ToString = function() {
		return "Player" + string(pid) + "Shoot at dir=" + string(dir) + " and ts=" + string(ts)
	}
}



function PlayerInfo(_pid = 0, _player_name="", _ping = 0) constructor 
{
	pid = _pid
	player_name = _player_name
	ping =_ping
	
	static Pack = function(_buf) {
		// ID 
		buffer_write(_buf, buffer_u8, pid)
		// Name
		buffer_write(_buf, buffer_string, player_name)
		// ping
		buffer_write(_buf, buffer_u16, ping)
		
	}
	
	static Unpack = function(_buf) {
		pid = buffer_read(_buf, buffer_u8)
		player_name = buffer_read(_buf, buffer_string)
		ping = buffer_read(_buf, buffer_u16)
			
	}
	
	static MessageId = function() {
		return network.players_info	
	}
}