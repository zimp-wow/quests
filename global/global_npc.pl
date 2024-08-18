sub EVENT_SAY {
    if (plugin::MultiClassingEnabled() && $npc->GetClass() >= 20 && $npc->GetClass() <= 35) {
        my $classes = $client->GetClassesBitmask();
        my $player_class_id = $npc->GetClass() - 19;
        my $class_name = quest::getclassname($player_class_id);

        if ($text=~/hail/i) {
            my $select_string = quest::saylink("class_select", 1, "become a $class_name");
            my %class_greetings = (
                1 => "Ah, a courageous soul approaches. Are you here to embrace the discipline and strength required to [$select_string]?",
                2 => "Blessings upon you, child. The light guides you to me; is it your wish to [$select_string] and serve the divine?",
                3 => "Honor and valor shine from your eyes. Are you destined to [$select_string], a righteous defender of the light?",
                4 => "The winds whisper of a new guardian. Is your heart called to the wilds, to [$select_string], protector of nature?",
                5 => "A shadow looms near. Is it your fate to command the darkness and [$select_string]?",
                6 => "The essence of nature surrounds you. Are you ready to [$select_string], guardian of the balance?",
                7 => "Discipline and inner strength are your allies. Do you seek the path to [$select_string], master of martial arts?",
                8 => "A melody accompanies your steps. Do you feel the rhythm calling you to [$select_string], the voice of inspiration?",
                9 => "Cunning and silence are your markers. Are you prepared to [$select_string], master of stealth and treachery?",
                10 => "The spirits whisper of a new journey. Is it time for you to [$select_string], a conduit of the spirit world?",
                11 => "A chill of the grave precedes you. Will you embrace the dark arts and [$select_string]?",
                12 => "Arcane energies pulse around you. Is your destiny to [$select_string], master of the elements?",
                13 => "Creation's essence swirls around you. Are you called to [$select_string], summoner of the arcane?",
                14 => "Your presence bends reality. Are you ready to [$select_string], weaver of illusions and mind control?",
                15 => "The call of the wild strengthens. Will you heed the call and [$select_string], melding the power of beasts and combat?",
                16 => "Rage burns within your spirit. Do you wish to unleash this power and [$select_string], a warrior of frenzy?"
            );
            
            my $greeting = $class_greetings{$player_class_id} // "Greetings, traveler. Are you seeking guidance or knowledge?";
            if (!($classes & plugin::GetClassBitmask($player_class_id)) && plugin::GetClassesCount($client) < 3) {
                plugin::NPCTell($greeting);
            }
        }        

        if ($text eq "class_select") {
            my $class_name = quest::getclassname($npc->GetClass() - 19);
            my $confirm_link = quest::saylink("class_confirm", 1, "Are you ready to commit to the path of the $class_name?");

            my %class_specific_messages = (
                1 => "The path of the Warrior is arduous and demanding, requiring unwavering courage and strength. " . 
                    "Once chosen, this path is your destiny, only to be reversed at the whims of the gods. [" . $confirm_link . "]",
                2 => "Embracing the Cleric's way means dedicating your life to the divine, serving as a beacon of light and healing. " .
                    "This sacred commitment is binding, revered by the gods themselves. [" . $confirm_link . "]",
                3 => "The Paladin stands as a beacon of hope, blending the might of arms with the purity of faith. " .
                    "Are you prepared to defend the light and uphold justice, knowing such a choice is guided by the gods? [" . $confirm_link . "]",
                4 => "Rangers protect the balance of nature, a path filled with peril and beauty. " .
                    "If your heart is true to the wild, confirm your dedication to become one with nature and its guardians. [" . $confirm_link . "]",
                5 => "Shadow Knights wield the power of darkness and fear. " .
                    "This path is fraught with danger and moral ambiguity. Only the most resolute may walk it, and once chosen, it is rarely abandoned. [" . $confirm_link . "]",
                6 => "Druids are the guardians of nature, harmonizing the forces of life and growth. " .
                    "To walk this path is to become one with the earth itself. Are you ready to embrace this eternal bond? [" . $confirm_link . "]",
                7 => "The Monk's discipline is forged from inner strength and relentless training. " .
                    "Embrace this path with the understanding that it demands complete devotion, a devotion that is recognized by the gods. [" . $confirm_link . "]",
                8 => "Bards are the heart of any fellowship, weaving magic and music into powerful symphonies. " .
                    "If you feel the song within your soul, affirm your desire to live a life of melody and adventure. [" . $confirm_link . "]",
                9 => "Rogues thrive in the shadows, where cunning and agility are the keys to survival. " .
                    "Is your spirit attuned to the silent whispers of the dark? Confirm your path and step into the world unseen. [" . $confirm_link . "]",
                10 => "Shamans act as intermediaries between the physical and spirit worlds. " .
                    "If you are called to bridge these realms, affirm your commitment to the spiritual journey ahead. [" . $confirm_link . "]",
                11 => "Necromancers command the forces of death and decay. " .
                    "This dark path is not chosen lightly, for its course is irrevocable, shadowed by the oversight of the gods themselves. [" . $confirm_link . "]",
                12 => "Wizards master the arcane, wielding the raw forces of magic. " .
                    "If you seek to harness these elemental powers, confirm your resolve to tread a path fraught with danger and discovery. [" . $confirm_link . "]",
                13 => "Magicians shape reality, summoning creatures and objects from the ether. " .
                    "Are you prepared to command the very fabric of existence, knowing such power is watched closely by the divine? [" . $confirm_link . "]",
                14 => "Enchanters twist the minds and reality itself, with wisdom and subtlety. " .
                    "If you choose to weave the strands of fate, know that this path is as binding as the spells you will cast. [" . $confirm_link . "]",
                15 => "Beastlords bond with the spirits of animals, embodying their primal essence. " .
                    "This sacred pact with nature is eternal, guided by the spirits and overseen by the gods. Are you ready to accept this union? [" . $confirm_link . "]",
                16 => "Berserkers unleash their inner fury, a force of pure, unbridled power. " .
                    "This path of rage is relentless and all-consuming. Confirm if you are ready to embrace the storm within, under the gaze of the gods. [" . $confirm_link . "]"
            );

            my $class_message = $class_specific_messages{$player_class_id} // "The path before you is significant, a choice that once made, is not easily undone. The gods watch over your decision. " . $confirm_link;
            plugin::NPCTell($class_message);
        }

        if ($text eq "class_confirm") {
            if (plugin::GetClassesCount($client) < 3) {
                plugin::AddClass($player_class_id);
                plugin::NPCTell("Welcome, $class_name, and be known!");
            }
        }
    }
}

sub EVENT_DEATH_COMPLETE {
    if (defined($killed_corpse_id)) {
        my $corpse = $entity_list->GetCorpseByID($killed_corpse_id);
        
        my %item_drops = (
            11703 => { #Box of Abu Kar 11703
                'drop_chance' => 0.0001, # 1/1000% chance to drop
                'min_level'   => 35, # Minimum level to drop from
                'max_level'   => 99, # Maximum level to drop from
            }
            # ... more items and their attributes
        );

        for my $item_id (keys %item_drops) {
            if ($npc->GetLevel() >= $item_drops{$item_id}{'min_level'} && 
                $npc->GetLevel() <= $item_drops{$item_id}{'max_level'}) {                    
                if (rand() < $item_drops{$item_id}{'drop_chance'}) {
                    $corpse->AddItem($item_id, 1);
                    quest::ding();
                }
            }
        }
    }
}

sub EVENT_AGGRO {
    plugin::FadeWorldWideBuffs($npc);
}

sub EVENT_SPAWN {
    plugin::CheckSpawnWaypoints();

    if ($npc->GetOwner() && $npc->GetOwner()->IsClient()) {
        # Define spell ID arrays for different pet types
        my @warders             = (2612, 2614, 2616, 2618, 2621, 2623, 2626, 2627, 2631, 2633, 3457, 3461, 5531, 5538, 10379);
        my @air_elementals      = (317, 396, 400, 404, 499, 572, 576, 623, 627, 631, 635, 1674, 1678, 5473, 10695, 3317);
        my @earth_elementals    = (58, 335, 397, 401, 496, 569, 573, 620, 624, 628, 632, 1671, 1675, 5495, 10753, 3324);
        my @water_elementals    = (315, 336, 398, 402, 497, 570, 574, 621, 625, 629, 633, 1672, 1676, 5480, 10708, 3320);
        my @fire_elementals     = (316, 395, 399, 403, 498, 571, 575, 622, 626, 630, 634, 1673, 1677, 5485, 10719, 3322);
        my @monster_summons     = (1400, 1402, 1404, 4888, 10769);
        my @manifest            = (1936);
        my @skeletons           = (338, 351, 362, 440, 441, 442, 443, 491, 492, 493, 494, 495);
        my @spectres            = (1621, 1622, 1623, 3304, 3310, 3314, 5431, 5438, 10506, 10561);
        my @animations          = (285, 295, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 1723, 3034, 5505, 10586);
        my @animated_swords     = (1722, 5460, 10840);
        my @hammers             = (1721, 5256, 11750, 11751, 11752);
        my @spirits             = (164, 165, 166, 577, 1574, 3377, 5389, 9983);  # Added spirits
        my @bears               = (1475);

        my $owner = $npc->GetOwner();

        # Collect existing pet names for the owner
        my @existing_pet_names;
        my @npc_list = $entity_list->GetNPCList();
        foreach my $ent (@npc_list)  {
            if ($ent->GetOwner() && $ent->GetOwner()->GetID() == $owner->GetID()) {
                push @existing_pet_names, $ent->GetCleanName();
            } 
        }

        # Warder Sizing
        if (grep { $_ == $npc->GetPetSpellID() } @warders) {
            my %size_map = (
                1   => 8,
                2   => 2,
                3   => 5,
                4   => 10,
                5   => 10,
                6   => 10,
                7   => 10,
                8   => 7,
                9   => 8,
                10  => 4,
                11  => 7,
                12  => 6,
                128 => 6,
                130 => 8,
                330 => 4,
                522 => 10,
            );

            my $owner_race = $owner->GetBaseRace();
            if (exists $size_map{$owner_race}) {
                my $size = $size_map{$owner_race};
                $size *= 1 + ($npc->GetLevel() * 0.01);
                $npc->ChangeSize($size);
            }
        }

        # Bear Names
        if (grep { $_ == $npc->GetPetSpellID() } @bears) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                # Attempt to find an existing bear name that isn't already used
                for my $i (1..100) {
                    my $bucket_name = "bear_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                # If no existing name is found, generate a new one
                if (!$name_found) {
                    my @bearNames = (
                        "Yogi", "Boo", "Pip", "Nugget", "Snick", "Pebble", "Fizz", "Munch", "Squirt", "Binky",
                        "Tiny Grizzle", "Snugglepaws", "Honey Nibbles", "Bearly There", "Cuddlycub", "Fuzzlet",
                        "Pint-Sized Paws", "Mini Growl", "Buttonbear", "Teacup Teddie",
                        "Coco", "Bubba", "Milo", "Teddy", "Biscuit", "Frodo", "Gizmo", "Fluffy", "Mochi", "Waffles",
                        "Bamboo", "Chomp", "Sprout", "Rolo", "Munchkin", "Pudding", "Pipsqueak", "Fuzzball", "Nibbles",
                        "Pickles", "Popcorn", "Ziggy", "Sparky", "Scooter", "Whiskers", "Snickers", "Wiggles",
                        "Bubbles", "Chubby", "Choco", "Snickerdoodle", "Cupcake", "Tootsie", "Doodle", "Muffin",
                        "Peanut", "Buttons", "Truffles", "Brownie", "Gingersnap", "Poppy", "Puff", "Smores",
                        "Marshmallow", "Cuddles", "Pumpkin", "Ruffles", "Tater", "Sprinkles", "Chewy", "Puffball",
                        "Cupcake", "Fudge", "Chester", "Cosmo", "Clover", "Dobby", "Squeaky", "Nibbler", "Tater Tot",
                        "Dumpling", "Wombat", "BoBo", "Churro", "Scooby", "Pudding", "Ducky", "Peaches", "Rascal",
                        "Smidge", "Bean", "Scruffy", "Gus", "Rugrat", "Hobbit", "Beary_McBearface", "Paddington",
                        "Bearlock Holmes", "Bearon von Growl", "Bearcules", "Winnie the Boo", "Grizzly Adams",
                        "Bear Grylls", "Bearfoot", "Bearth Vader", "Bearin' Square", "Paw Bear",
                        "Bearzooka", "Bear Hugz", "Bearister", "Gummy Bearson", "Bearalicious",
                        "Robin Hoodbear", "Bearthoven", "Sir Growls-a-Lot", "Bearington",
                        "Honeybear Hound", "Bearminator", "Bear Necessities", "Grizz Lee",
                        "Polar Oppawsite", "Growlbert Einstein", "Bearoness", "Bearrific",
                        "Bearcat", "Bearly Legal", "Unbearlievable", "Teddy Ruxbin", "Bear Hugger",
                        "Bearoness von Snuggles", "Bearbie Doll", "Clawdia Pawlsen", "Grizzelda",
                        "Fuzz Lightyear", "Pawdrey Hepbear", "Furrari", "Bearbados Slim", "Bearlin",
                        "Furrnando", "Growlberto", "Bearloaf", "Bearianna Grande", "Bearon the Red",
                        "Clawrence of Arabia", "Paddingpaw", "Pawtrick Swayze", "Bearami Brown",
                        "Grizzabella", "Bearlentine", "Bearthday Boy", "Paw McCartney", "Clawdette",
                        "Bearon Brando", "Beartholomew", "Bear Hugington", "Fluff Daddy", "Chewbearca",
                        "Growldemort", "Bearicane", "Bearlosaurus Rex", "Bear-lenium Falcon", "Bearborator"
                    );

                    do {
                        $pet_name = $bearNames[int(rand(@bearNames))];
                    } while (grep { $_ eq $pet_name } @existing_pet_names);

                    # Store the new name in the next available bucket
                    for my $i (1..100) {
                        my $bucket_name = "bear_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }

                    $npc->TempName($pet_name);
                }
            }
        }

        # Warder Names
        if (grep { $_ == $npc->GetPetSpellID() } @warders) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..10) {
                    my $bucket_name = "warder_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    my @prefixes = qw(Gnar Krag Bru Vor Thok Dra Gar Zhar Kro Skaar Fang Ruk Grim 
                                      Tharn Bar Krull Vorn Drak Krog Mar Groth Skorn Grak Harg 
                                      Ruk Narz Vul Krath Rorg Tark Bruk Grimz Thrak Brak Mor Drak Kill
                                      Gnash Vrak Zur Grorn Koth Vorash Thrash Zorag Gruk Rak Vorn Goth);

                    my @suffixes = qw(fang claw tusk bite maw roar rend gore gnash bark slash 
                                      snap rip tear thorn howl grunt wing quill tail fur 
                                      king snout scale jaw hide horn talon 
                                      hoof paw mane purr hiss sting snarl growl screech 
                                      coil lunge scowl chomp gnarl gash whip bristle creep 
                                      slink scratch gnaw rake squeal hiss snort 
                                      rasp tread bound lunge lash slither thrash  
                                      peck snip snatch 
                                      bite shred gouge flinch grunt grunt pierce 
                                      clamp grind rake carve shred crunch 
                                      batter crush mash snub dozer);

                    do {
                        $pet_name = ucfirst($prefixes[int(rand(@prefixes))] . $suffixes[int(rand(@suffixes))]);
                    } while (grep { $_ eq $pet_name } @existing_pet_names);

                    for my $i (1..10) {
                        my $bucket_name = "warder_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }

                    $npc->TempName($pet_name);
                }
            }
        }

        # Spirit Names
        if (grep { $_ == $npc->GetPetSpellID() } @spirits) {            
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..10) {
                    my $bucket_name = "spirit_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    my @prefixes = qw(Ancient Wise Shadow Mystic Spirit Ghost Phantom Ancestral Elder Sacred 
                                      Thunder Moon Frost Blood Night Storm Silent Echo Fire Earth Sky 
                                      Star Dark Silver Grim Fierce Wild Whisper Winter Steel Iron 
                                      Noble Proud Fierce Glimmer Ember Savage Brave Noble Shimmer 
                                      Golden Crimson Lone Eternal Wraith Stone);

                    my @suffixes = qw(Wolf Lupus Fang Howl Prowl Claw Eye Breath Maw Snarl Fur Tail Howler
                                      Bite Heart Shade Stalker Hunter Runner Roar Spirit Bane Fury 
                                      Warden Shroud Shadow Ripper Guardian Strider Nightshade Sentry 
                                      Whisper Fangblade Razorback Warg Sentinel Watcher Ghostwalker);

                    do {
                        $pet_name = ucfirst($prefixes[int(rand(@prefixes))]) . '_' . ucfirst($suffixes[int(rand(@suffixes))]);
                    } while (grep { $_ eq $pet_name } @existing_pet_names);

                    for my $i (1..10) {
                        my $bucket_name = "spirit_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }

                    $npc->TempName($pet_name);
                }
            }
        }

        # Air Elemental Names
        if (grep { $_ == $npc->GetPetSpellID() } @air_elementals) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "air_elemental_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the elemental's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "air_elemental_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Earth Elemental Names
        if (grep { $_ == $npc->GetPetSpellID() } @earth_elementals) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "earth_elemental_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the elemental's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "earth_elemental_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Water Elemental Names
        if (grep { $_ == $npc->GetPetSpellID() } @water_elementals) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "water_elemental_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the elemental's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "water_elemental_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Fire Elemental Names
        if (grep { $_ == $npc->GetPetSpellID() } @fire_elementals) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "fire_elemental_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the elemental's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "fire_elemental_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Skeleton Names
        if (grep { $_ == $npc->GetPetSpellID() } @skeletons) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "skeleton_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    my @prefixes = qw(Mor Skel Grim Varn Mar Karn Zor Gor Thal Tor Nar Thrax);
                    my @middles = qw(ak or th ar al ro im uth on an en ol amun);
                    my @suffixes = qw(rik thos nar grim thal ok ath ur mar oth ros ak dar);

                    do {
                        $pet_name = ucfirst($prefixes[int(rand(@prefixes))] . $middles[int(rand(@middles))] . $suffixes[int(rand(@suffixes))]);
                    } while (grep { $_ eq $pet_name } @existing_pet_names);

                    for my $i (1..100) {
                        my $bucket_name = "skeleton_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }

                    $npc->TempName($pet_name);
                }
            }
        }

        # Spectre Names
        if (grep { $_ == $npc->GetPetSpellID() } @spectres) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "spectre_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    my @prefixes = qw(Shad Vel Mor Xyl Eld Zar Thar Lur Vor Dra Thrax Amun Grim);
                    my @middles = qw(rax drim vath ris ros vok nis rok rath lor amun);
                    my @suffixes = qw(thar is al ar os eth or ith as ok dar ra);

                    do {
                        $pet_name = ucfirst($prefixes[int(rand(@prefixes))] . $middles[int(rand(@middles))] . $suffixes[int(rand(@suffixes))]);
                    } while (grep { $_ eq $pet_name } @existing_pet_names);

                    for my $i (1..100) {
                        my $bucket_name = "spectre_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }

                    $npc->TempName($pet_name);
                }
            }
        }

        # Animation Names
        if (grep { $_ == $npc->GetPetSpellID() } @animations) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "animation_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the animation's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "animation_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Animated Sword Names
        if (grep { $_ == $npc->GetPetSpellID() } @animated_swords) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "animated_sword_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the sword's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "animated_sword_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Hammer Names
        if (grep { $_ == $npc->GetPetSpellID() } @hammers) {
            if ($owner) {
                my $pet_name;
                my $name_found = 0;

                for my $i (1..100) {
                    my $bucket_name = "hammer_name_$i";
                    $pet_name = $owner->GetBucket($bucket_name);
                    if ($pet_name) {
                        if (!grep { $_ eq $pet_name } @existing_pet_names) {
                            $npc->TempName($pet_name);
                            $name_found = 1;
                            last;
                        }
                    }
                }

                if (!$name_found) {
                    $pet_name = $npc->GetCleanName();  # Keep the hammer's default name unique
                    for my $i (1..100) {
                        my $bucket_name = "hammer_name_$i";
                        unless ($owner->GetBucket($bucket_name)) {
                            $owner->SetBucket($bucket_name, $pet_name);
                            last;
                        }
                    }
                }
            }
        }

        # Monster Summons (unique names per summon)
        if (grep { $_ == $npc->GetPetSpellID() } @monster_summons) {
            if ($owner) {
                my $pet_name = $npc->GetCleanName();  # Keep the monster summon default name unique
                for my $i (1..100) {
                    my $bucket_name = "monster_summon_name_$i";
                    unless ($owner->GetBucket($bucket_name)) {
                        $owner->SetBucket($bucket_name, $pet_name);
                        last;
                    }
                }
            }
        }

        # Manifest (unique names per summon)
        if (grep { $_ == $npc->GetPetSpellID() } @manifest) {
            if ($owner) {
                my $pet_name = $npc->GetCleanName();  # Keep the manifest's default name unique
                for my $i (1..100) {
                    my $bucket_name = "manifest_name_$i";
                    unless ($owner->GetBucket($bucket_name)) {
                        $owner->SetBucket($bucket_name, $pet_name);
                        last;
                    }
                }
            }
        }
    }
}

sub EVENT_DAMAGE_GIVEN 
{
    # Special aggro events for player pets; if they are not taunting then add their owner to any
    # mob that they attack's aggro list. If they are taunting, then give them some bonus aggro.
    if ($npc->IsPet() && $npc->GetOwner()->IsClient()) {
       
        if ($npc->IsTaunting()) {
            my $ent = $entity_list->GetMobByID($entity_id);
            if ($ent) {
                $ent->AddToHateList($npc->GetOwner())
            }
        } else {
            my $ent = $entity_list->GetMobByID($entity_id);
            if ($ent) {
                $ent->AddToHateList($npc, 100);
            }
        }
    }
}

sub EVENT_KILLED_MERIT {
    #SLAYERS!
    if ($killer_id) {
        my $killer = $entity_list->GetClientByID($killer_id);
        if (!$killer) {
            $entity_list->GetMobByID($killer_id);
            if ($killer && $killer->IsPetOwnerClient()) {
                $killer = $killer->GetOwner();
            }
        }

        if ($killer) {
            plugin::ProcessSlayerCredit($killer, $npc, $entity_list);
        }
    }    
}
