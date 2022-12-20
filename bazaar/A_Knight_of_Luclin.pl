sub EVENT_SAY {
    $key = $client->AccountID() . "-kunark-flag";
    $expansion = quest::get_data($key);
	
    if ($text=~/hail/i) {
        if ($expansion >= 14) {
            plugin::Whisper("EXCEPTIONAL! It looks like you are ready to join us in the battle for the future of Luclin! Good luck to you, hero!");
        }

        if ($expansion < 14) {
            plugin::Whisper("Ah... I see you have yet to unlock Luclin! You have two options. One is the route of the hero. The other, is the route of the collector. Unfortunately, little has been shared with me about what that entails hero... Come back later and I may know more.");
        }
        
        $progressionCount = 8;
		$progressCount = 0;
        $progressText = "";
        if (quest::get_data($client->AccountID() . "sky") > 0) {
            $progressCount++;
            $progressText .= "Yelinak in Skyshrine, ";
        }
        if (quest::get_data($client->AccountID() . "sleepers") > 0) {
            $progressCount++;
            $progressText .= "Tukaarak the Warder in Sleepers Tomb, ";
        }

        if (quest::get_data($client->AccountID() . "sle") > 0) {
            $progressCount++;
            $progressText .= "Nanzata the Warder in Sleepers Tomb, ";
        }

        if (quest::get_data($client->AccountID() . "slee") > 0) {
            $progressCount++;
            $progressText .= "Ventani the Warder in Sleepers Tomb, ";
        }

        if (quest::get_data($client->AccountID() . "sleep") > 0) {
            $progressCount++;
            $progressText .= "Hraasha the Warder in Sleepers Tomb, ";
        }

        if (quest::get_data($client->AccountID() . "wuo") > 0) {
            $progressCount++;
            $progressText .= "Wuoshi in Wakening Lands, ";
        }

        if (quest::get_data($client->AccountID() . "kla") > 0) {
            $progressCount++;
            $progressText .= "Klandicar in the Western Wastes, ";
        }

        if (quest::get_data($client->AccountID() . "zla") > 0) {
            $progressCount++;
            $progressText .= "Zlandicar in Dragon Necropolis, ";
        }

        if ($progressCount > 0) {
            $progressText = substr($progressText, 0, -2);
            plugin::Whisper("You have defeated $progressCount of $progressionCount targets: $progressText.");
        }
    }
}