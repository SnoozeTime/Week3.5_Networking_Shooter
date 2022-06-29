/// @description

enum network {
	// Connect from client to server
	connect,
	// Connect OK from server
	connect_ok,
	// connect not ok from server,
	connect_nok,
	// Sent by player to disconnect from server
	disconnect,
	// Sent now and then by client to say alive.
	heartbeat,
	// State: Big ass message with all the players position.
	state,
	// Input: From player to server
	input,
}


client_time = 0

enum ClientState {
	not_connected,
	connecting,
	connected,
	lost_connection,
}
myState = ClientState.not_connected
player_id = -2

port = 64198
server_addr = "127.0.0.1"
client_socket = network_create_socket(network_socket_udp)
send_buffer = buffer_create(1024, buffer_fixed, 1)

local_seq_nb = 0
remote_seq_nb = -1

// Handling the connection
var _connect_to_server = function() {
	connect_to_server()	
}
connect_timesource = time_source_create(time_source_game, 1, time_source_units_seconds, _connect_to_server, [], -1, time_source_expire_after)

// I am alive.
var _send_heartbeat = function() {
	send_heartbeat()
}
heartbeat_period = 0.5
heartbeat_timesource = time_source_create(time_source_game, heartbeat_period, time_source_units_seconds, _send_heartbeat, [], -1, time_source_expire_after)