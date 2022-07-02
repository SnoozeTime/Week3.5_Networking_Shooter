/// @description HUDHUHUHUHUHUHD

display_set_gui_size(320, 240);



if global.debug {
	draw_set_font(obj_gui_control.small_pixel_font)	
	draw_set_halign(fa_left)
	draw_set_alpha(1)
	draw_set_color(c_red)
	draw_text(10, 10, "Debug")
}


switch my_state {
	case HudState.Connecting:
		draw_set_font(obj_gui_control.large_pixel_font)
		draw_set_color(c_white)
		draw_set_halign(fa_center)
		draw_set_valign(fa_middle)
		
		var _text
		if obj_client.connect_countdown == 0 {
			_text = "Start!"
		} else {
			_text = string(obj_client.connect_countdown)
		}
		
		draw_text(160, 120, _text)
	break
	
	case HudState.Playing:
		/*
		Show player names and pings
		*/
		if keyboard_check(vk_tab) {
	
			draw_set_font(obj_gui_control.small_pixel_font)
			draw_set_alpha(0.2)
			draw_set_color(c_grey)
			draw_rectangle(0, 0, 320, 240, false)
			draw_set_alpha(1)
			draw_set_color(c_white)
			draw_set_halign(fa_center)
	
			with obj_client {
				for (var _i = 0; _i < array_length(players_information); _i++) {
					var _text = string_interpolate("{}    {}    {}", 	players_information[_i])
					draw_text(160, 10+_i*20, _text)
				}
			}
		}
	break
	
}
