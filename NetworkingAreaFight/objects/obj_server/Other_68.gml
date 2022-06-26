/// @description

var type_event = ds_map_find_value(async_load, "type")

// this will identify the client.
var remote_port = async_load[? "port"]
var remote_ip = string(async_load[? "ip"])

switch type_event {
	
	case network_type_data:
		var buffer = async_load[? "buffer"]
		buffer_seek(buffer, buffer_seek_start, 0)
		received_packet(remote_ip, remote_port, buffer)
		break
}