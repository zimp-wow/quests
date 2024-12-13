sub EVENT_SAY {
	if($text =~ /hail/i) {
		plugin::RL_StartTask($client, 50000);
	}
}
