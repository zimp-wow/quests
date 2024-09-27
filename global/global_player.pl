sub EVENT_SIGNAL {
    if ($signal == 666) {
        quest::debug("Got EoM Signal");
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
    $client->ReloadDataBuckets();    
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

sub EVENT_POPUPRESPONSE {
    if ($popupid == 58240 && $zone != 151) {
        my $x = $client->GetEntityVariable("bazaar_x") + int(rand(11)) - 5;
        my $y = $client->GetEntityVariable("bazaar_y") + int(rand(11)) - 5;
        my $z = $client->GetEntityVariable("bazaar_z");
        my $h = $client->GetEntityVariable("bazaar_h");

        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
        $client->SetBucket("Return-Zone", $zoneid);
        $client->SetBucket("Return-Instance", $instanceid);

        $client->SpellEffect(218,1);
        $client->MovePC(151, $x, $y, $z, rand(512));
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

sub EVENT_CAST_ON {
    # Check for mutually-exclusive elemental form spells.
    my @spell_ids = (
        2789, 2790, 2791, 2792, 2793, 2794, 2795, 2796, 2797, 2798, 2799, 2800,
        38329, 38330, 38331, 38333, 38334, 38335, 38336, 38337, 38338, 38340, 38341, 38342
    );
    if (grep { $_ == $spell_id } @spell_ids) {
        foreach my $id (@spell_ids) {
            next if $id == $spell_id; # Skip the matched spell_id
            $client->BuffFadeBySpellID($id);
        }
    }
}

sub EVENT_SAY {
    if ($client->GetGM()) {
        if ($text=~/#awardtitle\s*(.*)/i) {
            $client->Message(13, "Disregard the command not recognized error.");
            my $arguments = $1; # Captures everything after #awardtitle
            
            my $tar_client = $client->GetTarget();
            if ($tar_client && $tar_client->IsClient()) {
                # Validate that there is exactly one argument which is a number
                if ($arguments =~ /^\s*(\d+)\s*$/) {
                    my $number = $1; # Captures the number
                    # Proceed with awarding the title using $number
                    
                    Message(13, "Awarding TitleSet $number to " . $tar_client->GetName());
                    plugin::AddTitleFlag($number, $tar_client->CastToClient());
                } else {
                    $client->Message(13, "Invalid input. Please provide a single numeric argument.");
                }
            } else {
                $client->Message(13, "You must target a client to issue this command.");
            }
        }
    }
}

