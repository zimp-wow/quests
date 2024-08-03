sub EVENT_CLICKDOOR {
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    my $destination         = quest::get_data("magic_map_target");
    if ($doorid == 146) {
        if ($destination && exists $portal_destinations{$destination}) {
            my ($destination_name, $portalid) = @{ $portal_destinations{$destination} };
            quest::popup('Teleport', "Teleport to $destination_name?", $portalid, 1, 0);
        }
    }
}

sub EVENT_POPUPRESPONSE {
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    
    foreach my $info (values %portal_destinations) {
        my ($destination_name, $portalid, $zone_id, $x, $y, $z, $heading) = @$info;        
        if ($popupid == $portalid) {
            $heading ||= quest::GetZoneSafeHeading($zone_id);
            quest::movepc($zone_id, $x, $y, $z, $heading);
            return;
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
    quest::settimer("check_idle", get_idle_time());
    if ($timer eq "check_idle") {
        if ($client->IsTrader()) {
            # NOP
        }
        else {
            my $idle        = check_position();
            my $idle_track  = $client->GetEntityVariable("idle_warning") ? int($client->GetEntityVariable("idle_warning")) : 0;
            my $non_idle_c  = $client->GetEntityVariable("non_idle_count") ? int($client->GetEntityVariable("non_idle_count")) : 1;

            $client->SetEntityVariable("idle_warning", $idle_track + 1);

            quest::debug("idle: $idle, idle_track: $idle_track, non_idle_c: $non_idle_c");

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
                    my $instance = quest::CreateInstance('bazaar', 0, 144000000);
                    $client->Message(15, "You have been idle for ten minutes. Transporting you to a private instance of the Bazaar...");                    
                    $client->AssignToInstance($instance);
                    $client->MovePCInstance(151, $instance, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
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