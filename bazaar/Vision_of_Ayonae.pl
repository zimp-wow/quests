sub EVENT_SAY {
    if ($text=~/hail/i) {
        if (plugin::GetClassesCount($client) == 1) {
            plugin::NPCTell("Mortal. Do you wish to throw yourself upon the [whims of blind fate]?");
        } else {
            plugin::NPCTell("Mortal. You are unsuitable, your fate has already been tainted by your pathetic free will. Begone.");
        }
        return;
    }

    if ($text=~/blind fate/i) {
        if (plugin::GetClassesCount($client) == 1) {
            plugin::NPCTell("You will be put upon an irrevocable path, impossible to predict. Are you certain that you wish to do this?");
            plugin::YellowText("WARNING: If you [".quest::saylink('randomize_me_bitch', 1, 'continue')."], you will be assigned two random classes. This decision cannot be reversed.");
        } else {
            plugin::NPCTell("Mortal. You are unsuitable, your fate has already been tainted by your pathetic free will. Begone.");
        }
        return;
    }

    if ($text=~/randomize_me_bitch/i) {
        plugin::WorldAnnounce("$name has cast themselves upon the whims of blind fate, choosing random classes.");    
        if (plugin::GetClassesCount($client) == 1) {
            my @all_classes = (1..16);

            # Continue until the client has 3 unique classes
            while (plugin::GetClassesCount($client) < 3) {
                my $random_class = $all_classes[int(rand(@all_classes))];
                
                # Check if the client already has this class
                if (!plugin::HasClass($client, $random_class)) {
                    plugin::AddClass($random_class, $client);
                }
            }

            plugin::NPCTell("Your fate is sealed, go and walk it.");
        } else {
            plugin::NPCTell("Mortal. You are unsuitable, your fate has already been tainted by your pathetic free will. Begone.");
        }
        return;
    }
}
