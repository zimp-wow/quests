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
my $pet_name_reset_cost = 25;

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
                    Do you wish to [".quest::saylink("rename your pets", 1)."]?");
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
    elsif ($text =~ /rename your pets/i) {
        pet_name_change_intro();
    }
    elsif ($text =~ /^change_pet_name_(\d+)$/i) {   # Matches class_id as digits
        quest::debug("Captured class_id: $1");
        pet_name_change_select($1);  # Pass the captured class_id
    }
    elsif ($text =~ /^confirm_pet_name_change_(\d+)$/i) {  # Matches class_id as digits
        quest::debug("Captured class_id for confirmation: $1");
        pet_name_change_confirm($1);  # Pass the captured class_id
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

sub pet_name_change_intro {
    quest::say("Do you want to rename your loyal companion? I can help you assign a new name for any of your pets. Just choose the class you'd like to change the pet name for, and I will assist you. For a mere " . plugin::num2en($pet_name_reset_cost) . " [" . plugin::EOMLink() . "], you can give your pet a brand-new identity!");

    if ($client->IsPetNameChangeAllowed()) {
        plugin::YellowText("You currently have a pet name change pending. Please complete that with /changepetname before selecting another pet name to change.");
        return;
    }

    my $class_selection_links = GetClassLinkString();

    plugin::YellowText("- Select a Class to Change Pet Name -");
    plugin::YellowText($class_selection_links);
}

sub pet_name_change_select {
    my ($class_id) = @_;

    my %class_map = plugin::GetClassMap();
    my $class_name = $class_map{$class_id};

    quest::say("Ah, you seek to bestow a new identity upon your companion, the guardian of your '$class_name' craft. A noble choice indeed! For only " . plugin::num2en($pet_name_reset_cost) . " [" . plugin::EOMLink() . "], I can channel the forces of transformation. Are you ready to proceed? [" . quest::saylink("confirm_pet_name_change_$class_id", 1, "Yes, let us begin!") . "]");
}

sub pet_name_change_confirm {
    my ($class_id) = @_;

    my %class_map = plugin::GetClassMap();
    my $class_name = $class_map{$class_id};

    if (plugin::SpendEOM($client, $pet_name_reset_cost)) {
        quest::say("The currents of magic shift, and the veil of change is drawn back. Your companion, loyal to the ways of the '$class_name', is now ready to take on a new name.");
        $client->ChangePetName($class_id);  # Open the pet name change dialogue
        plugin::YellowText("Your pet is ready for renaming. Speak its new name when the time comes.");
    } else {
        quest::say("The Echoes of Memory slip through your fingers. Gather more, and return to me when you are ready to embrace the change.");
    }
}

sub GetClassLinkString {
    my $client = shift || plugin::val('$client');  # Ensure $client is available
    my %class_map = plugin::GetClassMap();        # Get the full class map
    my $class_bits = $client->GetClassesBitmask();  # Retrieve the class bits for the client

    my @client_classes;

    # Iterate through class IDs to check which classes the client has
    foreach my $class_id (sort { $a <=> $b } keys %class_map) {
        if ($class_bits & (1 << ($class_id - 1))) {
            push @client_classes, "[" . quest::saylink("change_pet_name_$class_id", 1, $class_map{$class_id}) . "]";
        }
    }

    # Join the client's class names, using ", " and " or " appropriately
    my $pretty_class_string;
    if (@client_classes > 1) {
        $pretty_class_string = join(', ', @client_classes[0..$#client_classes-1]) . ' or ' . $client_classes[-1];
    } else {
        $pretty_class_string = $client_classes[0];  # Only one class
    }

    return $pretty_class_string;
}

