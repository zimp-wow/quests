sub EVENT_SPAWN {
  quest::settimer("appearance", 1);
}

sub EVENT_TIMER {
  quest::stoptimer("appearance");
  $npc->SetAppearance(1);
}

sub EVENT_SAY {
  if ($text=~/hail/i) {
    quest::say("Hello $name! I can disenchant a piece of Apocryphal or Rose Colored for you, returning it to it's original state. Please, only hand one item in at a time! And no, I will not undo the magic once it is done!");
  }  
}

sub EVENT_ITEM {
	plugin::return_items(\%itemcount);
}





