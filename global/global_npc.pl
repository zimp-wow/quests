sub EVENT_KILLED_MERIT {
    my %item_drops = (
        976011 => { #Fading Green Memory 976011
            'drop_chance' => 0.001, # 1/1000% chance to drop
            'min_level'   => 1, # Minimum level to drop from
            'max_level'   => 99, # Maximum level to drop from
        },

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
                $npc->AddItem($item_id); # Add the item to the NPC's inventory
                quest::ding(); # Play the 'ding' sound, indicating an item drop or another significant event
            }
        }
    }
}

sub EVENT_SPAWN {
    plugin::CheckWorldWideBuffs($npc);
}