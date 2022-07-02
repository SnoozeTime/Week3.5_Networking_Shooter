// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function scr_connect_control(){
	
	var _name = ""
	var _ip = ""
	var _port = ""
	
	with obj_textbox {
		switch gui_id {
			case "name":
				_name = text
			break
			case "ipaddr":
				_ip = text
			break
			case "port":
				_port = text
			break
		}
	}
	
	if _name == "" or _ip == "" or _port == "" {
			
		
	}
	
	log(string_interpolate("User {} will attempt to connect to {}:{}", [_name, _ip, _port]))
}