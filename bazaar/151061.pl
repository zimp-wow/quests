#Sulentia, Polymorphist
#(Body Modification)

my $race_change_cost = 5;
my $sex_change_cost = 5;

sub EVENT_SAY {
if ($client->GetGM()) {
    if ($text=~/hail/i) {        
        my $sex_word;
        if ($client->GetGender()) {
            $sex_word = "masculinity";
        } else {
            $sex_word = "femininity";
        }

        quest::say("Greetings, $name. Do you seek perfection? Are you [unhappy with your form]? Are you interested in embracing [$sex_word]? Perhaps, instead you simply desire a [new identity] altogether?");
    }

    elsif ($text=~/unhappy with your form/i) {
        quest::say("Just so. If you can properly anchor your memories - perhaps with ". plugin::num2en($race_change_cost) ." [". plugin::EOMLink() ."], I can adjust your form.
                    Be warned, this process is quite traumatic, and you will immediately black out.");
        if (plugin::GetEOM($client) > $race_change_cost) {
            $client->Message(15, "WARNING: You will disconnect immediately upon selecting a new race.");
            $client->Message(15, "WARNING: You may select illegal races for your class. No support will be given for any problems caused as a result.");
            $client->Message(257, " ------- Select a Race ------- ");
            my $races = get_races();
            foreach my $id (sort { $a <=> $b } keys %$races) {
                my $race_name = $races->{$id};              
                if ($client->GetRace() != $id) {
                    $client->Message(257, "-[ " . quest::saylink("RACECHANGE:".$id, 1, $race_name));
                }
            }
        }
    }   

    elsif ($text =~ /^RACECHANGE:(\d+)$/i) {
        if (plugin::SpendEOM($client, $race_change_cost)) {
            my $race_id = $1;
            my $races = get_races();
            if ($client->GetRace() != $race_id && exists $races->{$race_id}) {
                my $race_name = $races->{$race_id};
                quest::permarace($race_id);
            } else {
                $client->Message(13, "An error occurred. Unable to change race to ID $race_id.");
            }
        } else {
            quest::say("Sadly, $name, you do not have sufficient Echoes of Memory to properly anchor yourself for this change. Perhaps you will return later.");
        }
    }
    
    elsif ($text eq $sex_word) {
        quest::say("Just [". quest::saylink("SEXCHANGE", 1, "say the word") ."], and for the price of a mere ". plugin::num2en($sex_change_cost) ." [". plugin::EOMLink() ."], I will adjust your form.");
        $client->Message(15, "WARNING: You will disconnect immediately upon changing your sex.");
    }

    elsif ($text eq "SEXCHANGE") {
        if (plugin::SpendEOM($client, $sex_change_cost)) {
            quest::permagender(!$client->GetGender());
        } else {
            quest::say("Sadly, $name, you do not have sufficient Echoes of Memory to properly anchor yourself for this change. Perhaps you will return later.");
        }
    }
}
}

sub get_races {
    return {
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
    };
}
