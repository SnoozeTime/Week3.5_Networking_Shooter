/// @description Insert description here
// You can write your code in this editor

type_event = ds_map_find_value(async_load, "type")

switch type_event {
	case network_type_data:
		buffer = async_load[? "buffer"]
		buffer_seek(buffer, buffer_seek_start, 0)
		receive_message(buffer)
	break	
}
