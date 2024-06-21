sub EVENT_DEATH_COMPLETE {
    plugin::handle_death($npc, $x, $y, $z, $entity_list);

    my $killer = $entity_list->GetClientByID($killer_id);   

    if ($killer) {
        plugin::AddTitleFlag(200);
    }
}