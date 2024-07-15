sub EVENT_SIGNAL {
    if ($signal == 666) {
        plugin::UpdateEoMAward($client);
    } elsif ($signal == 100) {
        plugin::CheckWorldWideBuffs($client);
    } else {
        # Title Semaphore from lua scripts
        my $semaphore_title = $client->GetBucket('flag-semaphore');
        if ($semaphore_title) {
            plugin::AddTitleFlag($semaphore_title, $client);
            $client->DeleteBucket('flag-semaphore');
        }

        plugin::EnableTitles($client);
    }
}

sub EVENT_ENTERZONE {
    $client->ReloadDataBuckets();
	plugin::CommonCharacterUpdate($client);    
	if (!plugin::is_eligible_for_zone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
	}
}

sub EVENT_CONNECT {
    plugin::CommonCharacterUpdate($client);  
    if (!$client->GetBucket("First-Login")) {
        $client->SetBucket("First-Login", 1);
		$client->SummonItem(18471); #A Faded Writ
        $client->Message(263, "You find a small note in your pocket.");
		$client->SetBucket('FirstLogin', 1);

        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        plugin::WorldAnnounce("$name ($full_class_name) has logged in for the first time.");        
        plugin::AwardSeasonalItems($client);
    }

    if (!plugin::is_eligible_for_zone($client, $zonesn)) {
		$client->Message(4, "Your vision blurs. You lose conciousness and wake up in a familiar place.");
		$client->MovePC(151, 185, -835, 4, 390); # Bazaar Safe Location.
	}

    if (plugin::GetSoulmark($client)) {
        plugin::DisplayWarning($client);
    }
}

sub EVENT_LEVEL_UP {
    plugin::CommonCharacterUpdate($client);
    my $new_level = $client->GetLevel();
    if (($new_level % 10 == 0) || $new_level == 5 || $new_level == $client->GetBucket("CharMaxLevel")) {
        my $name = $client->GetCleanName();
        my $full_class_name = plugin::GetPrettyClassString($client);

        my $capped = ($new_level == $client->GetBucket("CharMaxLevel") || 0) ? " (Level Cap)" : "";

        plugin::WorldAnnounce("$name ($full_class_name) has reached Level $new_level$capped.");
    }
}

sub EVENT_CLICKDOOR {
	my $target_zone = plugin::get_target_door_zone($zonesn, $doorid, $version);

    if (!plugin::is_eligible_for_zone($client, $target_zone, 1)) {		
		return 1;
    }
}

sub EVENT_ZONE {
    $client->ReloadDataBuckets(); 
    # TO-DO: Use magic to determine where we zoned from, then find the reverse zone connection landing point and send us there.
    plugin::CommonCharacterUpdate($client);
}

sub EVENT_WARP {
    my $name = $client->GetCleanName();
    my $current_x = $client->GetX();
    my $current_y = $client->GetY();
    my $current_z = $client->GetZ();
    my $distance = sqrt(($current_x - $from_x) ** 2 + ($current_y - $from_y) ** 2 + ($current_z - $from_z) ** 2);
    my $account_key = $client->AccountID() . "-WarpCount";
    my $soulmark = quest::get_data($client->AccountID() . "-CheaterFlag");

    my @warp_events = plugin::DeserializeList(quest::get_data($account_key));

    # Enqueue the current warp event with timestamp
    push @warp_events, time();

    # Clean up array elements older than 30 days
    my $thirty_days_in_seconds = 30 * 24 * 60 * 60;
    @warp_events = grep { time() - $_ <= $thirty_days_in_seconds } @warp_events;

    # Count recent warp events
    my $recent_warp_count = scalar(@warp_events);

    my $enforcement = 0;

    quest::set_data($account_key, plugin::SerializeList(@warp_events));

    if ($distance > 100 || $soulmark) {
        my $admin_message = "Large Warp Detected. Character: $name Zone: $zonesn From: $from_x, $from_y, $from_z To: $current_x, $current_y, $current_z Distance: $distance";

        if ($soulmark) {
            $admin_message .= "\nAccount has Soulmark. Reason: $soulmark";            
        }

        if ($recent_warp_count) {
            $admin_message .= "\nPrevious 30-day Warp Count: $recent_warp_count";
        }

        if ($soulmark && $recent_warp_count > 10) {
            $admin_message .= "\nHigh 30-day Warp Count. Enforcement Engaged.";
            $enforcement = 1;
        }

        # Send the admin message
        quest::discordsend("admin", $admin_message);
        quest::debug($admin_message);

        if ($enforcement) {
            $client->WorldKick();
        }
    }
}



sub EVENT_DISCOVER_ITEM {
    my $name = $client->GetCleanName();
    
    # Only announce upgraded items
    if ($itemid > 999999) {        
        plugin::WorldAnnounceItem("$name has discovered: {item}.",$itemid);  
    }  
}

sub EVENT_COMBINE_VALIDATE {
	if ($recipe_id == 10344) {
		if ($validate_type =~/check_zone/i) {
			if ($zone_id != 289 && $zone_id != 290) {
				return 1;
			}
		}
	}
	
	return 0;
}

sub EVENT_COMBINE_SUCCESS {
    if ($recipe_id =~ /^1090[4-7]$/) {
        $client->Message(1,
            "The gem resonates with power as the shards placed within glow unlocking some of the stone's power. ".
            "You were successful in assembling most of the stone but there are four slots left to fill, ".
            "where could those four pieces be?"
        );
    }
    elsif ($recipe_id =~ /^10(903|346|334)$/) {
        my %reward = (
            melee  => {
                10903 => 67665,
                10346 => 67660,
                10334 => 67653
            },
            hybrid => {
                10903 => 67666,
                10346 => 67661,
                10334 => 67654
            },
            priest => {
                10903 => 67667,
                10346 => 67662,
                10334 => 67655
            },
            caster => {
                10903 => 67668,
                10346 => 67663,
                10334 => 67656
            }
        );
        my $type = plugin::ClassType($class);
        quest::summonfixeditem($reward{$type}{$recipe_id});
        quest::summonfixeditem(67704); # Item: Vaifan's Clockwork Gemcutter Tools
        $client->Message(1,"Success");
    }
}

sub EVENT_SAY {
	if ($client->GetGM()) {
        if ($text=~/debug upgrade bag/i) {
            my %item = (
                "item_id"             => 199996,
                "charges"            => 0,
                "augment_one"         => 0,
                "augment_two"         => 0,
                "augment_three"     => 0,
                "augment_four"         => 0,
                "augment_five"         => 0,
                "augment_six"       => 0,
                "attuned"             => 1,
                "slot_id"             => 32
            );

            $client->AddItem(\%item);
        }
		if ($text=~/enable seasonal/i) {
			plugin::EnableSeasonal($client);
			$client->Message(15, "Seasonal Enabled");
            $client->Message(15, "IsSeasonal() == " . plugin::IsSeasonal($client));
		} elsif ($text=~/disable seasonal/i) {
			plugin::DisableSeasonal($client);
			$client->Message(15, "Seasonal Disabled");
            $client->Message(15, "IsSeasonal() == " . plugin::IsSeasonal($client));
		} elsif ($text=~/diag/i) {
            $client->Message(15, "Season: " . plugin::GetSeasonID());
            $client->Message(15, "IsSeasonal? : " . plugin::IsSeasonal($client));
            $client->Message(15, "IsSeasonal? : " . $client->IsSeasonal());
            $client->Message(14, "MC:? " . plugin::MultiClassingEnabled());

            quest::debug("zone: $zonesn". plugin::is_eligible_for_zone($client, $zonesn));

            quest::discordsend('admin', "TEST!");

            my ($sec, $min, $hour, $day, $mon, $year) = localtime();
            $year += 1900; # Adjust year to get the current year
            $mon++;
            plugin::YellowText("Date: $year-$mon-$day");
        }
	}
}

sub EVENT_CAST {
    quest::debug("spell_id " . $spell_id);
    quest::debug("caster_id " . $caster_id);
    quest::debug("caster_level " . $caster_level);
    quest::debug("target_id " . $target_id);
    quest::debug("target " . $target);
    quest::debug("spell " . $spell);

    quest::debug($client->GetPetID());
}

sub EVENT_ITEM_CLICK_CAST_CLIENT {
    swap_vib_gaunt_and_hammer($client, $item_id);
}

sub swap_vib_gaunt_and_hammer {
    my ($client, $item_id) = @_;    
    my $src_item = 0;
    my $dst_item = 0;
    
    if ($item_id % 1000000 == 11668 || $item_id % 1000000 == 11669) {
        $src_item = $item_id;

        my $rank = int($item_id / 1000000);
        if ($item_id % 1000000 == 11668) {
            $dst_item = 11669 + ($rank * 1000000);
        }

        if ($item_id % 1000000 == 11669) {
            $dst_item = 11668 + ($rank * 1000000);
        }
    }

    if ($src_item && $dst_item) {
        $client->SummonFixedItem($dst_item);
    }
}