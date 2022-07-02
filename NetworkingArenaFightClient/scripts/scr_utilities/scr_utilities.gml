
function log(_msg){
	show_debug_message(string(current_time) + ": " + _msg)
}

// Interpolate string.
// For example:
// "{} is a {}", ["Benoit", "Dude"] should return "Benoit is a Dude"
function string_interpolate(_format, _args) {
	
	var _res = _format
	for (var _i = 0; _i < array_length(_args); _i++) {
		_res = string_replace(_res, "{}", string(_args[_i]))
	}
	
	return _res
}

function debug(_msg) {
	if global.debug {
		log(_msg)
	}
}

function debug_file(_msg) {
	if global.debug and global.logfile_name != ""{
		var file;
		file = file_text_open_append(global.logfile_name);
		file_text_write_string(file, _msg);
		file_text_writeln(file)
		file_text_close(file);
	}
}