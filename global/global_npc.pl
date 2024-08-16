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

        # Map keys to the corresponding arrays
        my %pet_type_map = (
            'skeletons'        => \@skeletons,
            'spectres'         => \@spectres,
            'warders'          => \@warders,
            'air_elementals'   => \@air_elementals,
            'earth_elementals' => \@earth_elementals,
            'water_elementals' => \@water_elementals,
            'fire_elementals'  => \@fire_elementals,
            'monster_summons'  => \@monster_summons,
            'manifest'         => \@manifest,
            'animations'       => \@animations,
            'animated_swords'  => \@animated_swords,
            'hammers'          => \@hammers,
            'spirits'          => \@spirits,  # Added spirits to the pet type map
            'bears'            => \@bears,
        );

        # Initialize a hash to track counts for different pet types
        my %pet_counts = map { $_ => 1 } keys %pet_type_map;

        # Fetch the list of NPCs owned by the player
        my @npc_list = $entity_list->GetNPCList();

        foreach my $ent (@npc_list) {
            if ($ent->GetOwner() && $ent->GetOwner()->GetID() == $owner->GetID()) {
                foreach my $type (keys %pet_type_map) {
                    if (grep { $_ == $ent->GetPetSpellID() } @{$pet_type_map{$type}}) {
                        $pet_counts{$type}++;
                        quest::debug("Incrementing $type count to $pet_counts{$type}");
                    }
                }
            }
        }

        # Do Warder Sizing Stuff
        if (grep { $_ == $npc->GetPetSpellID() } @warders) {
            my %size_map = (
                1   => 8,
                2   => 1,
                3   => 5,
                4   => 9,
                5   => 6,
                6   => 6,
                7   => 6,
                8   => 3,
                9   => 12,
                10  => 4,
                11  => 5,
                12  => 3,
                128 => 3,
                130 => 8,
                330 => 3,
            );

            # Check if the owner's race is in the size map and set the size accordingly
            my $owner_race = $owner->GetBaseRace();
            if (exists $size_map{$owner_race}) {
                $size = $size_map{$owner_race};
            }

            # Adjust size based on the NPC's level
            $size *= 1 + ($npc->GetLevel() * 0.01);
            $npc->ChangeSize($size);
        }        

        # Bear Names
        if (grep { $_ == $npc->GetPetSpellID() } @bears) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("bear_name_$pet_counts{'bears'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
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
                    # Randomly select a bear name from the array
                    srand;
                    my $random_bear_name = $bearNames[int(rand(@bearNames))];
                    $npc->TempName($random_bear_name);
                    $owner->SetBucket("bear_name_$pet_counts{'bears'}", $random_bear_name);
                }
            }
        }

        # Warder Names
        if (grep { $_ == $npc->GetPetSpellID() } @warders) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("warder_name_$pet_counts{'warders'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    # Generate a random bestial name
                    my @prefixes = qw(Gnar Krag Bru Vor Thok Dra Gar Zhar Kro Skaar Fang Ruk Grim 
                                    Tharn Bar Krull Vorn Drak Krog Mar Groth Skorn Grak Harg 
                                    Ruk Narz Vul Krath Rorg Tark Bruk Grimz Thrak Brak Mor Drak Kill
                                    Gnash Vrak Zur Grorn Koth Vorash Thrash Zorag Gruk Rak Vorn Goth);

                    my @suffixes = qw(
                                        fang claw tusk bite maw roar rend gore gnash bark slash 
                                        snap rip tear thorn howl grunt wing quill tail fur 
                                        king snout scale jaw hide horn talon 
                                        hoof paw mane purr hiss sting snarl growl screech 
                                        coil lunge scowl chomp gnarl gash whip bristle creep 
                                        slink scratch gnaw rake squeal hiss snort 
                                        rasp tread bound lunge lash slither thrash  
                                        peck snip snatch 
                                        bite shred gouge flinch grunt grunt pierce 
                                        clamp grind rake carve shred crunch 
                                        batter crush mash snub dozer
                                    );


                    my $random_name = ucfirst($prefixes[int(rand(@prefixes))] .
                                            $suffixes[int(rand(@suffixes))]);

                    $npc->TempName($random_name);
                    $owner->SetBucket("warder_name_$pet_counts{'warders'}", $random_name);
                }
            }
        }

        # Loop to generate a name for ancestral spirit wolves
        if (grep { $_ == $npc->GetPetSpellID() } @spirits) {            
            if ($owner) {
                my $pet_name = $owner->GetBucket("spirits_name_$pet_counts{'spirits'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    my @spirit_wolf_prefixes = qw(Ancient Wise Shadow Mystic Spirit Ghost Phantom Ancestral Elder Sacred 
                              Thunder Moon Frost Blood Night Storm Silent Echo Fire Earth Sky 
                              Star Dark Silver Grim Fierce Wild Whisper Winter Steel Iron 
                              Noble Proud Fierce Glimmer Ember Savage Brave Noble Shimmer 
                              Golden Crimson Lone Eternal Wraith Stone);

                    my @spirit_wolf_suffixes = qw(Wolf Lupus Fang Howl Prowl Claw Eye Breath Maw Snarl Fur Tail Howler
                                                Bite Heart Shade Stalker Hunter Runner Roar Spirit Bane Fury 
                                                Warden Shroud Shadow Ripper Guardian Strider Nightshade Sentry 
                                                Whisper Fangblade Razorback Warg Sentinel Watcher Ghostwalker);
                    # Generate a random ancestral spirit wolf name with an underscore
                    my $random_name = ucfirst($spirit_wolf_prefixes[int(rand(@spirit_wolf_prefixes))]) . '_' .
                                    ucfirst($spirit_wolf_suffixes[int(rand(@spirit_wolf_suffixes))]);

                    $npc->TempName($random_name);
                    $owner->SetBucket("spirits_name_$pet_counts{'spirits'}", $random_name);
                }
            }
        }

        # Air Elementals
        if (grep { $_ == $npc->GetPetSpellID() } @air_elementals) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("air_elemental_name_$pet_counts{'air_elementals'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {                   
                    $owner->SetBucket("air_elemental_name_$pet_counts{'air_elementals'}", $npc->GetName());
                }
            }
        }

        # Earth Elementals
        if (grep { $_ == $npc->GetPetSpellID() } @earth_elementals) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("earth_elemental_name_$pet_counts{'earth_elementals'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    $owner->SetBucket("earth_elemental_name_$pet_counts{'earth_elementals'}", $npc->GetName());
                }
            }
        }

        # Water Elementals
        if (grep { $_ == $npc->GetPetSpellID() } @water_elementals) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("water_elemental_name_$pet_counts{'water_elementals'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    $owner->SetBucket("water_elemental_name_$pet_counts{'water_elementals'}", $npc->GetName());
                }
            }
        }

        # Fire Elementals
        if (grep { $_ == $npc->GetPetSpellID() } @fire_elementals) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("fire_elemental_name_$pet_counts{'fire_elementals'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    $owner->SetBucket("fire_elemental_name_$pet_counts{'fire_elementals'}", $npc->GetName());
                }
            }
        }

        # Monster Summons
        if (grep { $_ == $npc->GetPetSpellID() } @monster_summons) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("monster_summon_name_$pet_counts{'monster_summons'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    #$owner->SetBucket("monster_summon_name_$pet_counts{'monster_summons'}", $npc->GetName());
                }
            }
        }

        # Manifest
        if (grep { $_ == $npc->GetPetSpellID() } @manifest) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("manifest_name_$pet_counts{'manifest'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    $owner->SetBucket("manifest_name_$pet_counts{'manifest'}", $npc->GetName());
                }
            }
        }

        # Skeletons
        if (grep { $_ == $npc->GetPetSpellID() } @skeletons) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("skeleton_name_$pet_counts{'skeletons'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    # Generate a random skeletal name directly
                    my @prefixes = qw(Mor Skel Grim Varn Mar Karn Zor Gor Thal Tor Nar Thrax);
                    my @middles = qw(ak or th ar al ro im uth on an en ol amun);
                    my @suffixes = qw(rik thos nar grim thal ok ath ur mar oth ros ak dar);

                    my $random_name = ucfirst($prefixes[int(rand(@prefixes))] .
                                            $middles[int(rand(@middles))] .
                                            $suffixes[int(rand(@suffixes))]);

                    $npc->TempName($random_name);
                    $owner->SetBucket("skeleton_name_$pet_counts{'skeletons'}", $random_name);
                }
            }
        }

        # Spectres
        if (grep { $_ == $npc->GetPetSpellID() } @spectres) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("spectre_name_$pet_counts{'spectres'}");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    # Generate a random ghostly name directly
                    my @prefixes = qw(Shad Vel Mor Xyl Eld Zar Thar Lur Vor Dra Thrax Amun Grim);
                    my @middles = qw(rax drim vath ris ros vok nis rok rath lor amun);
                    my @suffixes = qw(thar is al ar os eth or ith as ok dar ra);

                    my $random_name = ucfirst($prefixes[int(rand(@prefixes))] .
                                            $middles[int(rand(@middles))] .
                                            $suffixes[int(rand(@suffixes))]);

                    $npc->TempName($random_name);
                    $owner->SetBucket("spectre_name_$pet_counts{'spectres'}", $random_name);
                }
            }
        }

        # Animations 
        if (grep { $_ == $npc->GetPetSpellID() } @animations) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("animation_name");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    #$owner->SetBucket("animation_name", $npc->GetName());
                }
            }
        } 

        # Animated Swords 
        if (grep { $_ == $npc->GetPetSpellID() } @animated_swords) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("animated_sword_name");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    #$owner->SetBucket("animated_sword_name", $npc->GetName());
                }
            }
        } 

        # Hammers 
        if (grep { $_ == $npc->GetPetSpellID() } @hammers) {
            if ($owner) {
                my $pet_name = $owner->GetBucket("hammer_name");
                if ($pet_name) {
                    $npc->TempName($pet_name);
                } else {
                    #$owner->SetBucket("hammer_name", $npc->GetName());
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
