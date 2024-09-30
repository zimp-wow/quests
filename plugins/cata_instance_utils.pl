# Agent of Retribution Library

sub OfferStandardInstance {
  my $client          = plugin::val('$client');
  my $npc             = plugin::val('$npc');
  my $text            = plugin::val('$text');
  my $zonesn          = plugin::val('$zonesn');
  my $dz_version      = 0;
  my $dz_duration     = 64800; # 18 hours
  my $dz_lifetime     = 604800;
  my ($expedition_name, $min_players, $max_players, $dz_zone, $x, $y, $z, $heading) = @_;

  if (plugin::IsSeasonal($client) || plugin::MultiClassingEnabled()) {
    $max_players = 6;
  }

  if ($text =~ /hail/i) {
    my $dz = $client->GetExpedition();
    if ($dz && ($dz->GetName() eq $expedition_name || $dz->GetName() eq ($expedition_name . " (Static)"))) {
      quest::say("When you are [" . quest::saylink("ready", 1) . "], proceed into the portal.");
    }
    else {
      quest::say("I offer you a Trial. $expedition_name lies before you, do you accept the challenge?");
      plugin::YellowText("You can select from [". quest::saylink('Respawning', 1). "] or [".quest::saylink('Non-Respawning',1). "] versions.");
    }
  }

  elsif ($text eq 'Respawning' || $text eq 'Non-Respawning') {
    if ($text eq 'Non-Respawning') {
      $dz_version = quest::get_rule("Custom:StaticInstanceVersion") || 100;
      quest::debug("$dz_version");
      $expedition_name = $expedition_name . " (Static)";
    }
    
    my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_lifetime, $expedition_name, $min_players, $max_players);
    if ($dz) {
      $dz->SetCompass($zonesn, $npc->GetX(), $npc->GetY(), $npc->GetZ());
      $dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
      $dz->AddReplayLockout($dz_duration);
      quest::say("Very well. When you are [" . quest::saylink("ready", 1) . "], proceed into the portal, and remember!");
    }
  }

  elsif ($text =~ /ready/i) {
    my $dz = $client->GetExpedition();
    if ($dz && ($dz->GetName() eq $expedition_name || $dz->GetName() eq ($expedition_name . " (Static)"))) {
      
      # Fallback to safe zone coordinates if x, y, z, or heading are not defined
      my $final_x = defined $x ? $x : quest::GetZoneSafeX($dz->GetZoneID());
      my $final_y = defined $y ? $y : quest::GetZoneSafeY($dz->GetZoneID());
      my $final_z = defined $z ? $z : quest::GetZoneSafeZ($dz->GetZoneID());
      my $final_heading = defined $heading ? $heading : quest::GetZoneSafeHeading($dz->GetZoneID());

      $client->MovePCInstance($dz->GetZoneID(), $dz->GetInstanceID(), $final_x, $final_y, $final_z, $final_heading);
    }
  }  
}
