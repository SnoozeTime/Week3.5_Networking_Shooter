

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
	mouse_dir = _player.mouse_dir
	
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
		buffer_write(_buf, buffer_u16, mouse_dir[0])
		buffer_write(_buf, buffer_u16, mouse_dir[1])
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

function Input(_client_id=0, _ts=0, _input=noone, _look_at = noone) constructor
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
	
	static Unpack = function(_buf) {
		ts = buffer_read(_buf, buffer_u32)
		client_id = buffer_read(_buf, buffer_u8)	
		// Only apply the input if the time from the message is > from the last client time
		var _input_bits = buffer_read(_buf, buffer_u8)
		var _left = (_input_bits & 1) != 0
		var _right = (_input_bits & (1 << 1)) != 0
		var _top = (_input_bits & (1 << 2)) != 0
		var _bottom =  (_input_bits & (1 << 3)) != 0
		var _mouse_left =  (_input_bits & (1 << 4)) != 0
		var _mouse_x = buffer_read(_buf, buffer_u16)
		var _mouse_y = buffer_read(_buf, buffer_u16)
		input = [_left, _right, _top, _bottom, _mouse_left, _mouse_x, _mouse_y]
	}
	
	static MessageId = function() {
		return network.input	
	}
	
	// Size if one u8
	static Size = function() {
		return 6
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
		dir[0] = buffer_read(_buf, buffer_f16)
		dir[1] = buffer_read(_buf, buffer_f16)
	}
	
	static MessageId = function() {
		return network.shoot_event	
	}
	
	static ToString = function() {
		return string_interpolate("Player{} shoot at {} with direction {}", [pid, ts, dir])	
	}
	
}
