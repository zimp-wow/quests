sub EVENT_SAY {
    $key = $client->AccountID() . "-kunark-flag";
    $expansion = quest::get_data($key);
    if ($text=~/hail/i) {
        if ($expansion >= 14) {
            plugin::Whisper("EXCEPTIONAL! It looks like you have unlocked progression to the Planes of Power!");
            return;
        }

        if ($expansion < 21) {
            plugin::Whisper("Ah... I see you have yet to unlock the Planes of Power! You have two options. One is the route of the hero. The other, is the route of the collector. Unfortunately, little has been shared with me about what that entails hero... Come back later and I may know more.");
        }
        
        $progressionCount = 0;
        $progressText = "";
        if (quest::get_data($client->AccountID() . "acr") > 0) {
            $progressCount++;
            $progressText += "Khati Sha the Twisted in Acrylia Caverns, ";
        }

        if (quest::get_data($client->AccountID() . "griegs") > 0) {
            $progressCount++;
            $progressText += "Grieg Veneficus in Grieg's End, ";
        }

        if (quest::get_data($client->AccountID() . "deep") > 0) {
            $progressCount++;
            $progressText += "Thought Horror Overfiend in The Deep, ";
        }

        if (quest::get_data($client->AccountID() . "vext") > 0) {
            $progressCount++;
            $progressText += "Planar Elemental in Vex Thal, ";
        }

        if (quest::get_data($client->AccountID() . "vextha") > 0) {
            $progressCount++;
            $progressText += "Planar Keymaster in Vex Thal, ";
        }

        if (quest::get_data($client->AccountID() . "vex") > 0) {
            $progressCount++;
            $progressText += "Planar Projection in Vex Thal, ";
        }

        if (quest::get_data($client->AccountID() . "vexthal") > 0) {
            $progressCount++;
            $progressText += "Planar Visage in the Vex Thal, ";
        }

        if ($progressionCount > 0 && $progressionCount <= 7) {
            $progressText = substr($progressText, 0 -2);
            plugin::Whisper("You have defeated $progressionCount of $progressionCount targets: $progressText.");
        }
    }
}