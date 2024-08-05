#Spawns Vulak if no boss mobs are up. 
my $check = 0;

sub EVENT_TICK {
  my $check =  $entity_list->GetMobByNpcTypeID(124077) and # Lady_Mirenilla
               $entity_list->GetMobByNpcTypeID(124076) and # Lady_Nevederia
               $entity_list->GetMobByNpcTypeID(124008) and # Lord_Feshlak
               $entity_list->GetMobByNpcTypeID(124010) and # Aaryonar
               $entity_list->GetMobByNpcTypeID(124074) and # Lord_Kreizenn
               $entity_list->GetMobByNpcTypeID(124017);    # Lord_Vyemm

  if ($check) {
    quest::debug("Spawning Vulak!");
    quest::spawn2(124155,0,0,-739.4,517.2,121,510); # Vulak`Aerr
    $npc->Depop(1); # Depop and start spawn timer.
  } else {
    quest::debug("Someone is still alive...");
  }
}