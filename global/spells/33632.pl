sub EVENT_SPELL_EFFECT_CLIENT {
    my $reward = GetRandomReward();

    if ($reward) {
        quest::summonfixeditem($reward);
    }
}

sub GetRandomReward() {
    my %my_rewards = (
        700010 => 3, # Red Elf Hat
        700011 => 3, # Green Elf Hat
        700012 => 3, # Glowing Nose
        700013 => 3, # Reindeer Antlers
        700015 => 3, # Top Hat
        700017 => 3, # Helper's Hat
        700018 => 3, # Striped Helper's Hat
        11010  => 60, # Elvish Hot Chocolate
        2828   => 2,  # Rimefrost Kopesh
        2829   => 2,  # Rimefrost Hammer
        2830   => 2,  # Rimefrost Naginata
        2854   => 2,  # Rimefrost Staff
        2855   => 2,  # Rimefrost Bow
        2856   => 2,  # Rimefrost Cestus
        2857   => 2,  # Rimefrost Shield
        4038   => 2,  # Rimefrost Dagger
        700016 => 1,  # Primitive Snow Golem Head
        2001800 => 1, # Decanter of Endless Hot Chocolate
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