sub EVENT_DEATH_COMPLETE {
    quest::unique_spawn(105187,0,0,$x,$y,$z); # NPC: the_spirit_of_Rile

    my $killer = $entity_list->GetClientByID($killer_id);   

    if ($killer && int(rand(100)) == 0) {
        plugin::AddTitleFlag(202);
    }
}