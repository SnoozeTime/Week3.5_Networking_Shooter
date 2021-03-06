/// @description Create the server

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

// Serialized to u8
enum Hero {
	Firehead,
	InvisibleSam, // as in samurai !
}

server_time = 0
// Room speed is number of frames per second. /10 -> 100ms
// currently 30 fps. need to send 10 packets per second.
server_framerate = room_speed / 10

cleanup_framerate = 30
client_timeout = 100
port = 64198
max_clients = 12
current_connected = 0
// UDP or TCP, port and max clients
server_socket = network_create_server(network_socket_udp, port, max_clients)

if server_socket < 0 {
	log("Error creating server")
}

log("Created server on port 6510")
// 1 = alignement.
server_buffer = buffer_create(1024, buffer_fixed, 1)

// Initialize client data.
all_clients = array_create(max_clients, new Client("", 0))

alarm[0] = server_framerate
alarm[1] = cleanup_framerate
alarm[2] = room_speed

