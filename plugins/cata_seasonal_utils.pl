my $portable_hole = 199990;
my $award_aug     = 199995;


sub GetSeasonID 
{
    return quest::get_rule("Custom:Custom:EnableSeasonalCharacters");
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