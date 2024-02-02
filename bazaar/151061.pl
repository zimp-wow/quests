#Sulentia, Polymorphist
#(Body Modification)

my $race_change_cost = 5;

sub EVENT_SAY {
if ($client->GetGM()) {
    if ($text=~/hail/i) {
        quest::say("Greetings, $name. Do you seek perfection? Are you [unhappy with your form]? Perhaps, instead you desire to [bestow a nickname] upon your companion?");
    }

    elsif ($text=~/unhappy with your form/i) {
        quest::say("Just so. If you can properly anchor your memories - perhaps with ". plugin::num2en($race_change_cost) ." [". plugin::EOMLink() ."], I can adjust your form.
                    Be warned, this process is quite traumatic, and you will immediately black out.");
        if (plugin::GetEOM($client) > $race_change_cost) {
            $client->Message(15, "Warning. You will disconnect immediately upon selecting a new race.");
            $client->Message(257, " ------- Select a Race ------- ");
            my $races = get_races();
            foreach my $id (sort { $a <=> $b } keys %$races) {
                my $race_name = $races{$id};
                $client->Message(257, "-[ " . quest::saylink("Change race to $race_name", 1, $race_name) . " ]");
            }
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
