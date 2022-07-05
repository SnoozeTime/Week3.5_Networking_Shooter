/// @description Insert description here
// You can write your code in this editor
global.server_ip = "127.0.0.1"
global.server_port = 64198
global.player_name = ""
global.debug = false
global.logfile_name = ""
global.hero_type = Hero.InvisibleSam

init_player = function(client_name) {
	global.logfile_name ="game-log" + string(client_name)+".txt"
}

// Serialized to u8
enum Hero {
	Firehead,
	InvisibleSam, // as in samurai !
}