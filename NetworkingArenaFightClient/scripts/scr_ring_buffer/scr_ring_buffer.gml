
// 5 seconds of positions and inputs.
#macro max_buffer_size 300
#macro rb_ts_idx 0
#macro rb_input_idx 1
#macro rb_state_idx 2

// Returns an empty ring buffer
function ringbuffer_create() {
	var buffer = new RingBuffer()
	buffer.buffer = array_create(max_buffer_size, noone)
	return buffer
}

function ringbuffer_push(_buffer, _ts, _input, _pos) {
	var _end = _buffer.buffer_end
	_buffer.buffer[_end] = [_ts, _input, _pos]
	
	_buffer.buffer_end += 1
	if _buffer.buffer_end == max_buffer_size {
		_buffer.buffer_end = 0
	}
	
	// rotaaaate
	if _buffer.buffer_end <= _buffer.buffer_start {
		_buffer.buffer_start = _buffer.buffer_end + 1	
		if _buffer.buffer_start == max_buffer_size {
			_buffer.buffer_start = 0
		}
	}
}

/**
	find the first position from beg to end that is above the provided ts
**/
function ringbuffer_find(_buffer, _ts) {
	
	var _i = _buffer.buffer_start
	
	while true {
	
		if _buffer.buffer[_i] != noone and 	_buffer.buffer[_i][rb_ts_idx] >= _ts {
			return _i
		}
		
		_i += 1
		
		if _i == max_buffer_size {
			_i = 0
		}
		
		if _i == _buffer.buffer_end {
			break	
		}
	}
	
	return -1
}

function ringbuffer_findexact(_buffer, _ts) {
	
	var _i = _buffer.buffer_start
	
	while true {
	
		if _buffer.buffer[_i] != noone and 	_buffer.buffer[_i][rb_ts_idx] == _ts {
			return _i
		}
		
		_i += 1
		
		if _i == max_buffer_size {
			_i = 0
		}
		
		if _i == _buffer.buffer_end {
			break	
		}
	}
	
	return -1
}

function RingBuffer() constructor {
	buffer_start = 0
	buffer_end = 0
	buffer = []
	
	static ToString = function()
	{
		return "RingBuffer[Start="  + string(buffer_start) + ", End=" + string(buffer_end) + ", Buffer=" + string(buffer) + "]"
	}
}