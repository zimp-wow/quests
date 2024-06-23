sub CommonCharacterUpdate {    
    my $client = shift || plugin::val('$client');

    # Title Semaphore from lua scripts
    my $semaphore_title = $client->GetBucket('flag-semaphore');
    if ($semaphore_title) {
        plugin::AddTitleFlag($semaphore_title, $client);
        $client->DeleteBucket('flag-semaphore');
    }

    GrantClassesAA($client);
    GrantGeneralAA($client); # Grant the general here too

    plugin::CheckWorldWideBuffs($client);
    plugin::UpdateCharMaxLevel($client);
	plugin::ConvertFlags($client);
    plugin::AddDefaultAttunement($client);
    plugin::AwardBonusUnlocks($client);
    plugin::UpdateEoMAward($client);
    plugin::RegisterSeasonalLogin($client);
    plugin::EnableTitles($client);
}

sub MultiClassingEnabled
{
    if (quest::get_rule("Custom:MulticlassingEnabled") eq "false") {
        return 0;
    } else {
        return 1;
    }
}

sub GetClassMap {
    return (
        1 => "Warrior",
        2 => "Cleric",
        3 => "Paladin",
        4 => "Ranger",
        5 => "Shadow Knight",
        6 => "Druid",
        7 => "Monk",
        8 => "Bard",
        9 => "Rogue",
        10 => "Shaman",
        11 => "Necromancer",
        12 => "Wizard",
        13 => "Magician",
        14 => "Enchanter",
        15 => "Beastlord",
        16 => "Berserker",
    );
}

sub GetClassID {
    my ($class_name) = @_;
    my %class_map = (
        "Warrior" => 1,
        "Cleric" => 2,
        "Paladin" => 3,
        "Ranger" => 4,
        "Shadow Knight" => 5,
        "Druid" => 6,
        "Monk" => 7,
        "Bard" => 8,
        "Rogue" => 9,
        "Shaman" => 10,
        "Necromancer" => 11,
        "Wizard" => 12,
        "Magician" => 13,
        "Enchanter" => 14,
        "Beastlord" => 15,
        "Berserker" => 16,
    );
    return $class_map{$class_name};
}

# Example usage:
my $class_id = GetClassID("Wizard");
print "Wizard's ID is $class_id\n"; # Output: Wizard's ID is 12


sub GetClassBitmask {
    my ($class_id) = @_;
    if ($class_id < 1 || $class_id > 16) {
        return -1;
    }
    my $bitmask = 1 << ($class_id - 1);
    return $bitmask;
}

sub IsMeleeClass {
    my $class_id = shift;
    my @melee_classes = (1, 3, 4, 5, 7, 8, 9, 15, 16);

    foreach my $melee_class (@melee_classes) {
        if ($melee_class == $class_id) {
            return 1;
        }
    }
    return 0;
}

sub HasMeleeClass {
    my $client   = shift || plugin::val('$client');
    my $class_bits = $client->GetClassesBitmask();
    
    # Iterate through each possible class ID
    for my $class_id (1..16) {
        # Check if the class bit is set in the bitmask
        if ($class_bits & (1 << ($class_id - 1))) {
            # Check if the class is a melee class
            return 1 if IsMeleeClass($class_id);
        }
    }
    
    # Return 0 if no melee class is found
    return 0;
}

sub AddClass {
    my $class_id = shift;
    my $client = shift || plugin::val('$client');

    if ($class_id && $class_id > 0 && $class_id < 17 && GetClassesCount($client) < 3) {
        $client->AddExtraClass($class_id);
        quest::ding();

        my $name = $client->GetCleanName();
        my $class_name = quest::getclassname($class_id);
        my $full_class_name = GetPrettyClassString();        

        $client->Message(15, "You have permanently gained access to the $class_name class, and are now a $full_class_name.");
        GrantClassesAA();

        if (GetClassesCount() > 2 && CheckUniqueClass($client->GetClassesBitmask())) {
            my $class_bits          = $client->GetClassesBitmask();
            quest::set_data("class-$class_bits", $class_bits);
            plugin::WorldAnnounce("$name has become the FIRST $full_class_name.");            
        }       

        if ($class_id == 8) {
            quest::permaclass(8);
        } elsif (plugin::IsMeleeClass($class_id) && !plugin::IsMeleeClass($client->GetClass())) {
            quest::permaclass($class_id);
        }
    }    
}

sub CheckUniqueClass {
    my $client              = plugin::val('$client');
    my $class_bits          = $client->GetClassesBitmask();
    my $class_bit_bucket    = quest::get_data("class-$class_bits");    

    if ($class_bit_bucket) {
        return 0;
    } else {
        return 1;
    }
}

sub GetPrettyClassString {
    my $client = shift || plugin::val('$client');  # Ensure $client is available
    my %class_map = GetClassMap();  # Get the full class map
    my $class_bits = $client->GetClassesBitmask();  # Retrieve the class bits for the client

    my @client_classes;

    # Iterate through class IDs to check which classes the client has
    foreach my $class_id (sort { $a <=> $b } keys %class_map) {
        if ($class_bits & (1 << ($class_id - 1))) {
            push @client_classes, $class_map{$class_id};  # Add class name if the client has it
        }
    }

    # Join the client's class names with slashes
    my $pretty_class_string = join('/', @client_classes);

    return $pretty_class_string;
}

sub GetClassesCount {
    my $client = shift || plugin::val('$client');

    if ($client) {
        my $class_bits = $client->GetClassesBitmask();
        my $count = 0;
        
        while ($class_bits) {
            $count += $class_bits & 1;
            $class_bits >>= 1;
        }

        return $count;
    }

    # Return 0 or an appropriate value if $client is not provided or no classes bits are set
    return 0;
}

sub GetExtraClassesList {
    my $client = shift || plugin::val('$client');
    my %class_map = GetClassMap();
    my $class_bits = $client->GetClassesBitmask();
    my %available_classes;

    # Determine which classes the player does NOT have based on class bits
    foreach my $class_id (keys %class_map) {
        unless ($class_bits & (1 << ($class_id - 1))) {
            $available_classes{$class_id} = $class_map{$class_id};
        }
    }

    return %available_classes;
}

sub GetClassesSelectionString {
    my $client = shift || plugin::val('$client');
    my %available_classes = GetExtraClassesList($client);
    my @selection_strings;

    foreach my $class_id (sort { $a <=> $b } keys %available_classes) {
        my $class_name = $available_classes{$class_id};
        my $signal_string = "select_class_" . $class_id; # Unique signal string based on class ID
        push @selection_strings, "[".quest::saylink($signal_string, 1, $class_name)."]";
    }

    my $selection_string = join(", ", @selection_strings[0 .. $#selection_strings-1]);
    $selection_string .= ", or " . $selection_strings[-1] if @selection_strings > 1;

    return $selection_string;
}

sub IsValidToAddClass {
    my $class_id_to_add = shift;
    my $client = plugin::val('$client'); # Assuming $client is accessible in this context

    # Retrieve the client's current class bits
    my $class_bits = $client->GetClassesBitmask();

    # Count the number of classes the client already has
    my $classes_count = 0;
    for (my $i = 1; $i <= 16; $i++) {
        $classes_count += ($class_bits & (1 << ($i - 1))) ? 1 : 0;
    }

    # Check if the client already has this class
    my $has_class_already = ($class_bits & (1 << ($class_id_to_add - 1))) ? 1 : 0;

    # Determine if eligible to add: less than 3 classes and doesn't already have this class
    return ($classes_count < 3 && !$has_class_already);
}

sub HasClass {
    my $client      = shift;
    my $class_id    = shift;
    my $class_bits  = $client->GetClassesBitmask();

    return ($class_bits & (1 << ($class_id - 1))) ? 1 : 0;
}

sub HasClassName {
    my $client      = shift;
    my $class_name  = shift;

    return HasClass($client, GetClassID($class_name));
}

sub GrantGeneralAA {
    my $client = shift || plugin::val('$client');

    my %general_aa = (
        1000 => 1,  # Bazaar Gate
        12636 => 8, # Eyes Wide Open
        1021 => 5,  # Mystical Attuning 
    );
    
    foreach my $aa_id (keys %general_aa) {        
        while ($client->GetAA($aa_id) < $general_aa{$aa_id}) {
            $client->IncrementAA($aa_id);
        }
    } 
}

sub GrantClassAA {
    my ($client, $PCClass) = @_;

    # Define a hash where each class ID maps to a hash of its AAs and rank counts
    my %class_aa = (
        1 => { # Warrior
            '3731' => 1, # Infused by Rage
            '800' => 1, # Vehement Rage
            '733' => 1, # Killing Spree
            '254' => 1, # Call of Challenge
        },
        2 => { # Cleric
            '1405' => 1, # Twincast
            '169' => 1,   # Divine Arbitration
            '254' => 1,   # Divine Avatar
        },
        3 => { # Paladin
            '73' => 1,  # Divine Stun
            '3820' => 1, # Blessing of Life
        },
        4 => { # Ranger
            '84' => 1,   # Endless Quiver
            '878' => 1,  # Bow Mastery
            '219' => 1,   # Entrap
            '462' => 1,  # Auspice of the Hunter
        },
        5 => { # Shadow Knight
            '697' => 1,  # Mortal Coil
            '749' => 1, # Explosion of Spite
            '125' => 1,   # Pet Discipline
        },
        6 => { # Druid
            '185' => 1,   # Spirit of the Wood
            '403' => 1, # Paralytic Spores
            '259' => 3,   # Critical Affliction (assuming ranks based on script context)
            '3815' => 1,  # Destructive Cascade
            '125' => 1,   # Pet Discipline
        },
        7 => { # Monk
            '206' => 1,  # Technique of Master Wu
            '468' => 1, # Crippling Strike
        },
        8 => { # Bard
            '212' => 1,  # Fading Memories
            '187' => 5,  # Harmonious Attack (all ranks)
            '359' => 1, # Dance of Blades
            '94' => 1,  # Jam Fest
        },
        9 => { # Rogue
            '124' => 1,  # Chaotic Stab
            '204' => 1,  # Shroud of Stealth
            '733' => 1, # Killing Spree
        },
        10 => { # Shaman
            '9503' => 1, # Group Shrink
            '447' => 1,  # Ancestral Aid
            '1215' => 1,  # Summon Companion
            '125' => 1,   # Pet Discipline
        },
        11 => { # Necromancer
            '259' => 1,    # Critical Affliction
            '3815' => 1,   # Destructive Cascade
            '250' => 1,    # Pet Affinity
            '431' => 1,  # Pestilent Paralysis
            '1215' => 1,   # Summon Companion
            '125' => 1,    # Pet Discipline
        },
        12 => { # Wizard
            '52' => 1,  # Improved Familiar
            '172' => 1,  # Harvest of Druzzil
            '776' => 1, # Arcane Overkill
        },
        13 => { # Mage
            '1205' => 1, # Companion's Fury
            '250' => 1,  # Pet Affinity
            '8342' => 1, # Host in the Shell
            '1215' => 1, # Summon Companion
            '125' => 1,  # Pet Discipline
        },
        14 => { # Enchanter
            '55' => 1,  # Permanent Illusion
            '217' => 1,  # Project Illusion
            '8701' => 1,# Phantasmic Reflex
            '195' => 3,  # Animation Empathy (all ranks)
            '250' => 1,  # Pet Affinity
            '1215' => 1, # Summon Companion
            '125' => 1,  # Pet Discipline
        },
        15 => { # Beastlord
            '11080' => 1, # Chameleon Strike
            '986' => 1,  # Bite of the Asp
            '250' => 1,   # Pet Affinity
            '1215' => 1,  # Summon Companion
            '125' => 1,   # Pet Discipline
        },
        16 => { # Berserker
            '733' => 1, # Killing Spree
            '109' => 1,  # Rampage
        }
    );   

    foreach my $aa_id (keys %{$class_aa{$PCClass}}) {
        $client->GrantAlternateAdvancementAbility($aa_id, $class_aa{$PCClass}{$aa_id}, 1);
    }

    if ($client->GetLevel() >= 20) {
        my %class_aa = (
            4 => { # Ranger
                '82' => 1 # Archery Master 1
            }
        );
    }

    if ($client->GetLevel() >= 40) {
        my %class_aa = (
            4 => { # Ranger
                '82' => 2 # Archery Master 1
            }
        );
    }

    if ($client->GetLevel() >= 51 && plugin::IsSeasonal($client)) {
        my %class_aa = (
            1 => {
                '2011' => 1, #Imperator's Command
            },
            2 => {
                '735' => 1,
            },
            3 => {
                '3500' => 1, # Blessing of Light
            },
            4 => {
              '557' => 1, # Trick Shot  
            },
            5  => {
                '825' => 1, # Vicious Bite of Chaos
            },
            6 => {
                '393' => 1,
            },
            7 => {
                '206' => 2, #Technique of Master Wu
            },
            8 => {
                '1246' => 1,
            },
            9 => {
                '1174' => 1,
            },
            10 => {
                '151' => 1, # Spiritual Blessing
            },
            11 => {
                '710' => 1, # Funeral Pyre
            },
            12 => {
                '1211' => 1,
            },
            13 => {
                '3516' => 1, # Companion of Necessity
            },
            14 => {
                '8700' => 1, # Beam of Slumber
            },
            15 => {
                '1240' => 1, # Frenzied Swipes
            },
            16 => {
                '133' => 1, # Decapitation
            }
        );
        
        foreach my $aa_id (keys %{$class_aa{$PCClass}}) {
            $client->GrantAlternateAdvancementAbility($aa_id, $class_aa{$PCClass}{$aa_id}, 1);
        }

    }
}

sub GrantClassesAA {
    my $client = shift || plugin::val('$client');
    my $class_bitmask = $client->GetClassesBitmask();    

    # Iterate through each class ID (bit position)
    for (my $i = 0; $i < 16; $i++) { 
        if ($class_bitmask & (1 << $i)) {
            # Call GrantClassAA for each class found in the bitmask
            GrantClassAA($client, $i + 1);
        }
    }
}