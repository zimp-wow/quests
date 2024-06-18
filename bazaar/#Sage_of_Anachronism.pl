# (Hopefully) Temporary entry point for Fabled Instances

# Data Definition;
# expedition_name = flag_required, instance_version, max_players, dz_zone, x, y, z, h

my %data = (
    "Fabled Nagafen's Lair" => ['FNagafen', 1, 18, 'soldungb', -645,-1088, 26, 422],
);

# Common Values
my $dz_duration = 79200;


# Say response block
sub EVENT_SAY {
    my ($flag_required, $instance_version, $max_players, $dz_zone, $x, $y, $z, $h);

    if ($client->GetExpedition() && $client->GetExpedition()->GetName()) {
        my $expedition_name = $client->GetExpedition()->GetName();
        if (exists $data{$expedition_name}) {
            ($flag_required, $instance_version, $max_players, $dz_zone, $x, $y, $z, $h) = @{$data{$expedition_name}};
        }
    }

    # Hail Response. Always catch this in say response first.
    if ($text=~/hail/i) {       
        if ($dz_zone) {
            plugin::NPCTell("You have set upon a path of rememberence. Are you [ready] to proceed?");
        } else {
            plugin::NPCTell("Hail, Adventurer. I am here in order to grant you access certain [Fabled Memories], through which you can experience past events in a new light.");      
        }        
        # Never continue after handling a basic hail.
        return;
    }

    if ($text eq 'ready' && $dz_zone && plugin::is_stage_complete($client, $flag_required)) {        
        $client->MovePCDynamicZone($dz_zone);
        return;
    }

    if ($text=~/Fabled Memories/i && plugin::is_stage_complete($client, 'FNagafen')) {
        plugin::NPCTell("I can sense that you recall the great battle against [Lord Nagafen]. Would you like to revisit that?");
        return;
    }

    if ($text eq 'Lord Nagafen' && plugin::is_stage_complete($client, 'FNagafen')) {
        ($flag_required, $instance_version, $max_players, $dz_zone, $x, $y, $z, $h) = @{$data{"Fabled Nagafen's Lair"}};

        my $dz = $client->CreateExpedition($dz_zone, $instance_version, $dz_duration, "Fabled Nagafen's Lair", 1, $max_players);
        if ($dz) {
            # Compass to 'Zone In' is this NPC itself
            $dz->SetCompass($zonesn, $npc->GetX(),  $npc->GetY(),  $npc->GetZ());

            # Return location is PC's current location
            $dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());

            # Zone-In location is from the data blob
            $dz->SetZoneInLocation($x, $y, $z, $h);
            
            $dz->AddReplayLockout($dz_duration);

            plugin::NPCTell("You have set upon a path of rememberence. Are you [ready] to proceed?");
        }
        return;
    }
}