# Basic Design
# EoM (Server-Wide) buffs work by three methods;
# 1) Send a worldwide client signal, global_player catches it and applies the requested buffs
# 2) Set a bucket value with a 4 hour expiration.
# 3) Zone and Login methods in global_player apply the requested buffs with the requested durations

my $platinum_price = 5000;

sub EVENT_SAY {
    my $response = "";
    my $clientName = $client->GetCleanName();

    my $eom_experience   = quest::get_data('eom_43002');
    my $eom_aego         = quest::get_data('eom_43003');
    my $eom_focus        = quest::get_data('eom_43004');
    my $eom_speed        = quest::get_data('eom_43005');
    my $eom_mana         = quest::get_data('eom_43006');
    my $eom_haste        = quest::get_data('eom_43007');
    my $eom_regen        = quest::get_data('eom_43008');

    if ($text=~/hail/i) {   
        $response = "Hail, Adventurer. I seek to empower your ilk for my own profit. For a [modest fee], I will enhance the power of your group for a time. In exchange for more [exotic payment], I will enhance the power of all adventurers in the world.";
    }
    elsif ($text=~/modest fee/i) {
        $response = "In exchange for $platinum_price platinum, I can cast one of the following enhancements on your group. Each should co-exist with over versions of this type of effect, and will last four hours. Would you like to enhance your [Experience Gain], [Hit Points and Armor Class], [Basic Statistics], [Movement Speed], [Mana Regeneration], [Attack Speed], or [Health Regeneration]?";
    }
    elsif ($text=~/experience gain/i) {
        if (ApplyGroupBuff(43002)) {
            $response = "Enjoy your newfound power!";
        } else {
            $response = "You do not have enough coin to pay for this power.";
        }
    }
    elsif ($text=~/hit points and armor class/i) {
        $response = "Enhancing hit points and armor class will cost you $platinum_price platinum. Are you sure you wish to proceed?";
    }
    elsif ($text=~/basic statistics/i) {
        $response = "Enhancing basic statistics will cost you $platinum_price platinum. Are you sure you wish to proceed?";
    }
    elsif ($text=~/movement speed/i) {
        $response = "Enhancing movement speed will cost you $platinum_price platinum. Are you sure you wish to proceed?";
    }
    elsif ($text=~/mana regeneration/i) {
        $response = "Enhancing mana regeneration will cost you $platinum_price platinum. Are you sure you wish to proceed?";
    }
    elsif ($text=~/attack speed/i) {
        $response = "Enhancing attack speed will cost you $platinum_price platinum. Are you sure you wish to proceed?";
    }
    elsif ($text=~/health regeneration/i) {
        $response = "Enhancing health regeneration will cost you $platinum_price platinum. Are you sure you wish to proceed?";
    }

    if ($response) {
        plugin::Whisper($response);
    }
}

sub ApplyGroupBuff {
    my $buff_id = shift;
    
    if ($client->TakeMoneyFromPP($platinum_price * 1000, 1)) {
        $client->ApplySpell($buff_id, 2400);
        return 1;
    } else {
        return 0;
    }
}


sub ApplyWorldWideBuff {
    my $buff_id = shift;

    quest::worldwidesignalclient($buff_id);
    quest::set_data("eom_$buff_id", 1, H4);
}