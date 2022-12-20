sub EVENT_CONNECT {

    $client->SendToGuildHall();
  }

  sub EVENT_ZONE {
    $client->SendToGuildHall();
  }