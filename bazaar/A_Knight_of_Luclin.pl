sub EVENT_SAY {
    $key = $client->AccountID() . "-kunark-flag";
    $expansion = quest::get_data($key);
	
    if ($text=~/hail/i) {
        if ($expansion >= 14) {
            plugin::Whisper("EXCEPTIONAL! It looks like you are ready to join us in the battle for the future of Luclin! Good luck to you, hero!");
        }

        if ($expansion < 14) {
            plugin::Whisper("Ah... I see you have yet to unlock Luclin! You have two options. One is the route of the [hero]. The other, is the route of the [collector].");
    
        }
    }
            if (($text =~/hero/i) && ($expansion <14)){
            plugin::Whisper("Refinement by fire is the only way we will be ready for Aten Ha Ra. Slay the mighty dragons of Velious.");
            $progressionCount = 8;
		        $progressCount = 0;
            $progressText = "";
            if (quest::get_data($client->AccountID() . "sky")) {
            $progressCount++;
            $progressText .= "Yelinak in Skyshrine, ";
            }

            if (quest::get_data($client->AccountID() . "sleepers")) {
            $progressCount++;
            $progressText .= "Tukaarak the Warder in Sleepers Tomb, ";
            }

            if (quest::get_data($client->AccountID() . "sle")) {
            $progressCount++;
            $progressText .= "Nanzata the Warder in Sleepers Tomb, ";
            }

            if (quest::get_data($client->AccountID() . "slee")) {
            $progressCount++;
            $progressText .= "Ventani the Warder in Sleepers Tomb, ";
            }

            if (quest::get_data($client->AccountID() . "sleep")) {
            $progressCount++;
            $progressText .= "Hraasha the Warder in Sleepers Tomb, ";
            }

            if (quest::get_data($client->AccountID() . "wuo")) {
            $progressCount++;
            $progressText .= "Wuoshi in Wakening Lands, ";
            }

            if (quest::get_data($client->AccountID() . "kla")) {
            $progressCount++;
            $progressText .= "Klandicar in the Western Wastes, ";
            }

            if (quest::get_data($client->AccountID() . "zla")) {
            $progressCount++;
            $progressText .= "Zlandicar in Dragon Necropolis, ";
            }

            if ($progressCount) {
            $progressText = substr($progressText, 0, -2);
            plugin::Whisper("You have defeated $progressCount of $progressionCount targets: $progressText.");
            }
        }
        

     if (($text =~/collector/i) && ($expansion <14)){
      plugin::Whisper("You are one of patience, I see. All you need to do is bring me an Apocryphal Stronghorn's Horn, an Apocryphal Shackle of Auctoritias, an Apocryphal Sword of Pain, and an Apocryphal Siren Hair Earring. This will grant you three Apocryphal tokens. When one is turned in to me, that hero will be granted access to Luclin.");
      return;
      }
    
  }

sub EVENT_ITEM {
  $key = $client->AccountID() . "-kunark-flag";
  $expansion = quest::get_data($key);

  if ($expansion < 20){
    if (plugin::check_handin_fixed(\%itemcount, 2027200 => 1, 2004189 => 1, 2025319 => 1, 2024741 => 1)) {
      plugin::Whisper("Here are three tokens. Hand one back to me for your flag!");
      quest::summonfixeditem(2019102);
      quest::summonfixeditem(2019102);
      quest::summonfixeditem(2019102);

      quest::ding();
      quest::exp(1000000);
    }

    if ($expansion >= 6){
    if (plugin::check_handin_fixed(\%itemcount, 2019102 => 1)) {
      plugin::Whisper("Beware of the evils that lurk Luclin $name!");
      quest::ding();
      quest::set_data($client->AccountID() . "sky", 1);
      quest::set_data($client->AccountID() . "sle", 1);
      quest::set_data($client->AccountID() . "slee", 1);
      quest::set_data($client->AccountID() . "sleep", 1);
      quest::set_data($client->AccountID() . "sleepers", 1);
      quest::set_data($client->AccountID() . "zla", 1);
      quest::set_data($client->AccountID() . "kla", 1);
      quest::set_data($client->AccountID() . "wuo", 1);

      quest::set_data($key, 14);
    }       
  }

  plugin::return_items(\%itemcount);
  plugin::CheckCashPayment(0, $copper, $silver, $gold, $platinum);

}
}