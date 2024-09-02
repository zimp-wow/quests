sub EVENT_TIMER {
    my $interval = 10;
    if ($timer eq 'despawn') {
        # Start the countdown when 14 minutes have passed (60 seconds remaining)
        $npc->SetTimer("countdown", $interval);  # Start a 10-second interval timer
        $npc->SetEntityVariable("countdown_time", 60);  # Store remaining time in a variable
        $npc->StopTimer('despawn');
    }
    elsif ($timer eq 'countdown') {
        my $remaining_time = $npc->GetEntityVariable("countdown_time");

        # Check if it's time to depop
        if ($remaining_time <= 0) {
            $npc->Depop();  # Despawn the NPC
            $npc->StopTimer("countdown");  # Stop the countdown timer
            quest::say("Your Resupply Agent license has expired!");
        } else {
            quest::say("Your Resupply Agent license will expire in $remaining_time seconds!");
            # Update the remaining time
            $remaining_time -= $interval;
            $npc->SetEntityVariable("countdown_time", $remaining_time);
        }
    }
}