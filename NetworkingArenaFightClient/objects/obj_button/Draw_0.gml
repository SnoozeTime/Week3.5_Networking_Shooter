/// @description Draw text
draw_self()

with obj_gui_control {
	draw_set_font(small_pixel_font)
	draw_set_valign(fa_middle)
	draw_set_color(c_white)
	draw_text(other.x, other.y+2*other.image_index, other.text)
}