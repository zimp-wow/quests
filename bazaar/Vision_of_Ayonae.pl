
my $remove_class_cost = 0;
my $remove_class_lockout = 1;

sub EVENT_SAY {
    if (!plugin::MultiClassingEnabled()) {
        return;
    }

    if ($text=~/hail/i) {
        if (plugin::GetClassesCount($client) <= 1) {
            plugin::NPCTell("Mortal. Do you wish to throw yourself upon the [whims of blind fate]?");
        } else {
            plugin::NPCTell("Mortal. You are unsuitable, your fate has already been tainted by your pathetic free will. Begone, unless you would have me [reforge your path]");
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

    if ($text=~/reforge your path/i) {
        if (plugin::GetClassesCount > 1) {
            my $classes_string =plugin::GetClassLinkString();

            plugin::NPCTell("Which class would you have me strip from you; $classes_string?");
        }
    }

    if ($text =~ /^del_class_(\d+)$/i) {
        my $class_id = $1; 

        if ($client->HasExpeditionLockout("Class Removal Lockout", "")) {
            plugin::YellowText("You cannot remove a class at this time, you still are under cooldown from a previous class removal.");
            return 0;
        }

        if (plugin::HasClass($client, $class_id)) {
            if (plugin::GetEOM($client) >= $remove_class_cost) {
                 plugin::YellowText("It will cost $remove_class_cost Echo of Memory in order to remove a class. Additionally, 
                                    there is a $remove_class_lockout-day cooldown after removing a class before you can remove another. Would you
                                    like to ".quest::saylink("proceed_$class_id", 0, "Proceed")."?");
            
            } else {
                 plugin::YellowText("It costs $remove_class_cost Echo of Memory in order to remove a class. You can obtain
                                    Echo of Memory through contributions to the sever or purchase from other players in the Bazaar.");
            }           
        }
    }

    if ($text =~ /^proceed_(\d+)$/i) {
        my $class_id = $1; 
        if (plugin::SpendEOM($client, $remove_class_cost) && plugin::HasClass($client, $class_id)) {
            plugin::RemoveClass($class_id, $client);
            $client->AddExpeditionLockout("Class Removal Lockout", "", $remove_class_lockout * 24 * 60 * 60);
        }
    }   

    if ($text =~ /unmem/i) {
        for ($i = 0; $i < 12; $i++) {
            $client->UnmemSpell($i, 1);
        }
    }
}
