 /// @description
view_width = 640
view_height = 360
 
window_scale = 2
 
window_set_size(view_width * window_scale, view_height * window_scale)
alarm[0] = 1
 
surface_resize(application_surface, view_width * window_scale, view_height * window_scale)


shake_length = 0
shake_magnitude = 0 // Pixels to right/left/top/bottom
shake_remain = 0
buff = 32 // buffer