/// @description Insert description here
// You can write your code in this editor


draw_sprite_stretched(spr_textbox_outside, 0, x-window_scale, y, window_scale, box_height)
draw_sprite_stretched(spr_textbox_inside, 0, x, y, box_width, box_height)
draw_sprite_stretched(spr_textbox_outside, 0, x+box_width, y, window_scale, box_height)

with obj_gui_control {
	draw_set_font(small_pixel_font)
	draw_set_valign(fa_middle)
	draw_set_color(c_black)
	var _text = other.text
	if other.has_focus {
		_text += other.cursor	
	}
	draw_text(other.x+5, other.y+other.box_height/2, _text)
}

if label != "" {
	with obj_gui_control {
		draw_set_font(small_pixel_font)
		draw_set_valign(fa_middle)
		draw_set_color(c_black)
		draw_text(other.x, other.y-other.box_height/2+10, other.label)
	}
}