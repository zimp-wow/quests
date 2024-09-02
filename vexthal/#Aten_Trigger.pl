sub EVENT_TICK {
  my $counter   = $npc->GetEntityVariable("counter") || 0;
  my @named_mobs = (
    158013, # #Kaas_Thox_Xi_Ans_Dyek
    158014, # #Diabo_Xi_Va
    158015, # #Diabo_Xi_Xin
    158012, # #Diabo_Xi_Xin_Thall
    158008, # #Thall_Va_Kelun
    158010, # #Diabo_Xi_Va_Temariel
    158011, # #Thall_Xundraux_Diabo
    158009, # #Va_Xi_Aten_Ha_Ra
    158007  # #Kaas_Thox_Xi_Aten_Ha_Ra
  );

  # Check if all the named mobs are dead
  my $check = 1;
  foreach my $mob_id (@named_mobs) {
    if ($entity_list->GetMobByNpcTypeID($mob_id)) {
      $check = 0;
      last;
    }
  }

  if ($check && !$entity_list->GetMobByNpcTypeID(158096)) {
    my $ahr_id = quest::unique_spawn(158096,0,0,1417,0,236,384);
    my $ahr = $entity_list->GetMobByID($ahr_id);
    $ahr->Shout("Akelha'Ra Vius, Itraer xi Vyl, Tekar Xundrau!");
  } elsif ($counter % 100 == 0) {
    my @alive_mobs = grep { $entity_list->GetMobByNpcTypeID($_) } @named_mobs;
    if (@alive_mobs) {
      my $mob_id = quest::ChooseRandom(@alive_mobs);
      if (my $mob = $entity_list->GetMobByNpcTypeID($mob_id)) {
        my @messages = (
          "Vius Xi Akelha, Xeturis Tekar xi Xundrau!",
          "Kaas Thox Ruluor, Tekar Vius!",
          "Xeturi Xi Kaas, Vius Akelha Tekar!",
          "Aten Ha Ra Xundrau, Vius Xi Tekar!",
          "Ans Xundraux Tekar, Thox Vius xi Ruluor!",
          "Vius Kaas Xi, Xeturis Akelha!",
          "Xi Xiall Kaas, Ruluor Xundrau Vius!",
          "Vius Xi Kaas Thox, Xakra Tekar!",
          "Akelha’Ra Vius, Xi Xakra Tekar!",
          "Xundrau Xi Akelha, Xeturis Tekar!",
          "Kaas Thox Xi Vius, Xakra Ruluor!",
          "Vius Xi Akelha, Thall Xakra Tekar!",
          "Xeturi Thall Kaas, Xi Xundraux Vius!",
          "Ans Xundrau Vius, Akelha Xi Tekar!",
          "Kaas Thox Xi Vius, Xakra Akelha!",
          "Vius Xi Tekar, Xundrau Ruluor!",
          "Ans Xundraux Vius, Akelha Xakra!",
          "Tekar Xi Vius, Xundrau Akelha!",
          "Xundrau Akelha’Ra, Vius Tekar Xi!",
          "Xi Xundraux Vius, Akelha Tekar!"
        );
        $mob->Shout(quest::ChooseRandom(@messages));
      }
    }
  }

  $npc->SetEntityVariable("counter", $counter + 1);
}
