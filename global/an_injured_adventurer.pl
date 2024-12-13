sub EVENT_SAY {
	if($text =~ /hail/i) {
		quest::say("It's dangerous to go alone, take this.");
	}
}
