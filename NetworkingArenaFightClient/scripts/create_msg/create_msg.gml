
/**
	Send a connection request to the server. Server returns a random ID
*/
function connect_to_server(_socket, _server_ip, _server_port, _buffer){
	buffer_seek(_buffer, buffer_seek_start, 0)
	buffer_write(_buffer, buffer_u8, network.connect) // message type
	network_send_udp(_socket, _server_ip, _server_port, _buffer, buffer_tell(_buffer))
}

function send_heartbeat() {
	with obj_client {
		buffer_seek(send_buffer, buffer_seek_start, 0)
		buffer_write(send_buffer, buffer_u8, network.heartbeat)
		buffer_write(send_buffer, buffer_u8, player_id)
		network_send_udp(client_socket, server_addr, port, send_buffer, buffer_tell(send_buffer))
		send_to_server()
	}
}

/*
	Input is current array of player input.
*/ 
function send_input(_ts, _input) {
	with obj_client {
		buffer_seek(send_buffer, buffer_seek_start, 0)
		buffer_write(send_buffer, buffer_u8, network.input)
		buffer_write(send_buffer, buffer_u32, _ts)
		buffer_write(send_buffer, buffer_u8, player_id)
		
		//https://manual.yoyogames.com/Additional_Information/Bitwise_Operators.htm
		// Just one u8 to store all input.
		var _input_bits = 0
		for (var _i = 0; _i < array_length(_input); _i++) {	
			_input_bits += _input[_i] << _i
		}
		
		buffer_write(send_buffer, buffer_u8, _input_bits)
		send_to_server()
	}
}

function send_to_server() {
	with obj_client {
		network_send_udp(client_socket, server_addr, port, send_buffer, buffer_tell(send_buffer))
	}
}