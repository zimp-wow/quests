# Clockwork Banker

sub EVENT_SPAWN {
    $npc->SetTimer("depop", 15 * 60);
}

sub EVENT_TIMER {
    if ($timer eq "depop") {
        quest::debug("depop");
        $npc->Depop();
    }
}

sub EVENT_TICK {
    if (!$npc->GetEntityVariable("owner") || !$entity_list->GetClientByCharID($npc->GetEntityVariable("owner"))) {
        $npc->Depop();
    }
}