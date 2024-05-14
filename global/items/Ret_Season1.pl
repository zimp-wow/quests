sub EVENT_SCALE_CALC {
    my $participation_value = quest::get_data($client->AccountID() . "-season-1-participation") || 0;
    my $participation_max   = 100;

    if ($participation_value > $participation_max) {
        $participation_value = $participation_max;
    }

    my $value = $participation_value / $participation_max;

    $questitem->SetScale($value);
}