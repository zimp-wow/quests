my $portable_hole = 199990;
my $award_aug     = 199995;


sub GetSeasonID 
{
    return quest::get_rule("Custom:Custom:EnableSeasonalCharacters");
}

sub IsSeasonal {
    my $client = shift;
    return quest::get_rule("Custom:Custom:EnableSeasonalCharacters") == $client->GetBucket("SeasonalCharacter");
}

sub AwardSeasonalItems 
{
    my $client = shift;

    if (!plugin::check_hasitem($client, $portable_hole)) {
        $client->SummonItem($portable_hole);
    }

    if (!plugin::check_hasitem($client, $award_aug)) {
        $client->SummonItem($award_aug);
    }
}

sub UpgradeSeasonalItems {

}

sub RegisterSeasonalLogin {
    my $client = shift;
    my $login_marker = $client->GetBucket("LoginMarker");

    if ($client->IsSeasonal()) {
        if (!$login_marker) {
            my $login_count = $client->GetBucket("Season_LoginCount") || 0;

            $client->SetBucket("Season_LoginCount", $login_count);
            $client->SetBucket("LoginMarker", quest::GetTimeSeconds(), 3600 * 16); # Expires in 16 hours.
        }
    }
}