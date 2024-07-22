sub EVENT_CLICKDOOR {
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    my $destination         = quest::get_data("magic_map_target");
    if ($doorid == 146) {
        if ($destination && exists $portal_destinations{$destination}) {
            my ($destination_name, $portalid) = @{ $portal_destinations{$destination} };
            quest::popup('Teleport', "Teleport to $destination_name?", $portalid, 1, 0);
        }
    }
}

sub EVENT_POPUPRESPONSE {
    my %portal_destinations = %{ plugin::get_portal_destinations() };
    
    foreach my $info (values %portal_destinations) {
        my ($destination_name, $portalid, $zone_id, $x, $y, $z, $heading) = @$info;
        quest::debug("popupid? $popupid");
        quest::debug("popup_id? $portalid");
        if ($popupid == $portalid) {
            quest::debug("inside popupid? $popuid");
            quest::debug("inside popup_id? $portalid");
            quest::movepc($zone_id, $x, $y, $z, $heading);
            return;
        }
    }
}

sub EVENT_POPUPRESPONSE {
    quest::debug("popupid " . $popupid);
}