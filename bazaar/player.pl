sub EVENT_ENTERZONE {
  quest::settimer("ZoneIn", 3);
}

sub EVENT_TIMER {
  if ($timer eq "ZoneIn") {
    quest::stoptimer("ZoneIn");
    quest::signalwith(12000173,$charid); # NPC: Zeflmin_Werlikanin Portal Crystals
  }
}

sub EVENT_CLICKDOOR {
    my %portal_destinations = %{ get_portal_destinations() };
    my $destination         = quest::get_data("magic_map_target");
    if ($doorid == 146) {
        if ($destination && exists $portal_destinations{$destination}) {
            my ($destination_name, $popup_id) = @{ $portal_destinations{$destination} };
            quest::popup('Teleport', "Teleport to $destination_name?", $popup_id, 1, 0);
        }
    }
}

sub EVENT_POPUPRESPONSE {
    my %portal_destinations = %{ get_portal_destinations() };
    
    foreach my $info (values %portal_destinations) {
        my ($destination_name, $popup_id, $zone_id, $x, $y, $z, $heading) = @$info;
        if ($popupid == $popup_id) {
            quest::movepc($zone_id, $x, $y, $z, $heading);
            return;
        }
    }
}