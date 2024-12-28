sub EVENT_DEATH_COMPLETE {
    quest::debug("WTF");
    plugin::handle_death($npc, $x, $y, $z, $entity_list);

    my $killer = $entity_list->GetClientByID($killer_id);   

    if ($killer && int(rand(100)) == 0) {
        plugin::AddTitleFlag(200);
    }
}