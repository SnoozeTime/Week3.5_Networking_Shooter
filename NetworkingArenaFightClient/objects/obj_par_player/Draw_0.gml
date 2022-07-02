/// @description Insert description here
// You can write your code in this editor
draw_self()

with obj_gui_control {
	draw_set_color(c_white)
	draw_set_font(smaller_pixel_font)
	draw_set_halign(fa_center)
	draw_text(other.x, other.y-25, other.debug_txt + " " + other.player_name)
}