// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function is_network_master(_pid){
	with obj_client {	
		return _pid == player_id
	}
}

function net_seq_greater_than(_s1, _s2){
	return (( _s1 > _s2) and ( _s1 - _s2 <= 32768)) 
		or (( _s1 < _s2) and ( _s2 - _s1 > 32768))
}