sub EVENT_SPAWN {
    quest::settimer(1, 1200);
}

sub EVENT_SAY {
    my $key = $client->AccountID() . "-kunark-flag";
    my $expansion = quest::get_data($key);

    my $akhkey = $client->AccountID() . "akh";

    if ($text =~ /hail/i) {
        if (quest::get_data($akhkey) == "") {
            quest::set_data($akhkey, 1);
            quest::say("The Planes of Power need your help! Hurry along!");
            $client->Message(4, "You have gained an expansion flag!");

            quest::set_data($key, quest::get_data($key) + 1);
        } else {
            quest::say("I have already given you my blessing! Would you like to check your [expansions] unlocked?");
        }
    }

    if ($text =~ /Expansions/i) {
        if ($expansion == 0) {
            quest::say("You don't have any expansions unlocked!");
        } elseif ($expansion == 1) {
            quest::say("You don't have any expansions unlocked!");
        } elseif ($expansion >= 2 && $expansion < 6) {
            quest::say("Expansions Unlocked: Kunark");
        } elseif ($expansion >= 6 && $expansion < 14) {
            quest::say("Expansions Unlocked: Velious");
        } elseif ($expansion >= 14 && $expansion < 19) {
            quest::say("Expansions Unlocked: Luclin");
        } elseif ($expansion >= 19) {
            quest::say("Expansions Unlocked: Planes of Power");
        }
    }

    # Set new flag system data
    set_subflag($client, 'PoP', 'The Insanity Crawler', 1);
}

sub EVENT_TIMER {
    quest::depop();
}
