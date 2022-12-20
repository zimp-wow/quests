my $expedition_name = "Nagafen's Lair";
my $min_players     = 1;
my $max_players     = 72;
my $dz_zone         = "soldungb";
my $dz_version      = 0;
my $dz_duration     = 79200; # 22 hours

sub EVENT_SAY {
  if ($text =~ /hail/i) {
    my $dz = $client->GetExpedition();
    if ($dz && $dz->GetName() eq $expedition_name) {
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
    else {
      quest::say("Would you like to [" . quest::saylink("request") . "] the expedition?");
    }
  }
  elsif ($text =~ /request/i) {
    my $dz = $client->CreateExpedition($dz_zone, $dz_version, $dz_duration, $expedition_name, $min_players, $max_players);
    if ($dz) {
      $dz->SetCompass("lavastorm", 238.0, 987.0, -24.90); # pointing to guard pineshade
      $dz->SetSafeReturn("lavastorm", 245.84, 987.93, -27.6, 484.0); # orc lift in gfay
      $dz->SetZoneInLocation(479.44, -500.18, 5.75, 421.8); # bridge in crushbone
      $dz->AddReplayLockout(79200); # immediately add a 22 hour replay lockout on creation
      quest::say("Tell me when you're [" . quest::saylink("ready") . "] to enter");
    }
  }
  elsif ($text =~ /ready/i) {
    $client->MovePCDynamicZone("soldungb");
  }
}