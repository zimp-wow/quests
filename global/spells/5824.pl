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
    }
}

