/// @description Insert description here
// You can write your code in this editor
if label != "" {
	with obj_gui_control {
		draw_set_font(small_pixel_font)
		draw_set_valign(fa_middle)
		draw_set_color(other.label_color)
		draw_text(other.x, other.y, other.label)
	}
}