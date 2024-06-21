sub EVENT_AGGRO {
  my $guards = $entity_list->GetMobByNpcTypeID(124157);

  if ($guards) {
  my $guards = $guards->CastToNPC();
  $guards->AddToHateList($client, 1);
}
 }

sub EVENT_DEATH_COMPLETE {
    my $killer = $entity_list->GetClientByID($killer_id);   

    if ($killer && plugin::IsSeasonal($killer)) {
        plugin::AddTitleFlag(205);
    }
}