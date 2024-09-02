# Summon Clockwork Banker
sub EVENT_SPELL_EFFECT_CLIENT {
    my $npc_id = quest::spawn2(772, 0, 0, $client->GetX(), $client->GetY(), $client->GetZ(), int(rand(512)) + 1);
    my $npc = $entity_list->GetMobByID($npc_id);
    $npc->TempName($client->GetCleanName() . '`s_Banker_Buddy');

    #Testing Value
    $npc->SetTimer("despawn", 840);
}