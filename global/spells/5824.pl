# Bazaar Portal
sub EVENT_SPELL_EFFECT_CLIENT {
    my $client = plugin::val('$client');

    quest::debug("Cast Bazaar Portal");

    if ($zoneid != 151) {
        quest::debug("Not in Bazaar");
        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
        $client->SetBucket("Return-Zone", $zoneid);
        $client->SetBucket("Return-Instance", $instanceid);
    } else {
        quest::debug("We are in Bazaar");
        my $ReturnX = $client->GetBucket("Return-X") || undef;
        my $ReturnY = $client->GetBucket("Return-Y") || undef;
        my $ReturnZ = $client->GetBucket("Return-Z") || undef;
        my $ReturnH = $client->GetBucket("Return-H") || undef;
        my $ReturnZone = $client->GetBucket("Return-Zone") || undef;
        my $ReturnInstance = $client->GetBucket("Return-Instance") || 0;

        if (defined($ReturnX) && defined($ReturnY) && defined($ReturnZ) && defined($ReturnH) && defined($ReturnZone)) {
            quest::debug("Found a return location");            
            $client->MovePCInstance($ReturnZone, $ReturnInstance, $ReturnX, $ReturnY, $ReturnZ, $ReturnH);            
        } else {            
            quest::debug("Returning to default location");
            plugin::move_startzone();
            return -1;
        }
    }
}

