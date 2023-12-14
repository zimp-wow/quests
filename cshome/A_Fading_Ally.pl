sub EVENT_SAY {
	if ($client->GetGM()) {
		if ($text=~/god on/i) {
			quest::set_data("god-open", 10);
		} elsif ($test=~/god off/i) {
			quest::delete_data("god-open");
		}
	}
}