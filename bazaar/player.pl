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
    quest::settimer("check_idle", 600);
}

sub EVENT_TIMER {
    if ($timer eq "check_idle") {
        my $last_x  = $client->GetEntityVariable("last_x");
        my $last_y  = $client->GetEntityVariable("last_y");
        my $is_idle = ($last_x eq $client->GetX() && $last_y eq $client->GetY());

        if (!$is_idle) {
            $client->DeleteEntityVariable("idle_warning");
            $client->DeleteEntityVariable("last_x");
            $client->DeleteEntityVariable("last_y");
            $client->DeleteEntityVariable("already_moved");
        }

        if ($is_idle && !$client->GetEntityVariable("idle_warning")) {
            $client->SetEntityVariable("idle_warning", 1);
            quest::ze(15, "You have been idle for too long. You will be moved to a safe location if you remain idle.");
        }

        if ($is_idle && $client->GetEntityVariable("idle_warning") && !$client->GetEntityVariable("already_moved")) {
            move_to_idle();
            $client->SetEntityVariable("already_moved", 1);
        }

        set_current_position();
    }
}

sub set_current_position {
    $client->SetEntityVariable("last_x", $client->GetX());
    $client->SetEntityVariable("last_y", $client->GetY());
}

sub move_to_idle {
    my %locs = (
        1 => [275, -5, -47, 1],
        2 => [275, 50, -47, 250],
        3 => [310, 20, -47, 380],
    );

    # Randomly select one of the predefined locations
    my $random_key = int(rand(3)) + 1;
    my $location = $locs{$random_key};

    # Add a random variation of +/- 5 to x and y coordinates
    my $random_x_offset = int(rand(11)) - 5; # Generates a number between -5 and 5
    my $random_y_offset = int(rand(11)) - 5; # Generates a number between -5 and 5

    my $new_x = $location->[0] + $random_x_offset;
    my $new_y = $location->[1] + $random_y_offset;

    $client->MovePC(0, $new_x, $new_y, $location->[2], $location->[3]); # Replace 0 with appropriate zone ID if necessary
}
