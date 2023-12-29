# Basic Design
# EoM (Server-Wide) buffs work by three methods;
# 1) Send a worldwide client signal, global_player catches it and applies the requested buffs
# 2) Set a bucket value with a 4 hour expiration.
# 3) Zone and Login methods in global_player apply the requested buffs with the requested durations

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

    my $link_services 	 = "[".quest::saylink("link_services", 1, "services")."]";

    if($text=~/hail/i) {   
        ApplyWorldWideBuff(43002);



    }

    elsif ($text eq "link_services") {

    }

    if ($response) {
        plugin::Whisper($response);
    }
}

sub ApplyWorldWideBuff {
    my $buff_id = shift;

    quest::worldwidesignalclient($buff_id);
    quest::set_data("eom_$buff_id", 1, H4);
}