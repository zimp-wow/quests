sub EVENT_CLICKDOOR {
    if ($doorid == 54 && plugin::check_hasitem($client, 19719)) {
        $client->KeyRingAdd(19719);
        return 0;
    }
}