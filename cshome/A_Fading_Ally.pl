my $global_bucket_key 	= "froglok-unlock";
my $panic_npctype = 1120001110;

sub get_unlock_progress {
    if ($zoneid == 26) {
        return 501;
    } else {
        return quest::get_data($global_bucket_key);
    }
}

sub set_unlock_progress {
    my $unlock_progress = shift;
    if ($zoneid != 26) {
       quest::set_data($global_bucket_key, $unlock_progress);
    } 
}
	
sub EVENT_SAY {
	$client->AddAlternateCurrencyValue(6, 1);
}

sub EVENT_ITEM { 
	my $copper = plugin::val('copper');
	my $silver = plugin::val('silver');
	my $gold = plugin::val('gold');
	my $platinum = plugin::val('platinum');
	my $total_money = ($platinum * 1000) + ($gold * 100) + ($silver * 10) + $copper;
	
	my $unlock_progress = get_unlock_progress();
	my $charname 		= $client->GetCleanName();
	my $count 			= 0;
	my $response;
	my $announce;

	foreach my $item_id (keys %itemcount) {
		if ($item_id == 976011) { #A Fading Green Memory
			if (($zoneid == 72 || $zoneid == 26) || $unlock_progress < 500) {
				$unlock_progress += $itemcount{$item_id};
				$count += $itemcount{$item_id};
				delete $itemcount{$item_id};
			}
		} else {
			quest::emote("The memory of a guktan stares into the distance, ignoring your presence.");
		}
	}
	
	# After processing all items, return any remaining money
	my $platinum_remainder = int($total_money / 1000);
	$total_money %= 1000;

	my $gold_remainder = int($total_money / 100);
	$total_money %= 100;

	my $silver_remainder = int($total_money / 10);
	$total_money %= 10;

	my $copper_remainder = $total_money;

	$client->AddMoneyToPP($copper_remainder, $silver_remainder, $gold_remainder, $platinum_remainder, 1);
	#Return any unwanted items
	plugin::return_items(\%itemcount); 
	
	set_unlock_progress($unlock_progress);
	
	if ($count) {
		
		my $account_key 	= $client->AccountID() . "froglok-memories-contributed";
		my $account_contrib = quest::get_data($account_key) + $count;

		quest::set_data($account_key, $account_contrib);
		
		$response = "Thanks be to $charname! Another memory dances free in our mind. ";
		if ($unlock_progress < 50) {
		} elsif ($unlock_progress >= 50 && $unlock_progress <= 100) {
			$response .= " Only a small number of memories have been brought to me so far, please help me! ";
		} elsif ($unlock_progress > 100 && $unlock_progress <= 300) {
			$response .= " The number of memories that have been collected grows... ";
		} elsif ($unlock_progress > 300 && $unlock_progress <= 500) {
			$response .= " Almost all of my memories have been collected. It cannot be long now... ";
		} elsif ($unlock_progress > 500 && ($zoneid == 72 || $zoneid == 26)) {
			if (!$entity_list->IsMobSpawnedByNpcTypeID($panic_npctype)) {
				$response .= " Oh Gods. I remember now! Something unspeakable comes for us!";
				quest::spawn2($panic_npctype, 0, 0, 352, 803, 205, 385);
			} else {
				$response .= " The Panic can only harm us if we fall prey to it!";
				my $panic_id = $entity_list->GetNPCByNPCTypeID($panic_npctype);
				if ($panic_id && $panic_id->GetTarget()) {
					$panic_id->SetHP($panic_id->GetHP() - ($panic_id->GetMaxHP() / 20));
					$panic_id->Shout("Who's memories are these?! I WILL NOT BE DENIED!");
				}
			}
		}

		quest::say($response);
	}
}

# This should be a plugin function...
# Add your discord webhook identifier
sub WorldAnnounce {
	#my $message = shift;
	#quest::discordsend("ooc", $message);
	quest::we(335, $message);
	#quest::say("This is the world message. $message");
}