sub NPCTell {	
	my $npc = plugin::val('npc');
    my $client = plugin::val('client');
	my $message = shift;

	my $NPCName = $npc->GetCleanName();
    my $tellColor = 257;
	
    $client->Message($tellColor, "$NPCName tells you, '" . $message . "'");
}

sub YellowText {
	my $message     = shift;
    my $client      = shift || plugin::val('client');
    my $tellColor   = 335;
	
    $client->Message($tellColor, $message);
}

sub RedText {
	my $message     = shift;
    my $client      = shift || plugin::val('client');
    my $tellColor   = 287;
	
    $client->Message($tellColor, $message);
}

sub PurpleText {
	my $message     = shift;
    my $client      = shift || plugin::val('client');
    my $tellColor   = 257;
	
    $client->Message($tellColor, $message);
}

# Serializer
sub SerializeList {
    my @list = @_;
    return join(',', @list);
}

# Deserializer
sub DeserializeList {
    my $string = shift;
    return split(',', $string);
}

# Serializer
sub SerializeHash {
    my %hash = @_;
    return join(';', map { "$_=$hash{$_}" } keys %hash);
}

# Deserializer
sub DeserializeHash {
    my $string = shift;
    my %hash = map { split('=', $_, 2) } split(';', $string);
    return %hash;
}

sub return_items_silent {
	my $hashref = plugin::var('$itemcount');
	my $client = plugin::val('$client');
	my $name = plugin::val('$name');
	my $items_returned = 0;

	my %item_data = (
		0 => [ plugin::val('$item1'), plugin::val('$item1_charges'), plugin::val('$item1_attuned'), plugin::val('$item1_inst') ],
		1 => [ plugin::val('$item2'), plugin::val('$item2_charges'), plugin::val('$item2_attuned'), plugin::val('$item2_inst') ],
		2 => [ plugin::val('$item3'), plugin::val('$item3_charges'), plugin::val('$item3_attuned'), plugin::val('$item3_inst') ],
		3 => [ plugin::val('$item4'), plugin::val('$item4_charges'), plugin::val('$item4_attuned'), plugin::val('$item4_inst') ],
	);

	my %return_data = ();	

	foreach my $k (keys(%{$hashref})) {
		next if ($k == 0);
		my $rcount = $hashref->{$k};
		my $r;
		for ($r = 0; $r < 4; $r++) {
			if ($rcount > 0 && $item_data{$r}[0] && $item_data{$r}[0] == $k) {
				if ($client) {
					my $inst = $item_data{$r}[3];
					my $return_count = $inst->RemoveTaskDeliveredItems();
					if ($return_count > 0) {
						$client->SummonItem($k, $inst->GetCharges(), $item_data{$r}[2]);
						$return_data{$r} = [$k, $item_data{$r}[1], $item_data{$r}[2]];
						$items_returned = 1;
						next;
					}
					$return_data{$r} = [$k, $item_data{$r}[1], $item_data{$r}[2]];
					$client->SummonItem($k, $item_data{$r}[1], $item_data{$r}[2]);
					$items_returned = 1;
				} else {
					$return_data{$r} = [$k, $item_data{$r}[1], $item_data{$r}[2]];
					quest::summonitem($k, 0);
					$items_returned = 1;
				}
				$rcount--;
			}
		}

		delete $hashref->{$k};
	}

	# check if we have any money to return
	my @money = ("platinum", "gold", "silver", "copper");
	my $returned_money = 0;
	foreach my $m (@money) {
		if ($hashref->{$m} && $hashref->{$m} > 0) {
			$returned_money = 1;
		}
	}

	if ($returned_money) {
		my ($cp, $sp, $gp, $pp) = ($hashref->{"copper"}, $hashref->{"silver"}, $hashref->{"gold"}, $hashref->{"platinum"});
		$client->AddMoneyToPP($cp, $sp, $gp, $pp, 1);
		$client->SetEntityVariable("RETURN_MONEY", "$cp|$sp|$gp|$pp");
	}

	$client->SetEntityVariable("RETURN_ITEMS", plugin::GetHandinItemsSerialized("Return", %return_data));

	if ($items_returned || $returned_money) {
		#quest::say("I have no need for this $name, you can have it back.");
	}

	quest::send_player_handin_event();

	# Return true if items were returned
	return ($items_returned || $returned_money);
}

# Check if the specified item ID exists
sub item_exists_in_db {
    my $item_id = shift;
    my $dbh = plugin::LoadMysql();
    my $sth = $dbh->prepare("SELECT count(*) FROM items WHERE id = ?");
    $sth->execute($item_id);

    my $result = $sth->fetchrow_array();

    return $result > 0 ? 1 : 0;
}

sub get_total_attunements {
    my $client = shift;
    my @suffixes = ('A', 'O', 'F', 'K', 'V', 'L'); # Add more suffixes as needed
    my $total = 0;

    foreach my $suffix (@suffixes) {
        my $zone_data = get_zone_data_for_account($client->AccountID(), $suffix);
        $total += scalar(keys %$zone_data);
    }

    return $total;
}

sub get_continent_fix {
    my %zone_to_continent = (

        # Faydwer
        'akanon'     => 'F',
        'butcher'    => 'F',
        'cauldron'   => 'F',
        'crushbone'  => 'F',
        'felwithea'  => 'F',
        'felwitheb'  => 'F',
        'gfaydark'   => 'F',
        'kedge'      => 'F',
        'kaladima'   => 'F',
        'kaladimb'   => 'F',
        'lfaydark'   => 'F',
        'mistmoore'  => 'F',
        'steamfont'  => 'F',
        'unrest'     => 'F',

        # Antonica
        'arena'         => 'A',
        'befallen'      => 'A',
        'beholder'      => 'A',
        'blackburrow'   => 'A',
        'cazicthule'    => 'A',
        'commons'       => 'A',
        'ecommons'      => 'A',
        'eastkarana'    => 'A',
        'erudsxing'     => 'A',
        'everfrost'     => 'A',
        'feerrott'      => 'A',
        'freporte'      => 'A',
        'freportn'      => 'A',
        'freportw'      => 'A',
        'grobb'         => 'A',
        'gukbottom'     => 'A',
        'guktop'        => 'A',
        'halas'         => 'A',
        'highkeep'      => 'A',
        'highpasshold'  => 'A',
        'innothule'     => 'A',
        'kithicor'      => 'A',
        'lakerathe'     => 'A',
        'lavastorm'     => 'A',
        'misty'         => 'A',
        'najena'        => 'A',
        'neriaka'       => 'A',
        'neriakb'       => 'A',
        'neriakc'       => 'A',
        'neriakd'       => 'A',
        'nektulos'      => 'A',
        'northkarana'   => 'A',
        'nro'           => 'A',
        'oasis'         => 'A',
        'oggok'         => 'A',
        'oot'           => 'A',
        'paw'           => 'A',
        'permafrost'    => 'A',
        'qcat'          => 'A',
        'qey2hh1'       => 'A',
        'qeynos'        => 'A',
        'qeynos2'       => 'A',
        'qeytoqrg'      => 'A',
        'qrg'           => 'A',
        'rathemtn'      => 'A',
        'rivervale'     => 'A',
        'runnyeye'      => 'A',
        'soldunga'      => 'A',
        'soldungb'      => 'A',
        'soltemple'     => 'A',
        'southkarana'   => 'A',
        'sro'           => 'A',
        'gunthak'       => 'A',
        'dulak'         => 'A',
        'nadox'         => 'A',
        'torgiran'      => 'A',
        'hatesfury'     => 'A',
        'jaggedpine'    => 'A',
        
        # Odus
        'hole'          => 'O',
        'kerraridge'    => 'O',
        'paineel'       => 'O',
        'tox'           => 'O',
        'warrens'       => 'O',
        'stonebrunt'    => 'O',
        'erudnext'      => 'O',

        # Kunark
        'burningwood'   => 'K',
        'cabeast'       => 'K',
        'cabwest'       => 'K',
        'chardok'       => 'K',
        'charasis'      => 'K',
        'citymist'      => 'K',
        'dalnir'        => 'K',
        'dreadlands'    => 'K',
        'droga'         => 'K',
        'emeraldjungle' => 'K',
        'fieldofbone'   => 'K',
        'firiona'       => 'K',
        'frontiermtns'  => 'K',
        'kaesora'       => 'K',
        'karnor'        => 'K',
        'kurn'          => 'K',
        'lakeofillomen' => 'K',
        'nurga'         => 'K',
        'overthere'     => 'K',
        'sebilis'       => 'K',
        'skyfire'       => 'K',
        'swampofnohope' => 'K',
        'timorous'      => 'K',
        'trakanon'      => 'K',
        'veeshan'       => 'K',
        'warslikswood'  => 'K',
        
        # Velious
        'cobaltscar'    => 'V',
        'crystal'       => 'V',
        'eastwastes'    => 'V',
        'frozenshadow'  => 'V',
        'greatdivide'   => 'V',
        'iceclad'       => 'V',
        'kael'          => 'V',
        'necropolis'    => 'V',
        'sirens'        => 'V',
        'sleepers'      => 'V',
        'skyshrine'     => 'V',
        'templeveeshan' => 'V',
        'thurgadina'    => 'V',
        'thurgadinb'    => 'V',
        'velketor'      => 'V',
        'wakening'      => 'V',
        'westwastes'    => 'V',

        # Luclin
        'acrylia'      => 'L',
        'akheva'       => 'L',
        'bazaar'       => 'L',
        'dawnshroud'   => 'L',
        'echo'         => 'L',
        'fungusgrove'  => 'L',
        'griegsend'    => 'L',
        'grimling'     => 'L',
        'hollowshade'  => 'L',
        'katta'        => 'L',
        'letalis'      => 'L',
        'maiden'       => 'L',
        'mseru'        => 'L',
        'netherbian'   => 'L',
        'nexus'        => 'L',
        'paludal'      => 'L',
        'scarlet'      => 'L',
        'shadeweaver'  => 'L',
        'shadowhaven'  => 'L',
        'sharvahl'     => 'L',
        'sseru'        => 'L',
        'ssratemple'   => 'L',
        'tenebrous'    => 'L',
        'thedeep'      => 'L',
        'thegrey'      => 'L',
        'umbral'       => 'L',
        'vexthal'      => 'L',

        # Planes of Power
        'poknowledge'         => 'P',
        'potranquility'       => 'P',        
        'pojustice'           => 'P', # Plane of Justice
        'podisease'           => 'P', # Plane of Disease
        'poinnovation'        => 'P', # Plane of Innovation
        'ponightmare'         => 'P', # Plane of Nightmare
        'nightmareb'          => 'P', # The Lair of Terris Thule
        'povalor'             => 'P', # Plane of Valor
        'postorms'            => 'P', # Plane of Storms
        'potorment'           => 'P', # Plane of Torment
        'codecay'             => 'P',
        'hohonora'            => 'P',
        'hohonorb'            => 'P',
        'bothunder'           => 'P',
        'potactics'           => 'P',
        'solrotower'          => 'P',
        'pofire'              => 'P',
        'poair'               => 'P',
        'powater'             => 'P',
        'poeartha'            => 'P',
        'poearthb'            => 'P',
        'potimea'             => 'P',
        'potimeb'             => 'P',
        'hateplaneb'          => 'P',
        'mischiefplane'       => 'P',
        'airplane'            => 'P',
        'fearplane'           => 'P',

        # Gates of Discord
        'abysmal'      => 'G',
        'barindu'      => 'G',
        'ferubi'       => 'G',
        'ikkinz'       => 'G',
        'inktuta'      => 'G',
        'kodtaz'       => 'G',
        'natimbi'      => 'G',
        'qinimi'       => 'G',
        'qvic'         => 'G',
        'riwwi'        => 'G',
        'snlair'       => 'G',
        'snplant'      => 'G',
        'snpool'       => 'G',
        'sncrematory'  => 'G',
        'tacvi'        => 'G',
        'tipt'         => 'G',
        'txevu'        => 'G',
        'uqua'         => 'G',
        'vxed'         => 'G',
        'yxtta'        => 'G',

        # Omens of Discord
        'anguish'           => 'O',
        'bloodfields'       => 'O',
        'causeway'          => 'O',
        'chambersa'         => 'O',
        'chambersb'         => 'O',
        'chambersc'         => 'O',
        'chambersd'         => 'O',
        'chamberse'         => 'O',
        'chambersf'         => 'O',
        'dranik'            => 'O',
        'dranikcatacombsa'  => 'O',
        'dranikcatacombsb'  => 'O',
        'dranikcatacombsc'  => 'O',
        'dranikhollowsa'    => 'O',
        'dranikhollowsb'    => 'O',
        'dranikhollowsc'    => 'O',
        'dranikscar'        => 'O',
        'drainksewersa'     => 'O',
        'drainksewersb'     => 'O',
        'drainksewersc'     => 'O',
        'harbingers'        => 'O',
        'provinggrounds'    => 'O',
        'riftseekers'       => 'O',
        'wallofslaughter'   => 'O',

    );

    my $zonesn = shift;

    if (exists $zone_to_continent{$zonesn}) {
        return $zone_to_continent{$zonesn};
    } else {
        return undef;
    }
}

# Get character's saved zone data
sub get_zone_data_for_character {
    my ($characterID, $suffix) = @_;
    my $charKey = $characterID . "-TL-" . $suffix;

    fix_zone_data($characterID, $suffix);

    my $charDataString = quest::get_data($charKey);

    # Debug: Print the raw string data
    #quest::debug("characterID: $characterID suffix: $suffix Raw Data: $charDataString");

    my %teleport_zones;
    my @zone_entries = split /:/, $charDataString;

    foreach my $entry (@zone_entries) {
        my @tokens = split /,/, $entry;
        $teleport_zones{$tokens[0]} = [@tokens[1..$#tokens]];
    }

    return \%teleport_zones;
}

sub set_zone_data_for_character {
    my ($characterID, $zone_data_hash_ref, $suffix) = @_;
    my $charKey = $characterID . "-TL-" . $suffix;

    # Debug: Print the key used to store data
    #quest::debug("Setting data with key: $charKey");

    my @data_entries;

    while (my ($desc, $zone_data) = each %{$zone_data_hash_ref}) {
        my $entry = join(",", $desc, @{$zone_data});
        push @data_entries, $entry;
    }

    my $charDataString = join(":", @data_entries);

    # Debug: Print the data string being set
    #quest::debug("Setting Raw Data: $charDataString");

    quest::set_data($charKey, $charDataString);
}

# Get character's saved zone data
sub get_zone_data_for_account {
    my ($accountID, $suffix) = @_;
    my $charKey = $accountID . "-TL-Account-" . $suffix;

    my $charDataString = quest::get_data($charKey);

    # Debug: Print the raw string data
    #quest::debug("characterID: $characterID suffix: $suffix Raw Data: $charDataString");

    my %teleport_zones;
    my @zone_entries = split /:/, $charDataString;

    foreach my $entry (@zone_entries) {
        my @tokens = split /,/, $entry;
        $teleport_zones{$tokens[0]} = [@tokens[1..$#tokens]];
    }

    return \%teleport_zones;
}

sub set_zone_data_for_account {
    my ($accountID, $zone_data_hash_ref, $suffix) = @_;
    my $charKey = $accountID . "-TL-Account-" . $suffix;

    # Debug: Print the key used to store data
    #quest::debug("Setting data with key: $charKey");

    my @data_entries;

    while (my ($desc, $zone_data) = each %{$zone_data_hash_ref}) {
        my $entry = join(",", $desc, @{$zone_data});
        push @data_entries, $entry;
    }

    my $charDataString = join(":", @data_entries);

    # Debug: Print the data string being set
    #quest::debug("Setting Raw Data: $charDataString");

    quest::set_data($charKey, $charDataString);
}

sub add_char_zone_data_to_account {
    my ($characterID, $accountID, $suffix) = @_;

    # Get the character's zone data
    my $char_zone_data = get_zone_data_for_character($characterID, $suffix);

    # Get the account's current zone data
    my $account_zone_data = get_zone_data_for_account($accountID, $suffix);

    # Add the character's zone data to the account's zone data
    while (my ($zone, $data) = each %{$char_zone_data}) {
        if (exists $account_zone_data->{$zone}) {
            # If the zone already exists in the account's data, you can choose how to merge the data.
            # For example, you could skip, replace, or merge the data. Here, we simply replace.
            $account_zone_data->{$zone} = $data;
        } else {
            # If the zone does not exist in the account's data, add it.
            $account_zone_data->{$zone} = $data;
        }
    }

    # Save the updated zone data back to the account
    set_zone_data_for_account($accountID, $account_zone_data, $suffix);
}

# Serializes the data structure for storage
# Usage:
#    my %zone_data = ('Zone1' => ['data1', 'data2'], 'Zone2' => ['data3', 'data4']);
#    my $serialized_data = serialize_zone_data(\%zone_data);
#    print $serialized_data;
sub serialize_zone_data {
    my ($data) = @_;
    my @entries = ();
    foreach my $key (keys %{$data}) {
        push @entries, join(',', $key, @{$data->{$key}});
    }
    return join(':', @entries);
}

# Deserializes the data structure from the stored string
# Usage:
#    my $data_string = "Zone1,data1,data2:Zone2,data3,data4";
#    my $zone_data = deserialize_zone_data($data_string);
#    foreach my $zone (keys %{$zone_data}) {
#        print "Zone: $zone\n";
#    }
sub deserialize_zone_data {
    my ($string) = @_;
    my %data = ();
    foreach my $entry (split /:/, $string) {
        my @tokens = split /,/, $entry;
        $data{$tokens[0]} = [ @tokens[1..5] ];
    }
    return \%data;
}

# Check if a particular piece of data (by zone description) is present
sub has_zone_entry {
    my ($accountID, $zone_desc, $suffix) = @_;
    my $teleport_zones = plugin::get_zone_data_for_account($accountID, $suffix);

    #quest::debug("Checking for description: $zone_desc");
    #quest::debug("Current Data: " . join(", ", keys %{$teleport_zones}));

    return exists($teleport_zones->{$zone_desc});
}

# Add (or overwrite) data to teleport_zones
# Usage:
#    add_zone_entry(12345, "Zone4", ['data7', 'data8'], '-K');
sub add_zone_entry {
    my ($accountID, $zone_name, $zone_data, $suffix) = @_;
    my $teleport_zones = get_zone_data_for_account($accountID, $suffix);
    $teleport_zones->{$zone_name} = $zone_data;
    set_zone_data_for_account($accountID, $teleport_zones, $suffix);
}

sub fix_zone_data {
    my ($characterID, $suffix) = @_;
    my $charKey = $characterID . "-TL-" . $suffix;
    my $charDataString = quest::get_data($charKey);
    my $data_hash = plugin::deserialize_zone_data($charDataString);  

    delete $data_hash->{''};
    
    foreach my $key (keys %$data_hash) {        
        if (quest::GetZoneLongName($key) ne "UNKNOWN") {
            quest::debug("Fixed an element");  
            my $zone_sn = $key;
            my $zone_desc = $data_hash->{$key}[0];  # Access the elements using ->

            # Create a new entry in the hash with the zone_desc as the key
            $data_hash->{$zone_desc} = [$key, @{$data_hash->{$key}}[1..4]];

            # Delete the original key from the hash
            delete $data_hash->{$key};
        }
    }

    quest::set_data($charKey, plugin::serialize_zone_data($data_hash));
}

sub is_focus_equipped {
    my ($client, $desired_focus_id) = @_;

    # Return immediately if necessary parameters aren't provided
    return unless ($client && defined $desired_focus_id);

    # Check if any of the equipped augments in the items have the desired focus effect
    for my $slot_index (0..22) {
        my $item_id    = $client->GetItemIDAt($slot_index);
        my $item_focus = $client->GetItemStat($item_id, 'focuseffect');
        return 1 if ($item_focus == $desired_focus_id);
        for my $aug_index (0..6) {
            my $augment_id      = $client->GetAugmentIDAt($slot_index, $aug_index);
            my $augment_focus   = $client->GetItemStat($augment_id, 'focuseffect');
            return 1 if ($augment_focus == $desired_focus_id);
        }
    }

    # If neither items nor augments have the focus, return 0
    return 0;
}

return 1;