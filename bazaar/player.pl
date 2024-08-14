sub EVENT_CLICKDOOR {
    if ($doorid == 146) { # Magic Map
        my $attuned_shortname   = $client->GetEntityVariable("magic_map_attune");
        my $waypoint_data = plugin::GetWaypoint($attuned_shortname, $client);
        if ($waypoint_data || ($attuned_shortname eq 'instance' && $client->GetExpedition())) {
            my $long_name = $waypoint_data->[0];  # Access the long name (first element in the array)
            my $continent = $waypoint_data->[1];  # Access the continent ID
            my $x = $waypoint_data->[2];          # X coordinate
            my $y = $waypoint_data->[3];          # Y coordinate
            my $z = $waypoint_data->[4];          # Z coordinate
            my $heading = $waypoint_data->[5];    # Heading

            if ($attuned_shortname eq 'instance') {
                $dz = $client->GetExpedition();
                $long_name = $dz->GetName();
            }

            my $popup_title = "Travel with the Magic Map";
            my $popup_text  = "Would you like to travel to $long_name?";
            my $popup_self  = 1460;
            my $popup_group = 1461;
            my $popup_btns  = 2;
            my $popup_btn_1 = "Self";
            my $popup_btn_2 = "Group";
            my $popup_dur   = 30;

            $client->Popup2($popup_title, $popup_text, $popup_self, $popup_group, $popup_btns, $popup_dur, $popup_btn_1, $popup_btn_2);
        } else {
            plugin::YellowText("The Magic Map has not been attuned to you. Talk to Tearel to continue.");
        }
    }    
}

sub EVENT_POPUPRESPONSE {
    if ($popupid == 1460 || $popupid == 1461) {
        my $group_flg           = quest::get_data($client->AccountID() ."-group-ports-enabled") || "";
        my $attuned_shortname   = $client->GetEntityVariable("magic_map_attune");
        my $waypoint_data = plugin::GetWaypoint($attuned_shortname, $client);

        if ($waypoint_data || ($attuned_shortname eq 'instance' && $client->GetExpedition())) {
            my $long_name = $waypoint_data->[0];  # Access the long name (first element in the array)
            my $continent = $waypoint_data->[1];  # Access the continent ID
            my $x = $waypoint_data->[2];          # X coordinate
            my $y = $waypoint_data->[3];          # Y coordinate
            my $z = $waypoint_data->[4];          # Z coordinate
            my $heading = $waypoint_data->[5];    # Heading

            if ($popupid == 1461 && !$group_flg) {
                plugin::YellowText("Your account does not have the ability to transport your group this way unlocked.");
                return;
            }

            if ($popupid == 1461) { 
                my $group = $client->GetGroup();
                if ($group) {
                    # Get the expedition object
                    my $dz = $client->GetExpedition();
                    my $expedition_members_ref = $dz->GetMembers();
                    my %expedition_members = %{$expedition_members_ref};

                    for (my $count = 0; $count < $group->GroupCount(); $count++) {
                        my $player = $group->GetMember($count);
                        if ($player) {
                            # Check if the player is a member of the expedition
                            my $player_name = $player->GetName();
                            if ($dz && !exists $expedition_members{$player_name}) {
                                plugin::YellowText("$player_name is not a member of this expedition.");
                                return;
                            }
                        }
                    }

                    # If all checks pass, move the group members who are within range
                    for (my $count = 0; $count < $group->GroupCount(); $count++) {
                        my $player = $group->GetMember($count);                  

                        if ($player && (plugin::is_eligible_for_zone($player->CastToClient(), $attuned_shortname, 1) || $attuned_shortname eq 'instance')) {                            
                            if ($attuned_shortname eq 'instance' && $client->GetExpedition()) {
                                $dz = $client->GetExpedition();
                                $player->MovePCDynamicZone($dz->GetZoneID());                                      
                            } else {
                                $player->MovePC($attuned_shortname, $x, $y, $z, $heading);
                            }
                            $player->SpellEffect(218, 1);
                        }
                    }
                }
            }

            if ($attuned_shortname eq 'instance' && $client->GetExpedition()) {
                $dz = $client->GetExpedition();
                $client->MovePCDynamicZone($dz->GetZoneID());
            } else {                
                $client->MovePC($attuned_shortname, $x, $y, $z, $heading);
            }
            $client->SpellEffect(218,1);
        }        
    }
}

sub EVENT_ENTERZONE {
    set_current_position();
    quest::settimer("check_idle", get_idle_time());
}

sub EVENT_CONNECT {
    set_current_position();
    quest::settimer("check_idle", get_idle_time());
}

sub EVENT_TIMER {
    return; # NOP THIS
    quest::settimer("check_idle", get_idle_time());
    if ($timer eq "check_idle") {
        if ($client->IsTrader() || $client->GetGM()) {
            # NOP
        }
        else {
            my $idle        = check_position();
            my $idle_track  = $client->GetEntityVariable("idle_warning") ? int($client->GetEntityVariable("idle_warning")) : 0;
            my $non_idle_c  = $client->GetEntityVariable("non_idle_count") ? int($client->GetEntityVariable("non_idle_count")) : 1;

            $client->SetEntityVariable("idle_warning", $idle_track + 1);
            if ($instanceid) { # inside private instance   
                if ($idle and $idle_track % 300 == 0) {
                    $client->Message(15, "You are in a private Bazaar instance. You will be transported to the public Bazaar once you are no longer idle.");
                }
                elsif (!$idle) {
                    if ($non_idle_c < 3) {
                        $client->SetEntityVariable("non_idle_count", $non_idle_c + 1);
                    } else {
                        $client->Message(15, "You are no longer idle. Returning you to the public Bazaar.");
                        $client->RemoveFromInstance($instanceid);

                        quest::DestroyInstance($instanceid);

                        $client->MovePC(151, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
                    }                    
                }
            }
            else { # inside public bazaar
                if (!$idle ) {
                    $client->DeleteEntityVariable("idle_warning");
                }
                elsif ($idle and $idle_track >= (300 * 2)) {
                    # my $instance = quest::CreateInstance('bazaar', 0, 144000000);
                    # $client->Message(15, "You have been idle for ten minutes. Transporting you to a private instance of the Bazaar...");                    
                    # $client->AssignToInstance($instance);
                    # $client->MovePCInstance(151, $instance, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
                }
                elsif ($idle) {
                    my $minutes_idle = int($idle_track / 60);
                    if ($idle_track % 60 == 0 and $minutes_idle >= 5) { # Trigger a warning every minute
                        my %number_words = (1 => "one", 2 => "two", 3 => "three", 4 => "four", 5 => "five", 6 => "six", 7 => "seven", 8 => "eight", 9 => "nine");
                        my $minutes_idle_word = $number_words{$minutes_idle} // $minutes_idle;
                        $client->Message(15, "You have been idle for $minutes_idle_word minutes. You will be transported to a private instance of the Bazaar soon.");
                    }
                }
            }
        }
    }
}

sub check_position {
    my $cur_x = $client->GetX();
    my $cur_y = $client->GetY();
    my $cur_h = $client->GetHeading();
    my $pre_x = $client->GetEntityVariable("last_x");
    my $pre_y = $client->GetEntityVariable("last_y");
    my $pre_h = $client->GetEntityVariable("last_h");

    my $idle  = ($cur_x eq $pre_x and $cur_y eq $pre_y and $cur_h eq $pre_h) ? 1 : 0;

    set_current_position();

    return $idle;
}

sub set_current_position {
    $client->SetEntityVariable("last_x", $client->GetX());
    $client->SetEntityVariable("last_y", $client->GetY());
    $client->SetEntityVariable("last_h", $client->GetHeading());
}

sub get_idle_time {
    return 1;
}