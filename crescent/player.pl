sub EVENT_CONNECT { 
    if ($client->GetRace() == 330) {
      if ($client->GetDeity() = 208) {
        $client->MovePC(8, 120, 129, -24, 0);
      }
    }

    $client->SendToGuildHall();
  }

  sub EVENT_ZONE {
    $client->SendToGuildHall();
  }

  sub EVENT_ENTERZONE {
    $client->SendToGuildHall();
  }