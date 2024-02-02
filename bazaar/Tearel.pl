sub EVENT_SAY {
  my $continent_regex = join('|', map { my $continent = plugin::get_continent_by_suffix($_); $continent =~ s/\s+//g; quotemeta($continent) } plugin::get_suffixes());
  my $zone_data       = plugin::get_zone_data($client->AccountID());
  my $flat_data       = plugin::get_flat_data($client->AccountID());

  quest::debug($continent_regex);
  
  if ($client->GetGM()) {
  if ($text=~/hail/i) { 
    quest::say("Greetings $name! I can help you get to almost anywhere! I sell
                    [teleportion stones] which, when handed back to me, will attune this magic map 
                    to several notable places that I've visted before. If you are a more experienced adventurer however, 
                    I can [transport you] or [your group] to places that you have visted, in this life or in others, 
                    and attuned yourself to by discovering Rune Circles.");
  }

  elsif ($text=~/teleportion stones/i) {
    quest::say("Absolutely. The process is simple! Purchase the teleportation stone of your choosing 
                    then give it to me. I will then enchant the map to take you to your destination! 
                    Simply click on the map afterwards and you will be off!");
  }

  elsif ($text=~/transport you/i || $text=~/your group/i) {
    $client->Message(257, " ------- Select a Continent ------- ");
    # Check for each suffix and add entries if valid zone data exists
    foreach my $suffix (plugin::get_suffixes()) {
        if (exists($zone_data->{$suffix}) && %{ $zone_data->{$suffix} }) {
            my $link_text = plugin::get_continent_by_suffix($suffix);
            my $mode_indicator = $text =~ /group/i ? ":group" : "";
            $client->Message(257, "-[ " . quest::saylink($link_text . $mode_indicator, 0, $link_text));
        }
    }
  }

  elsif ($text =~ /^(.+?)(:group)?$/) { # Capture the location and optional group indicator
      my $location = $1; # This captures the actual location name
      my $is_group_transport = defined $2; # True if it's a group transport

      quest::debug("New capture group. $1, and $2");
      
      # Check if we're in the stage of selecting a location
      if ($continent_data && ref($continent_data) eq 'HASH') {
          $client->Message(257, " ------- Select a Location ------- ");
          foreach my $key (keys %{$continent_data}) {
              my $mode_indicator = $is_group_transport ? ":group" : "";
              $client->Message(257, "-[ " . quest::saylink($key . $mode_indicator, 0, $key));
          }
      }
      
      # Execute transport when a specific location is selected
      if (exists($flat_data->{$location})) {
          if ($is_group_transport) {
              # Group transport logic
              $client->Message(257, "Transporting group to $location");
              # Implement the actual group transport logic here
          } else {
              # Individual transport
              $client->MovePC(quest::GetZoneID($flat_data->{$location}[0]), $flat_data->{$location}[1], $flat_data->{$location}[2], $flat_data->{$location}[3], $flat_data->{$location}[4]);
          }
      }
  }

  }  else {
    if ($text=~/hail/i) { 
      quest::say("Greetings $name! I can help you get to almost anywhere! I sell
                      [teleportion stones] which, when handed back to me, will attune this magic map 
                      to several notable places that I've visted before. If you are a more experienced adventurer however, 
                      I can [transport] you to places that YOU have visted and attuned yourself to by discovering Runes.");
    }

    if ($text=~/teleportion stones/i) {
      quest::say("Absolutely. The process is simple! Purchase the teleportation stone of your choosing 
                      then give it to me. I will then enchant the map to take you to your destination! 
                      Simply click on the map afterwards and you will be off!");
    }
    if ($text=~/transport/i) {
      quest::say("Very good! Tell me about this place that you remember.");
      $client->Message(257, " ------- Select a Continent ------- ");
      # Check for each suffix and add entries if valid zone data exists
      foreach my $suffix (plugin::get_suffixes()) {
          if (exists($zone_data->{$suffix}) && %{ $zone_data->{$suffix} }) {
              $client->Message(257, "-[ " . quest::saylink(plugin::get_continent_by_suffix($suffix), 1));
          }
      }
    }

    if ($text =~ /^($continent_regex)$/i) {
        my $continent = ucfirst(lc($1));
        my $suffix = plugin::get_suffix_by_continent($continent);
        my $continent_data = $zone_data->{$suffix};

        if ($continent_data && ref($continent_data) eq 'HASH') {
            $client->Message(257, " ------- Select a Location ------- ");
            foreach my $key (keys %{$continent_data}) {
                my $value = $continent_data->{$key};
                $client->Message(257, "-[ " . quest::saylink($key, 0));
            }
        }
    }

    if (exists($flat_data->{$text})) {
      $client->MovePC(quest::GetZoneID($flat_data->{$text}[0]), $flat_data->{$text}[1], $flat_data->{$text}[2], $flat_data->{$text}[3], $flat_data->{$text}[4]);
    }
  }
}

sub EVENT_ITEM {
  if(plugin::check_handin(\%itemcount, 10092 => 1)){
    quest::setglobal("ghport$uguild_id",10092,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Plane of Hate');
  } elsif(plugin::check_handin(\%itemcount, 10094 => 1)){
    quest::setglobal("ghport$uguild_id",10094,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Plane of Sky');
  } elsif(plugin::check_handin(\%itemcount, 64191 => 1)){
    quest::setglobal("ghport$uguild_id",64191,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Dragonscale Hills');
  } elsif(plugin::check_handin(\%itemcount, 876000 => 1)){
    quest::setglobal("ghport$uguild_id",876000,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Northern Plains of Karana');
  } elsif(plugin::check_handin(\%itemcount, 876001 => 1)){
    quest::setglobal("ghport$uguild_id",876001,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to East Commonlands');
  } elsif(plugin::check_handin(\%itemcount, 876002 => 1)){
    quest::setglobal("ghport$uguild_id",876002,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Lavastorm Mountains');
  } elsif(plugin::check_handin(\%itemcount, 876003 => 1)){
    quest::setglobal("ghport$uguild_id",876003,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Toxxulia Forest');
  } elsif(plugin::check_handin(\%itemcount, 876004 => 1)){
    quest::setglobal("ghport$uguild_id",876004,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Greater Faydark');
  } elsif(plugin::check_handin(\%itemcount, 876005 => 1)){
    quest::setglobal("ghport$uguild_id",876005,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Dreadlands');
  } elsif(plugin::check_handin(\%itemcount, 876006 => 1)){
    quest::setglobal("ghport$uguild_id",876006,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Iceclad Ocean');
  } elsif(plugin::check_handin(\%itemcount, 876007 => 1)){
    quest::setglobal("ghport$uguild_id",876007,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Cobalt Scar');
  } elsif(plugin::check_handin(\%itemcount, 876009 => 1)){
    quest::setglobal("ghport$uguild_id",876009,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Twilight Sea');
  } elsif(plugin::check_handin(\%itemcount, 876010 => 1)){
    quest::setglobal("ghport$uguild_id",876010,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Stonebrunt Mountains');
  } elsif(plugin::check_handin(\%itemcount, 876011 => 1)){
    quest::setglobal("ghport$uguild_id",876011,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Wall of Slaughter');
  } elsif(plugin::check_handin(\%itemcount, 876012 => 1)){
    quest::setglobal("ghport$uguild_id",876012,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Barindu, Hanging Gardens');
  } elsif(plugin::check_handin(\%itemcount, 876070 => 1)){
    quest::setglobal("ghport$uguild_id",876070,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Undershore');
  } elsif(plugin::check_handin(\%itemcount, 88735 => 1)){
    quest::setglobal("ghport$uguild_id",88735,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Arcstone, Isle of Spirits');
  } elsif(plugin::check_handin(\%itemcount, 88736 => 1)){
    quest::setglobal("ghport$uguild_id",88736,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Goru`kar Mesa');
  } elsif(plugin::check_handin(\%itemcount, 88737 => 1)){
    quest::setglobal("ghport$uguild_id",88737,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to your guild banner');
  } elsif(plugin::check_handin(\%itemcount, 88738 => 1)){
    quest::setglobal("ghport$uguild_id",88738,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Katta Castrum');
  } elsif(plugin::check_handin(\%itemcount, 88739 => 1)){
    quest::setglobal("ghport$uguild_id",88739,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to The Plane of Time');
  } elsif(plugin::check_handin(\%itemcount, 88740 => 1)){
    quest::setglobal("ghport$uguild_id",88740,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Brell\'s Rest');
  }

  elsif(plugin::check_handin(\%itemcount, 976015 => 1)){
    quest::setglobal("ghport$uguild_id",976015,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Field of Bone');
  }

 elsif(plugin::check_handin(\%itemcount, 976014 => 1)){
    quest::setglobal("ghport$uguild_id",976014,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Western Wastes');
  }

 elsif(plugin::check_handin(\%itemcount, 976013 => 1)){
    quest::setglobal("ghport$uguild_id",976013,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Scarlet Desert');
  }

  elsif(plugin::check_handin(\%itemcount, 976010 => 1)){
    quest::setglobal("ghport$uguild_id",976010,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Everfrost');
  }

  elsif(plugin::check_handin(\%itemcount, 976016 => 1)){
    quest::setglobal("ghport$uguild_id",976016,3,"H24");
    quest::emote("takes the crystal from you and mutters some arcane words over it. 'The floating map is now active! Just click on the map and you'll be whisked away to your destination! I hope you don't get motion sickness!'");
    quest::ze(15,'The Guildhall Portal has been aligned to Barindu');
  }  

  plugin::return_items(\%itemcount);
}

#[Sat May 05 10:12:10 2012] LOADING, PLEASE WAIT...
#[Sat May 05 10:12:19 2012] You have entered Guild Hall.
#[Sat May 05 10:12:20 2012] Zeflmin Werlikanin says 'The teleport stone is currently aligned to Greater Faydark.'

sub EVENT_SIGNAL {
  my $pc = $entity_list->GetClientByCharID($signal);
  if ($pc) {
    $uguild_id = $pc->GuildID();
    if(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 10092) { #hateplane
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Plane of Hate.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 10094) { #airplane
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Plane of Sky.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 64191) { #dragonscale
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Dragonscale Hills.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876000) { #karana
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Northern Plains of Karana.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876001) { #ecommons
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to East Commonlands.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876002) { #lavastorm
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Lavastorm Mountains.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876003) { #toxxulia
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Toxxulia Forest.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876004) { #faydark
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Greater Faydark.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876005) { #dreadlands
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Dreadlands.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876006) { #iceclad
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Iceclad Ocean.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876007) { #cobaltscar
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Cobalt Scar.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876009) { #twilight
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Twilight Sea.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876010) { #stonebrunt
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Stonebrunt Mountains.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876011) { #slaughter
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Wall of Slaughter.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 976016) { #barindu
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Barindu, Hanging Gardens.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 876070) { #eastkorlach
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Undershore.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 88735) { #arcstone
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Arcstone, Isle of Spirits.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 88736) { #goru
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Goru`kar Mesa.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 88737) { #guild banner
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to your guild banner.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 88738) { #kattacastrum
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Katta Castrum.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 88739) { #potimea
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to The Plane of Time.\'');
    } elsif(defined $qglobals{"ghport$uguild_id"} && $qglobals{"ghport$uguild_id"} == 88740) { #brellsrest
      $pc->Message(5, $npc->GetCleanName().' says \'The teleport stone is currently aligned to Brell\'s Rest.\'');  
    }
  }
}