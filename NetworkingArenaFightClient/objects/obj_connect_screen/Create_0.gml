/// @description Insert description here
// You can write your code in this editor
view_width = 320
view_height = 240

textbox_width = 160
textbox_height = 30
y_separation = 25
left = (view_width - textbox_width) / 2
top = 30


box_data = [["Name:", "name", ""], ["Server IP:", "ip", "127.0.0.1"], ["Port:", "port", "64198"]]

boxes = array_create(array_length(box_data))
for (var _i=0; _i < array_length(box_data); _i++) {
	boxes[_i] = instance_create_layer(
		left, 
		top+_i*(y_separation+textbox_height), 
		layer, obj_textbox, { label: box_data[_i][0], gui_id:  box_data[_i][1] })
	with boxes[_i] {
		box_height = other.textbox_height
		box_width = other.textbox_width
		text = other.box_data[_i][2]
		
		// last box is port, this is a number
		if _i == 2 {
			is_number = true	
		}
	}
}

// Then add the button


connect_to_server = function() {
	if boxes[0].text == "" {
		error_label.label = "Missing name"
		alarm[0] = room_speed*2
	} else if boxes[1].text == "" {
		error_label.label = "Missing server IP"	
		alarm[0] = room_speed*2
	} else if boxes[2].text == "" {
		error_label.label = "Missing server port"	
		alarm[0] = room_speed*2
	} else {
		// can connect
		global.server_ip = boxes[1].text
		global.server_port = real(boxes[2].text)
		global.player_name = boxes[0].text
		room_goto_next()
	}	
}


connect_firehead = function() {
	global.hero_type = Hero.Firehead
	self.connect_to_server()	
}

connect_invisiblesam = function() {
	global.hero_type = Hero.InvisibleSam
	self.connect_to_server()	
}


connect_button = instance_create_layer(left+10, top+array_length(box_data) * (y_separation+textbox_height), layer, obj_button)
with connect_button {
	text = "Firehead"
	on_click = other.connect_firehead
}

connect_button2 = instance_create_layer(left+110, top+array_length(box_data) * (y_separation+textbox_height), layer, obj_button)
with connect_button2 {
	text = "InvisibleSam"
	on_click = other.connect_invisiblesam
}

// label if error
error_label = instance_create_layer(left, connect_button.y+y_separation, layer, obj_label, { label_color: c_red, label: ""})
