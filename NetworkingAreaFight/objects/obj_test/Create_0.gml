/// @description Insert description here
// You can write your code in this editor
ackfield = ackfield_create()

for (var _i = 1; _i <= 34; _i++) {
	ackfield_push(ackfield, _i)	
}

bits = ackfield_tou32(ackfield, 34)
log(string(bits))
log(format_to_bitfield(bits))
log(string(ackfield_fromu32(34, bits)))