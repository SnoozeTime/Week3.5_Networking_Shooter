/// @description Start another client
libxprocess_init()

//execute_shell(command, "")
if parameter_count() == 3 {

	execute_shell(parameter_string(0), parameter_string(1) + " " +
        parameter_string(2) + " " +
        parameter_string(3) + " -secondary")
		
	window_set_position(window_get_x() - window_get_width() div 2 - 8, window_get_y())
	window_set_caption("P1")
	obj_control.init_player("P1")
}
if  parameter_count() == 4 {
	 window_set_position(window_get_x() + window_get_width() div 2 + 8, window_get_y())
    window_set_caption("P2")
	obj_control.init_player("P2")
}