// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function is_network_master(_pid){
	with obj_client {	
		return _pid == player_id
	}
}