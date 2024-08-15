# Bazaar Portal
sub EVENT_SPELL_EFFECT_CLIENT {
    my $client = plugin::val('$client');
    use List::Util qw(shuffle);
    
    # Define a hash of possible locations in zone 151 (Bazaar)
    my %locations = (
        'safe_location' => [quest::GetZoneSafeX(151), quest::GetZoneSafeY(151), quest::GetZoneSafeZ(151), quest::GetZoneSafeHeading(151)],
        'Location A'    => [-135, -550, 5, 300],
        'Location B'    => [100, -500, 5, 300],
        'Location C'    => [95, -300, 5, 300],
        'Location D'    => [170, -95, -15, 400],
        'Location E'    => [-170, -95, -15, 400],
        'Location F'    => [-33, -50, -65, 400],
        'Location G'    => [45, -820, 4, 450],
        'Location H'    => [15, -655, 27, 290]
        # Add more locations as needed
    );

    # Shuffle the keys and pick a random location
    my @keys = shuffle(keys %locations);
    my $chosen_loc = $locations{$keys[0]};

    # Apply the randomization of +/- 5 to X and Y
    my $randomized_x    = $chosen_loc->[0] + int(rand(11)) - 5;
    my $randomized_y    = $chosen_loc->[1] + int(rand(11)) - 5;
    my $z               = $chosen_loc->[2];
    my $heading         = $chosen_loc->[3];

    if ($zoneid != 151) {
        # Save the current location
        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
        $client->SetBucket("Return-Zone", $zoneid);
        $client->SetBucket("Return-Instance", $instanceid);

        my $group = $client->GetGroup();
        if ($group) {
            for (my $count = 0; $count < $group->GroupCount(); $count++) {
                my $player = $group->GetMember($count);
                if ($player && $player->GetID() != $client->GetID() && $client->CalculateDistance($player) <= 200) {
                    my $popup_title = "Return to the Bazaar";
                    my $popup_text  = "Would you like to return to the Bazaar with your groupmate?";
                    my $popup_yes   = 58240;
                    my $popup_no    = 58241;

                    $player->Popup2($popup_title, $popup_text, $popup_yes, $popup_no, 2);
                    $player->SetEntityVariable("bazaar_x", $chosen_loc->[0]);
                    $player->SetEntityVariable("bazaar_y", $chosen_loc->[1]);
                    $player->SetEntityVariable("bazaar_z", $chosen_loc->[2]);
                    $player->SetEntityVariable("bazaar_h", $chosen_loc->[3]);
                }
            }
        }

        # Move the player to the Bazaar at a randomized location
        $client->MovePC(151, $randomized_x, $randomized_y, $z, $heading);
    } else {
        # Return player to the saved location or bind point if no saved location exists
        my $ReturnX = $client->GetBucket("Return-X");
        my $ReturnY = $client->GetBucket("Return-Y");
        my $ReturnZ = $client->GetBucket("Return-Z");
        my $ReturnH = $client->GetBucket("Return-H");
        my $ReturnZone = $client->GetBucket("Return-Zone");
        my $ReturnInstance = $client->GetBucket("Return-Instance");

        if (defined($ReturnX) && $ReturnX ne '' && 
            defined($ReturnY) && $ReturnY ne '' && 
            defined($ReturnZ) && $ReturnZ ne '' && 
            defined($ReturnH) && $ReturnH ne '' && 
            defined($ReturnZone) && $ReturnZone ne '') {
            # Delete the saved location
            $client->DeleteBucket("Return-X");
            $client->DeleteBucket("Return-Y");
            $client->DeleteBucket("Return-Z");
            $client->DeleteBucket("Return-H");
            $client->DeleteBucket("Return-Zone");
            $client->DeleteBucket("Return-Instance");            
        } else {            
            # Use the bind location if no saved location exists
            $ReturnX = $client->GetBindX();
            $ReturnY = $client->GetBindY();
            $ReturnZ = $client->GetBindZ();
            $ReturnH = $client->GetBindHeading();
            $ReturnZone = $client->GetBindZoneID();
            $ReturnInstance = 0;          
        }

        # Move the player back to the original location or bind point
        $client->MovePCInstance($ReturnZone, $ReturnInstance, $ReturnX, $ReturnY, $ReturnZ, $ReturnH);
    }
}


