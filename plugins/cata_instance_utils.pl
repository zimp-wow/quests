# Agent of Retribution Library

sub OfferStandardInstance {
  my $client          = plugin::val('$client');
  my $npc             = plugin::val('$npc');
  my $text            = plugin::val('$text');
  my $zonesn          = plugin::val('$zonesn');
  my $dz_version      = 0;
  my $dz_duration     = 79200; # 22 hours
  my ($expedition_name, $min_players, $max_players, $dz_zone) = @_;

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
      $dz_version = 100;
      $expedition_name = $expedition_name . " (Static)";
    }
    
    my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
    if ($dz) {
      $dz->SetCompass($zonesn, $npc->GetX(), $npc->GetY(), $npc->GetZ());
      $dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
      $dz->AddReplayLockout($dz_duration);
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
}