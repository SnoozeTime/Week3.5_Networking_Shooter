/// @description Insert description here
// You can write your code in this editor
// X and Y direction
dir = [0, 0]
if dir_x != 0 or dir_y != 0 {
	var _len = sqrt(sqr(dir_x) + sqr(dir_y))
	dir[0] = dir_x / _len
	dir[1] = dir_y / _len
}

// Velocity of the projectile
vel = 5