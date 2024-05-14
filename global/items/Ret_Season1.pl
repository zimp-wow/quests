sub EVENT_SCALE_CALC {
    my $participation_value = quest::get_data($client->AccountID() . "-season-1-participation") || 0;
    my $participation_max   = 50;

    if ($participation_value > $participation_max) {
        $participation_value = $participation_max;
    }

    my $value = $participation_value / $participation_max;

    quest::debug($value);

    $questitem->SetScale($value);
}