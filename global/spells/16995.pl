# Summon (Clockwork) Resupply Agent
sub EVENT_SPELL_EFFECT_CLIENT {
    my $npc_id = quest::spawn2(771, 0, 0, $client->GetX(), $client->GetY(), $client->GetZ(), int(rand(512)) + 1);
    my $npc = $entity_list->GetMobByID($npc_id);
    $npc->TempName($client->GetCleanName() . '`s_Resupply_Agent');

    #Testing Value
    $npc->SetTimer("despawn", 840);
}