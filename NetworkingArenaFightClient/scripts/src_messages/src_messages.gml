

function net_pack_message(_msg) {
	with obj_client {
		buffer_seek(send_buffer, buffer_seek_start, 0)
		buffer_write(send_buffer, buffer_u8,_msg.MessageId()) // message type
		buffer_write(send_buffer, buffer_u16, local_seq_nb) // seq number from server side.
		_msg.Pack(send_buffer)
		local_seq_nb= (local_seq_nb+1) %  65535
	}
}

/**
	Send a connection request to the server. Server returns a random ID
*/
function connect_to_server(){
	var _msg = new Connect()
	send_to_server(_msg)
}

function Connect() constructor
{
	
	static Pack = function(_buf) {
		//buffer_write(_buf, buffer_u8, client_id)
	}
	
	static MessageId = function() {
		return network.connect	
	}
	
	// Size if one u8
	static Size = function() {
		return 0	
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

function Input(_client_id, _ts, _input) constructor
{
	client_id = _client_id
	ts = _ts
	input = _input
	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_u32, ts)
		buffer_write(_buf, buffer_u8, client_id)
		var _input_bits = 0
		for (var _i = 0; _i < array_length(input); _i++) {	
			_input_bits += input[_i] << _i
		}
		
		buffer_write(_buf, buffer_u8, _input_bits)
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
		var _msg = new Input(player_id, _ts, _input)
		send_to_server(_msg)
	}
}

function send_to_server(_msg) {
	with obj_client {
		net_pack_message(_msg)
		network_send_udp(client_socket, server_addr, port, send_buffer, buffer_tell(send_buffer))
	}
}