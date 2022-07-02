/// @description Initialize

text = ""
box_width = 30*window_scale
box_height = 5*window_scale
cursor = "|"
delay = 20
alarm[0] = delay

has_focus = false

onFocus = function() {
	keyboard_string = text	
	has_focus = true
}