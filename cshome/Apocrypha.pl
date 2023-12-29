# Basic Design
# EoM (Server-Wide) buffs work by three methods;
# 1) Send a worldwide client signal, global_player catches it and applies the requested buffs
# 2) Set a bucket value with a 4 hour expiration.
# 3) Zone and Login methods in global_player apply the requested buffs with the requested durations

my $platinum_price = 5000;
my $duration_override = 0; #set this value to override 'regular' buffs duration

sub handle_buff_for_level {
    my $buff_map = {
        70 => [5488, 3125], # add as desired
        60 => [1111, 2222], # example values
        # ... more ...
    };

    my $client_level = $client->GetLevel();
    my $closest_level = 0;

    # Find the closest level in the map, not exceeding the client's level
    foreach my $level (keys %$buff_map) {
        if ($level <= $client_level && $level > $closest_level) {
            $closest_level = $level;
        }
    }

    # If a matching level was found, perform actions with its associated list
    if ($closest_level > 0) {
        my $buffs = $buff_map->{$closest_level};

        # Here, do something with the list of buffs
        foreach my $buff (@$buffs) {
            if ($duration_override) {                
                $client->ApplySpellBuff($buff, $duration_override);
            } else {
                $client->ApplySpellBuff($buff);
            }
        }
    }
}

sub EVENT_SAY {
    my $response = "";
    my $clientName = $client->GetCleanName();

    if ($text=~/hail/i) {   
        $response = "Hail, Adventurer. I seek to empower your ilk for my own profit. For a [modest fee], I will enhance the power of your group for a time. In exchange for more [exotic payment], I will enhance the power of all adventurers in the world.";
    }

    elsif ($text=~/modest fee/i) {
        $response = "In exchange for $platinum_price platinum, I can cast one of the following enhancements on your group. Each should co-exist with over versions of this type of effect, and will last four hours. Would you like to enhance your [Experience Gain], [Hit Points and Armor Class], [Basic Statistics], [Movement Speed], [Mana Regeneration], [Attack Speed], or [Health Regeneration]? Alternatively, if you want me to replicate the [buffs] of other adventuring classes, I can do that, too.";
    }

    elsif ($text=~/exotic payment/i) {
        $response = "In exchange for five [Echo of Memory], I can enchant the entire world! Each should co-exist with over versions of this type of effect, and will last four hours. If the world is already enchanted in this way, purchasing additional enhancement will extend the duration of the current enchantment. Would you like to enhance the [World Experience Gain], [World Hit Points and Armor Class], [World Basic Statistics], [World Movement Speed], [World Mana Regeneration], [World Attack Speed], or [World Health Regeneration]? Alternatively, for twenty-five Echoes, I can cast [all world enchantments]!";
    }

    elsif ($text=~/world experience gain/i) {        
        my $buff_id = 43002;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/world hit points and armor class/i) {
        my $buff_id = 43003;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/world basic statistics/i) {
        my $buff_id = 43004;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/world movement speed/i) {
        my $buff_id = 43005;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/world mana regeneration/i) {
        my $buff_id = 43006;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/world attack speed/i) {
        my $buff_id = 43007;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/world health regeneration/i) {
        my $buff_id = 43008;
        if (ApplyWorldWideBuff($buff_id)) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }
    elsif ($text=~/all world enchantments/i) {
        my $eom_avail = $client->GetAlternateCurrencyValue(6);
        if ($eom_avail >= 25) {
            $response = "Excellent! Your fellow adventurers will appreciate this!";
            $client->SetAlternateCurrencyValue(6, $eom_avail - 25);
            for my $value (43002 .. 43008) {
                ApplyWorldWideBuff($value, 1);                
            }
        } else {
            $response = "You do not have enough [Echo of Memory] to afford that.";
        }
    }

    elsif ($text=~/buffs/i) {
        if ($client->TakeMoneyFromPP($platinum_price * 1000, 1)) {
            $response = "Enjoy your newfound power!";
            handle_buff_for_level();
        } else {
             $response = "You do not have enough coin to pay for this power.";
        }
    }

    elsif ($text=~/experience gain/i) {
        my $buff_id = 43002;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }

    elsif ($text=~/hit points and armor class/i) {
        my $buff_id = 43004;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }
    elsif ($text=~/basic statistics/i) {
        my $buff_id = 43004;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }
    elsif ($text=~/movement speed/i) {
        my $buff_id = 43005;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }
    elsif ($text=~/mana regeneration/i) {
        my $buff_id = 43006;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }
    elsif ($text=~/attack speed/i) {
        my $buff_id = 43007;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }
    elsif ($text=~/health regeneration/i) {
        my $buff_id = 43008;
        if (quest::get_data("eom_$buff_id")) {
            $response = "I am already empowering all adventurers in this manner. It would be pointless for me to enhance you in this way.";
        } else {
            if (ApplyGroupBuff($buff_id)) {
                $response = "Enjoy your newfound power!";
            } else {
                $response = "You do not have enough coin to pay for this power.";
            }
        }
    }

    if ($response) {
        plugin::Whisper($response);
    }
}

sub ApplyGroupBuff {
    my $buff_id = shift;

    if ($client->TakeMoneyFromPP($platinum_price * 1000, 1)) {
        $client->ApplySpellGroup($buff_id, 2400);
        return 1;
    } else {
        return 0;
    }    
}


sub ApplyWorldWideBuff {
    my $buff_id = shift;
    my $skip_payment = shift;
    my $eom_avail = $client->GetAlternateCurrencyValue(6);

    if ($eom_avail < 5 && !$skip_payment) {
        return 0;
    } else {
        if (!$skip_payment) { $client->SetAlternateCurrencyValue(6, $eom_avail - 5); }

        my %buff_types = (
            43002 => "Experience Gain",
            43003 => "Hit Points and Armor Class",
            43004 => "Basic Statistics",
            43005 => "Movement Speed",
            43006 => "Mana Regeneration",
            43007 => "Attack Speed",
            43008 => "Health Regeneration",
        );
        my $buff_type = $buff_types{$buff_id} // "Unknown Buff";  # Fallback for unknown buff IDs

        if (quest::get_data("eom_$buff_id")) {            
            quest::set_data("eom_$buff_id", 1, quest::get_data_remaining("eom_$buff_id") + (4 * 60 * 60));
            my ($hours, $minutes, $seconds) = convert_seconds(quest::get_data_remaining("eom_$buff_id"));
            quest::worldwidemessage(15, $client->GetCleanName() . " has used their Echo of Memory to extend your enhanced $buff_type. This buff will endure for $hours Hours and $minutes Minutes.");
        } else {
            quest::set_data("eom_$buff_id", 1, H4);
            quest::worldwidemessage(15, $client->GetCleanName() . " has used their Echo of Memory to enhance your $buff_type. This buff will endure for 4 Hours.");
        }
        
        quest::worldwidesignalclient($buff_id);
        return 1;
    }
}

sub convert_seconds {
    my ($seconds) = @_;

    my $hours = int($seconds / 3600);
    $seconds %= 3600;
    my $minutes = int($seconds / 60);
    $seconds %= 60;

    return ($hours, $minutes, $seconds);
}
