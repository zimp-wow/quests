#checks to see if player has item
#useage plugin::check_hasitem($client, itemid);
sub check_hasitem {
	my $client = shift;
	my $itemid = shift;

	my @slots = (0..30, 251..340, 2000..2023, 4010..6009, 6210..11009, 11010..11409, 9999);
	foreach $slot (@slots) {
		if ($client->GetItemIDAt($slot) % 1000000 == $itemid % 1000000) {
			return 1;
		}

		for ($i = 0; $i < 5; $i++) {
			if ($client->GetAugmentIDAt($slot, $i) % 1000000 == $itemid % 1000000) {
				return 1;
			}
		}
	}
	return 0;
}

1;
