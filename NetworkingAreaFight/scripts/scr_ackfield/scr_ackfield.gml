// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ackfield_create(){
	var queue = new Queue()
	queue.buffer = array_create(33)
	return queue
}

function ackfield_push(_queue, _element) {
	// O(n).. but only 33 elements anyway...
	for (var _i = _queue.current_end-1; _i >= 0; _i--) {
		if _i+1 != array_length(_queue.buffer) {
			_queue.buffer[_i+1] = _queue.buffer[_i]	
		}
	}
	
	_queue.buffer[0] = _element
	_queue.current_end = min(_queue.current_end+1, 33)
}

function ackfield_tou32(_queue, last_element) {
	var _bitfield = 0	
	for (var _i = 0; _i < _queue.current_end; _i++) {
		if last_element != _queue.buffer[_i] {
			if last_element - _queue.buffer[_i] - 1 < 33 {
				_bitfield = _bitfield | (1 << (last_element - _queue.buffer[_i] - 1))
			}
		}
	}
	return _bitfield & 4294967295
}

function ackfield_fromu32(_last_element, _bitfield) {
	
	// allocate for 32 acks
	var _acks = array_create(32)
	var _idx = 0
	for (var _i = 0; _i < 32; _i++) {
		// if bit is set, this is a ack
		if (_bitfield & (1 << _i)) != 0 {
			_acks[_idx] = _last_element - _i - 1
			_idx += 1
		}
	}
	
	return _acks
}


function Queue() constructor {
	current_end = 0
	buffer = []	
}