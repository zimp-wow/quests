sub EVENT_SAY {
    $key = $client->AccountID() . "-kunark-flag";
    $expansion = quest::get_data($key);
	
    if ($text=~/hail/i) {
        if ($expansion >= 19) {
            plugin::Whisper("EXCEPTIONAL! It looks like you are ready to join us in the battle for the future of Planes of Power! Good luck to you, hero!");
        }

        if ($expansion < 19) {
            plugin::Whisper("Ah... I see you have yet to unlock the Planes of Power. Your only option is the route of the [hero].");
    
        }
    }
            if (($text =~/hero/i) && ($expansion <19)){
            plugin::Whisper("To enter the Planes of Power, you must slay the Crawling Beast, the Master of End, the Creature of Nightmares, the Giver of Hate, and the Mighty Emperor.");
            $progressionCount = 5;
		    $progressCount = 0;
            $progressText = "";
            if (quest::get_data($client->AccountID() . "deep") > 0) {
            $progressCount++;
            $progressText .= "Thought Horror Fiend in the Deep, ";
            }

            if (quest::get_data($client->AccountID() . "akh") > 0) {
            $progressCount++;
            $progressText .= "The Insanity Crawler in Akheva Ruins, ";
            }

            if (quest::get_data($client->AccountID() . "griegs") > 0) {
            $progressCount++;
            $progressText .= "Greg Veneficus in Grieg's End, ";
            }

            if (quest::get_data($client->AccountID() . "ssraone") > 0) {
            $progressCount++;
            $progressText .= "Xerkizh the Creator in Ssraeshza Temple, ";
            }

            if (quest::get_data($client->AccountID() . "ssratwo") > 0) {
            $progressCount++;
            $progressText .= "Emperor Ssraeshza in Ssraeshza Temple, ";
            }

            if ($progressCount > 0) {
            $progressText = substr($progressText, 0, -2);
            plugin::Whisper("You have defeated $progressCount of $progressionCount targets: $progressText.");
            }
        }
  }

