/// @description Insert description here
// You can write your code in this editor

if has_focus {
	if string_width(keyboard_string) < box_width {
		if is_number {
			text = string_digits(keyboard_string)
		} else {
			text = keyboard_string
		}
	} else {
		keyboard_string = text
	}
}

// Check if mouse inside bounds.
if mouse_check_button(mb_left) {
			
	has_focus = false
		
	if mouse_x > x and mouse_x < x+box_width {
		if mouse_y > y and mouse_y < y+box_height {
			has_focus = true
			onFocus()
		}
	}
}