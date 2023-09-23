sub EVENT_SPAWN {
	quest::set_proximity($x - 80, $x + 80, $y - 80, $y + 80, $z - 80, $z + 80);
}

sub EVENT_ENTER {
	quest::movepc(45, 80, 860, -38);
}
