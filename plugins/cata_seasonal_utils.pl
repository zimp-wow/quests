my $seasonal_bucket = "SeasonalCharacter";
my $seasonal_rule   = "Custom:EnableSeasonalCharacters";
my $seasonal_count  = "Season_LoginCount";

my $portable_hole = 199990;
my $award_aug     = 199995;

sub GetSeasonID 
{
    return quest::get_rule($seasonal_rule);
}

sub IsSeasonal {
    my $client = shift;
    return GetSeasonID() == $client->GetBucket($seasonal_bucket);
}

sub EnableSeasonal {
    my $client = shift;

    $client->SetBucket($seasonal_bucket);
}

sub DisableSeasonal {
    my $client = shift;

    $client->DeleteBucket($seasonal_bucket)
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
            my $login_count = $client->GetBucket($seasonal_count) || 0;

            $client->SetBucket($seasonal_count, $login_count);
            $client->SetBucket("LoginMarker", quest::GetTimeSeconds(), 3600 * 16); # Expires in 16 hours.
        }
    }
}