sub EVENT_SAY {
    if ($text=~/hail/i) {
        quest::say("Greetings, $name. I am an envoy from the ESS - Elvish Security Services. We are here to collect a number of [items] which were lost as a result of the recent dimensional breach.");
    } 

    if ($text=~/items/i) {
        quest::say("Indeed. A number of gifts destined for the children of our world were lost in the breach. We are here to collect them and return them to their rightful place. 
                    These gift boxes have been seized by numerous creatures in your world, and I've heard rumors that the shady looking halfling in the corner of the Bazaar may have also
                    claimed a number of them. We are offering a reward for the return of these items, and the individuals who bring us the largest quantity of them before we depart may
                    recieve an additional reward!");
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 2827 => 1)) {
        quest::say("Thank you for returning this item, $name. We will be sure to return it to its rightful place. Please accept this reward for your efforts.");
        my $reward = GetRandomReward();
        if ($reward) {
            quest::summonfixeditem($reward);
        }

        my $account_key 	= $client->AccountID() . "-ess-items-returned";
        quest::set_data($account_key, (quest::get_data($account_key) || 0) + 1);
    }
}

sub GetRandomReward {
    my %my_rewards = (
        4040 => 99, 
        2004041 => 1, 
    );

    my $total_weight = 0;
    foreach my $weight (values %my_rewards) {
        $total_weight += $weight;
    }

    my $rand = int(rand($total_weight));

    my $sum = 0;
    foreach my $key (keys %my_rewards) {
        $sum += $my_rewards{$key};
        if ($rand < $sum) {
            return $key;
        }
    }
    return 0;
}
