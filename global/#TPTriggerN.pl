sub EVENT_SPAWN {
    $x = $npc->GetX();
    $y = $npc->GetY();
    $z = $npc->GetZ();

    quest::set_proximity($x - 50, $x + 50, $y - 50, $y + 50);
}

sub EVENT_ENTER {    
    quest::debug("Attempting to update attunement point...");

    # Get the race-specific waypoint for the client's base race
    my $race_specific_waypoint = plugin::GetRaceSpecificWaypoint($client->GetBaseRace());

    # Check if the current zone is the race-specific waypoint
    if ($zonesn eq $race_specific_waypoint) {
        $client->Message(263, "This location is so familiar that you would never be able to properly explain it to another.");
    } else {
        if (plugin::AddWaypoint($zonesn, $client)) {
            $client->Message(263, "This place seems familiar. You are sure to remember it later.");
        } else {
            $client->Message(263, "You know this place well.");
        }
    }
}
