

function net_pack_message(_buf, _msg, _client) {
	buffer_seek(_buf, buffer_seek_start, 0)
	buffer_write(_buf, buffer_u8,_msg.MessageId()) // message type
	buffer_write(_buf, buffer_u16, _client.local_seq_nb) // seq number from server side.
	_msg.Pack(_buf)
	_client.local_seq_nb = (_client.local_seq_nb+1) %  65535
}

/*
	Just acknowledge that client is connected to server.
*/
function ConnectOk(_client_id) constructor
{
	client_id = _client_id
	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_u8, client_id)
	}
	
	static MessageId = function() {
		return network.connect_ok	
	}
	
	// Size if one u8
	static Size = function() {
		return 1	
	}
}

/**
	Client state.
**/
function ClientState(_player) constructor {
	
	client_id = _player.player_id // u8
	ts = _player.last_client_time // u32
	pos_x = _player.x // u16
	pos_y = _player.y// u16
	
	static MessageId = function() {
		return network.state	
	}
	
	static Size = function() {
		return 9	
	}
	
	static Pack = function(_buf) {
		buffer_write(_buf, buffer_u8, client_id)
		buffer_write(_buf, buffer_u32, ts)
		buffer_write(_buf, buffer_u16,  pos_x)
		buffer_write(_buf, buffer_u16,  pos_y)
	}
}


function Heartbeat(_client_id = 0) constructor
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
	
	static Unpack = function(_buf) {
		client_id = buffer_read(_buf, buffer_u8)	
	}
}

function Input(_client_id=0, _ts=0, _input=noone) constructor
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
	
	static Unpack = function(_buf) {
		ts = buffer_read(_buf, buffer_u32)
		client_id = buffer_read(_buf, buffer_u8)	
		// Only apply the input if the time from the message is > from the last client time
		var _input_bits = buffer_read(_buf, buffer_u8)
		var _left = (_input_bits & 1) != 0
		var _right = (_input_bits & (1 << 1)) != 0
		var _top = (_input_bits & (1 << 2)) != 0
		var _bottom =  (_input_bits & (1 << 3)) != 0
		input = [_left, _right, _top, _bottom]
	}
	
	static MessageId = function() {
		return network.input	
	}
	
	// Size if one u8
	static Size = function() {
		return 6
	}
}