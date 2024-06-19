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
        if ($client->GetBucket("season-bag-upgrade-available")) {
            plugin::NPCTell("I see that you've met such challenges so that I can upgrade your Portable Hole! Hand it to me, and I will return it to you with an inflated Pocket Dimension");
        }

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

    if ($text=~/Fabled Memories/i ) {
        my $count = 0;
        if (plugin::is_stage_complete($client, 'FNagafen')) {
            plugin::NPCTell("I can sense that you recall the great battle against [Lord Nagafen]. Would you like to revisit that?");
            $count++
        }

        if (!$count) {
            plugin::NPCTell("You do not seem to have any such memories to relive. Go! Explore! Maybe you'll earn some.");
        }
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

sub EVENT_ITEM {
    if ($client->GetBucket("season-bag-upgrade-available")) {
        if (plugin::check_handin(\%itemcount, 199990 => 1)) {
            $client->SummonFixedItem(199991);
            $client->DeleteBucket("season-bag-upgrade-available");
            plugin::NPCTell("Woosh! It's bigger!");
        }

        if (plugin::check_handin(\%itemcount, 199991 => 1)) {
            $client->SummonFixedItem(199992);
            $client->DeleteBucket("season-bag-upgrade-available");
            plugin::NPCTell("Woosh! It's bigger!");
        }

        if (plugin::check_handin(\%itemcount, 199992 => 1)) {
            $client->SummonFixedItem(199993);
            $client->DeleteBucket("season-bag-upgrade-available");
            plugin::NPCTell("Woosh! It's bigger!");
        }

        if (plugin::check_handin(\%itemcount, 199994 => 1)) {
            $client->SummonFixedItem(199995);
            $client->DeleteBucket("season-bag-upgrade-available");
            plugin::NPCTell("Woosh! It's bigger!");
        }

        if (plugin::check_handin(\%itemcount, 199995 => 1)) {
            $client->SummonFixedItem(199996);
            $client->DeleteBucket("season-bag-upgrade-available");
            plugin::NPCTell("Woosh! It's bigger!");
        }
    }

    plugin::return_items(\%itemcount);
}