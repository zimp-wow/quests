sub EVENT_TICK {
    my $phara_dar = $entity_list->GetNPCByNPCTypeID(108048);
    my @pd_hatelist = $phara_dar->GetHateList();
    if ($phara_dar && @pd_hatelist) {
        my $rand_hater = $pd_hatelist[$int(rand(@pd_hatelist))];
        if ($rand_hater) {
            $npc->AddToHateList($rand_hater, 1000);
        }

        foreach my $hle (@pd_hatelist) { # For each value in the array, do something
            if ($hle) {
                $npc->AddToHateList($hle->GetEnt(), 1);
            }
        }
    }
}