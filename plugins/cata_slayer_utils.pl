sub ProcessSlayerCredit {
    my ($client, $npc, $entity_list) = @_;

    # New work
    my $new_kill_count_key = $client->AccountID() . '-' . $npc->GetRace() . '-kill-count';
    my $new_creature_count = (quest::get_data($new_kill_count_key) || 0) + 1; 
    quest::set_data($new_kill_count_key, $new_creature_count);

    my %creature_data = (
        'goblin' => {
            race_ids  => [40, 137, 277, 369, 433],
            title_flags => [501, 502, 503, 504, 505],
        },
        'elemental' => {
            race_ids  => [75, 209, 210, 211, 212, 475, 476, 477, 478],
            title_flags => [506, 507, 508, 509, 510],
        },
            'humans' => {
            race_ids    => [1, 55, 341, 566, 44, 71],
            title_flags => [511, 512, 513, 514, 515],
        },
        'half_elves' => {
            race_ids    => [7],
            title_flags => [516, 517, 518, 519, 520],
        },
        'wood_elves' => {
            race_ids    => [4, 112],
            title_flags => [521, 522, 523, 524, 525],
        },
        'high_elves' => {
            race_ids    => [5, 106],
            title_flags => [526, 527, 528, 529, 530],
        },
        'dark_elves' => {
            race_ids    => [6, 339],
            title_flags => [531, 532, 533, 534, 535],
        },
        'barbarians' => {
            race_ids    => [2],
            title_flags => [536, 537, 538, 539, 540],
        },
        'halflings' => {
            race_ids    => [11],
            title_flags => [541, 542, 543, 544, 545],
        },
        'gnomes' => {
            race_ids    => [2, 338],
            title_flags => [546, 547, 548, 549, 550],
        },
        'dwarves' => {
            race_ids    => [8, 94],
            title_flags => [551, 552, 553, 554, 555],
        },
        'vah_shir' => {
            race_ids    => [183, 645],
            title_flags => [556, 557, 558, 559, 560],
        },
        'iksar' => {
            race_ids    => [128, 139],
            title_flags => [561, 562, 563, 564, 565],
        },
        'drakkin' => {
            race_ids    => [0],
            title_flags => [566, 567, 568, 569, 570],
        },
        'trolls' => {
            race_ids    => [9, 331],
            title_flags => [571, 572, 573, 574, 575],
        },
        'ogres' => {
            race_ids    => [10, 340, 624, 325],
            title_flags => [576, 577, 578, 579, 580],
        },
        'orcs' => {
            race_ids    => [54, 361, 366, 458, 579],
            title_flags => [581, 582, 583, 584, 585],
        },
        'gnolls' => {
            race_ids    => [39, 524, 617],
            title_flags => [586, 587, 588, 589, 590],
        },
        'frogloks' => {
            race_ids    => [26, 27, 102, 330],
            title_flags => [591, 592, 593, 594, 595],
        },
        'constructs' => {
            race_ids    => [17, 160, 164, 248, 374, 387, 405, 491], 
            title_flags => [596, 597, 598, 599, 600],
        },
        'aviaks' => {
            race_ids    => [13, 558], 
            title_flags => [601, 602, 603, 604, 605],
        },
        'zombies' => {
            race_ids    => [70, 471],
            title_flags => [606, 607, 608, 609, 610],
        },
        'skeletons' => {
            race_ids    => [60, 122, 155, 161, 234, 349, 367, 606],
            title_flags => [611, 612, 613, 614, 615],
        },
        'drakes' => {
            race_ids    => [89, 154, 430, 432],
            title_flags => [616, 617, 618, 619, 620],
        },
        'dragons' => {
            race_ids    => [49, 165, 184, 192, 195, 196, 198, 435, 437, 438, 452, 530],
            title_flags => [621, 622, 623, 624, 625],
        },
        'wyverns' => {
            race_ids    => [157, 581], 
            title_flags => [626, 627, 628, 629, 630],
        },
        'wurms' => {
            race_ids    => [158, 613],
            title_flags => [631, 632, 633, 634, 635],
        },
        'ghosts' => {
            race_ids    => [117, 118, 196, 334, 371, 587, 588, 605],
            title_flags => [636, 637, 638, 639, 640],
        },
        'bears' => {
            race_ids    => [43, 206, 305],
            title_flags => [641, 642, 643, 644, 645],
        },
        'wolves' => {
            race_ids    => [14, 42, 120, 232, 388, 454, 482],
            title_flags => [646, 647, 648, 649, 650],
        },
        'giants' => {
            race_ids    => [18, 140, 188, 189, 453, 490, 523, 526, 626, 306, 307, 308, 309, 310, 411],
            title_flags => [651, 652, 653, 654, 655],
        },
    );

    my @tier_counts = (500, 5000, 10000, 50000, 1000000);

    foreach my $creature_type (keys %creature_data) {
        my $data = $creature_data{$creature_type};
        my $kill_count_key = $client->AccountID() . '-' . $creature_type . '-kill-count';

        if (grep { $_ == $npc->GetRace() } @{$data->{race_ids}}) {
            my $creature_count = quest::get_data($kill_count_key) || 0;
            $creature_count++;

            for (my $i = 0; $i < @tier_counts; $i++) {
                if ($creature_count >= $tier_counts[$i]) {
                    plugin::AddTitleFlag($data->{title_flags}[$i]);
                }
            }

            quest::set_data($kill_count_key, $creature_count);            
            last;
        }
    }
}