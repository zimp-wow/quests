sub EVENT_TICK {
  my $counter   = $npc->GetEntityVariable("counter") || 0;
  my $check     = !$entity_list->GetMobByNpcTypeID(158013) && # #Kaas_Thox_Xi_Ans_Dyek (158013)
                  !$entity_list->GetMobByNpcTypeID(158014) && # #Diabo_Xi_Va (158014)
                  !$entity_list->GetMobByNpcTypeID(158015) && # #Diabo_Xi_Xin (158015)
                  !$entity_list->GetMobByNpcTypeID(158012) && # #Diabo_Xi_Xin_Thall (158012)
                  !$entity_list->GetMobByNpcTypeID(158008) && # #Thall_Va_Kelun (158008)
                  !$entity_list->GetMobByNpcTypeID(158010) && # #Diabo_Xi_Va_Temariel (158010)
                  !$entity_list->GetMobByNpcTypeID(158011) && # #Thall_Xundraux_Diabo (158011)
                  !$entity_list->GetMobByNpcTypeID(158009) && # #Va_Xi_Aten_Ha_Ra (158009)
                  !$entity_list->GetMobByNpcTypeID(158007);   # #Kaas_Thox_Xi_Aten_Ha_Ra (158007)

  if ($check && !$entity_list->GetMobByNpcTypeID(158096)) {
    quest::unique_spawn(158096,0,0,1417,0,236,384);
    
    $npc->Shout("Shara'vok, Aten Ha Ra shol'koth. Kha'nok zhor, xorii valan!");
  }

  $npc->SetEntityVariable("counter", $counter + 1);
}