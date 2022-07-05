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
	// I shoot
	player_shoot,
	// other player shoot
	shoot_event,
	// Info about players (name, ping...)
	players_info,
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

port = global.server_port //64198
server_addr = global.server_ip //"127.0.0.1"
client_socket = network_create_socket(network_socket_udp)
send_buffer = buffer_create(1024, buffer_fixed, 1)

local_seq_nb = 0
remote_seq_nb = -1
ackfield = ackfield_create()

#region Connection
connect_countdown = 3
var _countdown_to_connect = function() {
	connect_countdown -= 1
	if connect_countdown == 0 {
		time_source_start(connect_timesource)
	}
}
before_connect_ts = time_source_create(time_source_game, 1, time_source_units_seconds, _countdown_to_connect, [], 3, time_source_expire_after)
time_source_start(before_connect_ts)


// Handling the connection
var _connect_to_server = function() {
	connect_to_server(global.player_name, global.hero_type)	
}
connect_timesource = time_source_create(time_source_game, 1, time_source_units_seconds, _connect_to_server, [], -1, time_source_expire_after)

#endregion

// Names and pings
players_information = []
