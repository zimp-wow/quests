# Bazaar Portal
sub EVENT_SPELL_EFFECT_CLIENT {
    my $client = plugin::val('$client');

    if ($zoneid != 151) {
        $client->SetBucket("Return-X", $client->GetX());
        $client->SetBucket("Return-Y", $client->GetY());
        $client->SetBucket("Return-Z", $client->GetZ());
        $client->SetBucket("Return-H", $client->GetHeading());
        $client->SetBucket("Return-Zone", $zoneid);
        $client->SetBucket("Return-Instance", $instanceid);
    } else {
        my $ReturnX = $client->GetBucket("Return-X");
        my $ReturnY = $client->GetBucket("Return-Y");
        my $ReturnZ = $client->GetBucket("Return-Z");
        my $ReturnH = $client->GetBucket("Return-H");
        my $ReturnZone = $client->GetBucket("Return-Zone");
        my $ReturnInstance = $client->GetBucket("Return-Instance") || 0;

        if ($ReturnX && $ReturnY && $ReturnZ && $ReturnH) {
            if ($ReturnInstance) {
                $client->MovePCInstance($ReturnZone, $ReturnInstance, $ReturnX, $ReturnY, $ReturnZ, $ReturnH);
            } else {
                $client->MovePC($ReturnZone, $ReturnX, $ReturnY, $ReturnZ, $ReturnH);
            }            
        } else {
            plugin::move_startzone();
        }
    }
}

