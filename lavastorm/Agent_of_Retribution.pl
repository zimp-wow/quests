my $expedition_name = "Nagafen's Lair";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "soldungb";
my $dz_version      = 0;
my $dz_duration     = 79200; # 22 hours

sub EVENT_SAY {
  if (plugin::IsSeasonal($client) || plugin::MultiClassingEnabled()) {
    $max_players = 6;
  }

  if ($text =~ /hail/i) {
    my $dz = $client->GetExpedition();
    if ($dz && $dz->GetName() eq $expedition_name) {
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
    else {
      quest::say("Would you like to challenge a pocket dimension of $expedition_name? You can select from [Respawning] or [Non-Respawning] versions.");
    }
  }
  elsif ($text eq 'Respawning' || $text eq 'Non-Respawning') {
    if ($text eq 'Non-Respawning') {
      $dz_version = 10;
      $expedition_name = $expedition_name . " (Static)";
    }
    
    my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
    if ($dz) {
      $dz->SetCompass($zonesn, $npc->GetX(), $npc->GetY(), $npc->GetZ());
      $dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
      $dz->AddReplayLockout(79200);
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
  elsif ($text =~ /ready/i) {
    $client->MovePCDynamicZone($dz_zone);
  }
}