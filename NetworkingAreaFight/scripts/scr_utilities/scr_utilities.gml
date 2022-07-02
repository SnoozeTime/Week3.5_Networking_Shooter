
function log(_msg){
	show_debug_message(_msg)
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

// only 16bits
function format_to_bitfield(_number) {
	
	var _str = ""
	for (var _i = 0; _i < 16; _i++) {
		if (_number & (1 << _i)) != 0 {
			_str = "1" + _str
		} else {
			_str = "0"	 + _str
		}
	}
	
	// Remove 0 at the beginning.
	// -------------------------
	var _1_index = string_pos("1", _str)
	if _1_index > 0 {
		return "0b" + string_copy(_str, _1_index, string_length(_str))
	} else {
		return "0b0"
	}
	
}