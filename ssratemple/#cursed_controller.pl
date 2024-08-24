sub EVENT_TICK {
  my $counter   = $npc->GetEntityVariable("counter") || 0;
  my $check     = !$entity_list->GetMobByNpcTypeID(162012) && # Taskmaster_Kavamezh (162012)
                  !$entity_list->GetMobByNpcTypeID(162021) && # Taskmaster_Keuzozh (162021)
                  !$entity_list->GetMobByNpcTypeID(162013) && # Taskmaster_Mikazha (162013)
                  !$entity_list->GetMobByNpcTypeID(162060) && # Taskmaster_Revan`Kezh (162060)
                  !$entity_list->GetMobByNpcTypeID(162024) && # Taskmaster_Vezhkah (162024)
                  !$entity_list->GetMobByNpcTypeID(162011) && # Taskmaster_Zerumaz (162011)
                  !$entity_list->GetMobByNpcTypeID(162059) && # Taskmaster_Zhe`Vozh (162059)
                  !$entity_list->GetMobByNpcTypeID(162258) && # #Rhozth_Ssrakezh (162258)
                  !$entity_list->GetMobByNpcTypeID(162089) && # #Rhozth_Ssravizh (162089)
                  !$entity_list->GetMobByNpcTypeID(162023);   # Warden_Mekuzh (162023)
    
  my $glyph     = !$entity_list->GetMobByNpcTypeID(162261);   # #a_glyph_covered_serpent (162261)

  my $spawn_x = -30;
  my $spawn_y = -10;
  my $spawn_z = -223;
  my $spawn_h = 130;

  if ($check && $glyph) {
    my $glyph_id  = quest::spawn2(162261, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h);
    my $glyph_npc = $entity_list->GetMobID($glyph_id);

    $glyph_npc->Shout("I will not be contained! My prison weakens, and I will claw my way back into this world, even if it dooms me!");
  }
}