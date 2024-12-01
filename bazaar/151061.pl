my %deities = (
    201 => 'Bertoxxulous',
    202 => 'Brell Sirilis',
    203 => 'Cazic Thule',
    204 => 'Erollisi Marr',
    205 => 'Bristlebane',
    206 => 'Innoruuk',
    207 => 'Karana',
    208 => 'Mithaniel Marr',
    209 => 'Prexus',
    210 => 'Quellious',
    211 => 'Rallos Zek',
    212 => 'Rodcet Nife',
    213 => 'Solusek Ro',
    214 => 'The Tribunal',
    215 => 'Tunare',
    216 => 'Veeshan',
    396 => 'Agnostic',
);

my %races = (
    1   => 'Human',
    2   => 'Barbarian',
    3   => 'Erudite',
    4   => 'Wood Elf',
    5   => 'High Elf',
    6   => 'Dark Elf',
    7   => 'Half Elf',
    8   => 'Dwarf',
    9   => 'Troll',
    10  => 'Ogre',
    11  => 'Halfling',
    12  => 'Gnome',
    128 => 'Iksar',
    130 => 'Vah Shir',
    330 => 'Froglok',
    522 => 'Drakkin',
);

my $race_change_cost = 10;
my $sex_change_cost  = 10;
my $name_change_cost = 10;
my $gods_change_cost = 10;
my $pet_name_reset_cost = 5;

sub EVENT_SAY {
    my $sex_word;
    if ($client->GetGender()) {
        $sex_word = "masculinity";
    } else {
        $sex_word = "femininity";
    }

    if ($text =~ /hail/i) {
        quest::say("Greetings, $name. Do you seek perfection? Are you [". quest::saylink("unhappy with your form", 1) ."]? 
                    Are you interested in embracing [". quest::saylink($sex_word, 1) ."]? 
                    Would you like to [".quest::saylink("worship a new deity", 1)."]?
                    Do you wish to [".quest::saylink("reset pet names", 1)."]?");
    }
    elsif ($text =~ /worship a new deity/i) {
        deity_change_intro();
    }
    elsif ($text =~ /^select_deity_(\d+)$/i) {
        deity_change_select($1);
    }
    elsif ($text =~ /^confirm_deity_(\d+)$/i) {
        deity_change_confirm($1);
    }
    elsif ($text =~ /unhappy with your form/i) {
        race_change_intro();
    }
    elsif ($text =~ /^select_race_(\d+)$/i) {
        race_change_select($1);
    }
    elsif ($text =~ /^confirm_race_(\d+)$/i) {
        race_change_confirm($1);
    }
    elsif ($text =~ /$sex_word/i) {
        gender_change_intro();
    }
    elsif ($text =~ /^confirm_gender_(\d)$/i) {
        gender_change_confirm($1);
    }
    elsif ($text =~ /reset pet names/i) {
        pet_name_reset_intro();
    }
    # Handle pet name selection (no explicit key names like bear_name_1)
    elsif ($text =~ /^reset_pet_name_(\w+_\d+)$/i) {   # Capture the full key (e.g., bear_name_1)
        pet_name_reset_select($1);  # Pass the captured key directly (e.g., bear_name_1)
    }
    # Handle pet name reset confirmation
    elsif ($text =~ /^confirm_pet_name_reset_(\w+_\d+)$/i) {   # Capture the full key (e.g., bear_name_1)
        pet_name_reset_confirm($1);  # Pass the captured key directly (e.g., bear_name_1)
    }
}

sub race_change_intro {
    quest::say("Just so. If you can properly anchor your memories - perhaps with " . plugin::num2en($race_change_cost) . " [" . plugin::EOMLink() . "], I can adjust your form.");

    if (plugin::GetEOM($client) >= $race_change_cost) {
        plugin::YellowText( "WARNING: You will disconnect immediately upon selecting a new race.");
        plugin::YellowText( "WARNING: You may select illegal races for your class. No support will be provided for any problems caused as a result.");
        
        my $race_list = "";
    foreach my $id (sort { $a <=> $b } keys %races) {
        if ($id == $client->GetRace()) {
            next;
        }
        $race_list .= "[".quest::saylink("select_race_$id", 1, $races{$id})."] ";
    }
    plugin::YellowText("- Select a new Race -");
    plugin::YellowText($race_list);
    } else {
        quest::say("You do not have sufficient Echoes of Memory to initiate a race change.");
    }
}

sub race_change_select {
    my ($race_id) = @_;

    if (exists $races{$race_id} && $client->GetRace() != $race_id) {
        my $race_name = $races{$race_id};
        quest::say("You have chosen to change your form to $race_name. Are you [".quest::saylink("confirm_race_$race_id", 1, "certain")."]?");
    }
}

sub race_change_confirm {
    my ($race_id) = @_;

    if (plugin::SpendEOM($client, $race_change_cost)) {
        if ($client->GetRace() != $race_id && exists $races{$race_id}) {
            quest::permarace($race_id);
            quest::say("Your form has been altered, brave adventurer. You are now $races{$race_id}.");
        } else {
            $client->Message(13, "An error occurred. Unable to change race to ID $race_id.");
        }
    } else {
        quest::say("Sadly, $name, you do not have sufficient Echoes of Memory to properly anchor yourself for this change. Perhaps you will return later.");
    }
}

# Deity change functions
sub deity_change_intro {
    my $reply = "I see that you worship " . $client->GetDeityName() . ", adventurer. Has your faith changed? Would you like to declare a new patron?";
    if ($client->GetDeityBitmask() == 1) { # Agnostic
        $reply = "I see that you walk the path of the non-believer, adventurer. Have your travels convinced you of the power of the Gods? Would you declare a patron?";
    }

    $reply .= " With a mere " . plugin::num2en($gods_change_cost) . " [" . plugin::EOMLink() . "], I can formalize your new allegiance.";

    quest::say($reply);

    my $deity_list = "";
    foreach my $id (sort { $a <=> $b } keys %deities) {
        if ($id == $client->GetDeity()) {
            next;
        }
        $deity_list .= "[".quest::saylink("select_deity_$id", 1, $deities{$id})."] ";            
    }

    plugin::YellowText("- Select a new Deity -");
    plugin::YellowText($deity_list);
}

sub deity_change_select {
    my ($deity_id) = @_;

    if (exists $deities{$deity_id} && $client->GetDeity() != $deity_id) {
        my $deity_name = $deities{$deity_id};
        quest::say("You have chosen to declare your allegiance to $deity_name. Are you [".quest::saylink("confirm_deity_$deity_id", 1, "certain")."]?");
    }
}

sub deity_change_confirm {
    my ($deity_id) = @_;

    if (plugin::SpendEOM($client, $gods_change_cost)) {
        $client->SetDeity($deity_id);
        quest::say("Your patron has been declared, worshipper of ".$client->GetDeityName().".");
    } else {
        plugin::NPCTell("You do not have sufficient Echo of Memory to confirm a new Deity.");
    }
}

# Gender change functions
sub gender_change_intro {
    my $gender_message = "If you seek to embrace your " . ($client->GetGender() ? "femininity" : "masculinity") . ", I can assist. For a mere " . plugin::num2en($sex_change_cost) . " [" . plugin::EOMLink() . "], I can adjust your form.";
    if (plugin::GetEOM($client) >= $sex_change_cost) {
        my $new_gender = $client->GetGender() ? 0 : 1;
        $gender_message .= " You have chosen to change your form to " . ($new_gender ? "Female" : "Male") . ". Are you [".quest::saylink("confirm_gender_$new_gender", 1, "certain")."]?";
    } else {
        $gender_message .= " You do not have sufficient Echoes of Memory to initiate a gender change. Perhaps you will return later.";
    }
    quest::say($gender_message);
}

sub gender_change_confirm {
    my ($gender_id) = @_;

    if (plugin::SpendEOM($client, $sex_change_cost)) {
        if ($client->GetGender() != $gender_id) {
            quest::permagender($gender_id);
            quest::say("Your form has been altered, brave adventurer. You are now " . ($gender_id ? "Female" : "Male") . ".");
        } else {
            quest::say("You are already of the chosen gender, no change is needed.");
        }
    } else {
        quest::say("Sadly, $name, you do not have sufficient Echoes of Memory to properly anchor yourself for this change. Perhaps you will return later.");
    }
}

sub pet_name_reset_intro {
    quest::say("If your loyal companions' names have lost their charm, I can help you reset them. For a mere " . plugin::num2en($pet_name_reset_cost) . " [" . plugin::EOMLink() . "], I can restore their original titles. Please select a pet name to reset.");
    
    my $pet_names_list = "";
    foreach my $prefix ('bear_name', 'skeleton_name', 'warder_name', 'spirit_name', 'spectre_name', 
                        'air_elemental_name', 'water_elemental_name', 'fire_elemental_name', 'earth_elemental_name') {
        foreach my $num (1..10) {
            my $key = "${prefix}_${num}";
            my $value = $client->GetBucket($key);
            if (defined $value && $value ne '') {
                $pet_names_list .= "[" . quest::saylink("reset_pet_name_$key", 1, "$value") . "] ";
            }
        }
    }

    plugin::YellowText("- Select a Pet Name to Reset -");
    plugin::YellowText($pet_names_list);
}

sub pet_name_reset_select {
    my ($pet_key) = @_;

    my $pet_name = $client->GetBucket($pet_key);

    quest::say("You have chosen to reset the name for '$pet_name'. Would you like to proceed with this reset? [".quest::saylink("confirm_pet_name_reset_$pet_key", 1, "Confirm")."]");
}

sub pet_name_reset_confirm {
    my ($pet_key) = @_;

    my $pet_name = $client->GetBucket($pet_key);

    if (plugin::SpendEOM($client, $pet_name_reset_cost)) {
        $client->DeleteBucket($pet_key);
        quest::say("The pet previously named '$pet_name' is now free to choose a new name.");
    } else {
        quest::say("You do not have sufficient Echoes of Memory to reset the pet name '$pet_name'.");
    }
}
