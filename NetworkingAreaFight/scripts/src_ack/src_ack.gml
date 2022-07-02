
function ack_cleanup(_ack_map) {
	// packet is lost after 1 second without ack
	var _remaining_acks = ds_map_keys_to_array(_ack_map)
	for (var _i=0; _i < array_length(_remaining_acks); _i++) {
		var _ack_idx = _remaining_acks[_i]
		var _sent_at = ds_map_find_value(_ack_map, _ack_idx)

		if get_timer()/1000-_sent_at >= 1000 {
			ds_map_delete(_ack_map, _ack_idx)
		}
	}
}

function ack_check(_current_rtt, _ack_map, _latest_ack, _remote_acks) {
	
	if ds_map_exists(_ack_map, _latest_ack) {
		var _sent_at = ds_map_find_value(_ack_map, _latest_ack)
		ds_map_delete(_ack_map, _latest_ack)
		_current_rtt = ack_adjust_rtt(_current_rtt, get_timer()/1000 - _sent_at)
	}
	
	for (var _i=0; _i < array_length(_remote_acks); _i++) {
		var _ack_idx = _remote_acks[_i]
		if _ack_idx > 0 and ds_map_exists(_ack_map, _ack_idx) {
			var _sent_at = ds_map_find_value(_ack_map, _ack_idx)
			ds_map_delete(_ack_map, _ack_idx)
			_current_rtt = ack_adjust_rtt(_current_rtt, get_timer()/1000 - _sent_at)
		}	
	}
	
	return _current_rtt
}

// round trip time - lerp to lessen spikes/jitters
function ack_adjust_rtt(_current_rtt, packet_rtt) {
	return lerp(_current_rtt, packet_rtt, 0.1)	
}
	