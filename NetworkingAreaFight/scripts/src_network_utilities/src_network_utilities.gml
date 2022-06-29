//https://gafferongames.com/post/reliability_ordering_and_congestion_avoidance_over_udp/
// seq numbers are using u16. This is used to handle wrap-around
function net_seq_greater_than(_s1, _s2){
	return (( _s1 > _s2) and ( _s1 - _s2 <= 32768)) 
		or (( _s1 < _s2) and ( _s2 - _s1 > 32768))
}