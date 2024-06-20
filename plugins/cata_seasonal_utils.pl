#Value of character-scoped bucket 'SeasonalCharacter' is Season ID. Season 0 is 'Not-Seasonal'. Any mistmatch between EnableSeasonalCharacters rule and SeasonalCharacter bucket is 'Not-Seasonal'

my $seasonal_bucket = "SeasonalCharacter";
my $seasonal_rule   = "Custom:EnableSeasonalCharacters";
my $seasonal_count  = "Season-LoginCount";

my $portable_hole = 199990;
my $award_aug     = 200000;

sub GetSeasonID 
{
    return quest::get_rule($seasonal_rule) || 0;
}

sub IsSeasonal {
    my $client = shift;
    my $season = ($client->GetBucket($seasonal_bucket) || 0);
    if ($season != 0) {
        return GetSeasonID() == ($client->GetBucket($seasonal_bucket) || 0);
    } else {
        return 0;
    }
}

sub EnableSeasonal {
    my $client = shift;

    $client->SetBucket($seasonal_bucket, 1);
}

sub DisableSeasonal {
    my $client = shift;

    $client->DeleteBucket($seasonal_bucket)
}

sub AwardSeasonalItems 
{
    my $client = shift;

    # Set basic account reward entitlement
    if (!quest::get_data($client->AccountID() . "-season-1-entitlement")) {
        quest::set_data($client->AccountID() . "-season-1-entitlement", "1");
    }

    if (IsSeasonal($client)) {
        if (!plugin::check_hasitem($client, $portable_hole)) {
            $client->SummonItem($portable_hole);
        }
        if (!plugin::check_hasitem($client, $award_aug)) {
            $client->SummonItem($award_aug);
        }
    }
}

sub RegisterSeasonalLogin {
    my $client = shift;

    if ($client->IsSeasonal()) {
        #login tracker        
        my $last_date = quest::get_data($client->AccountID() . "-season-1-date-flag") || 0;
        my ($sec, $min, $hour, $day, $mon, $year) = localtime();
        $year += 1900; # Adjust year to get the current year
        $mon++;

        if ($last_date != "$day-$mon-$year") {
            quest::set_data($client->AccountID() . "-season-1-date-flag", "$day-$mon-$year");
            quest::set_data($client->AccountID() . "-season-1-participation", (quest::get_data($client->AccountID() . "-season-1-participation") || 0) + 1);
        }
    }
}