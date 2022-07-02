/// @description Cleanup clients lost packets and send player info

for (var _i = 0; _i < array_length(all_clients); _i++) {
	var _c = all_clients[_i]
	if _c.IsValid() {
		ack_cleanup(_c.acks)	
	}
}


send_player_info()

alarm[2] = room_speed