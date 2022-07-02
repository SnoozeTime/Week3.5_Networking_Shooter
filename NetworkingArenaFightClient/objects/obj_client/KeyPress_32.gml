/// @description Send msg


// STAAAART
if myState == ClientState.not_connected {
	myState = ClientState.connecting
	log("Will connect to server")
	time_source_start(connect_timesource)
}