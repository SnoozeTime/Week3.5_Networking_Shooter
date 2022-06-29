/// @description initialize direction

// X and Y direction
dir = [0, 0]
if dir_x != 0 or dir_y != 0 {
	var _len = sqrt(sqr(dir_x) + sqr(dir_y))
	dir[0] = dir_x / _len
	dir[1] = dir_y / _len
}

my_parent = -1

init = function(parent_id) {
	log("Initialize")	
	my_parent = parent_id
}

print = function() {
	log("projectile shot by " + string(my_parent))
}