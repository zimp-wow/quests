#Spawns Vulak if no boss mobs are up. 
my $check = 0;

sub EVENT_TICK {
  my $check =  !$entity_list->GetMobByNpcTypeID(124077) && # Lady_Mirenilla
               !$entity_list->GetMobByNpcTypeID(124076) && # Lady_Nevederia
               !$entity_list->GetMobByNpcTypeID(124008) && # Lord_Feshlak
               !$entity_list->GetMobByNpcTypeID(124010) && # Aaryonar
               !$entity_list->GetMobByNpcTypeID(124074) && # Lord_Kreizenn
               !$entity_list->GetMobByNpcTypeID(124017);   # Lord_Vyemm

  if ($check) {
    quest::debug("Spawning Vulak!");
    quest::spawn2(124155, 0, 0, -739.4, 517.2, 121, 510); # Vulak`Aerr
    $npc->Depop(1); # Depop and start spawn timer.
  } else {
    quest::debug("Someone is still alive...");
    quest::debug("Lady_Mirenilla: " . (defined $entity_list->GetMobByNpcTypeID(124077) ? "Alive" : "Dead"));
    quest::debug("Lady_Nevederia: " . (defined $entity_list->GetMobByNpcTypeID(124076) ? "Alive" : "Dead"));
    quest::debug("Lord_Feshlak: " . (defined $entity_list->GetMobByNpcTypeID(124008) ? "Alive" : "Dead"));
    quest::debug("Aaryonar: " . (defined $entity_list->GetMobByNpcTypeID(124010) ? "Alive" : "Dead"));
    quest::debug("Lord_Kreizenn: " . (defined $entity_list->GetMobByNpcTypeID(124074) ? "Alive" : "Dead"));
    quest::debug("Lord_Vyemm: " . (defined $entity_list->GetMobByNpcTypeID(124017) ? "Alive" : "Dead"));
  }
}
