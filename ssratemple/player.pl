sub EVENT_CLICKDOOR {
    quest::debug("doorid " . $doorid);
    quest::debug("version " . $version);
    quest::debug("door " . $door);

    if ($doorid == 54 && plugin::check_hasitem($client, 19719) && !$client->KeyRingCheck(19719)) {
        $client->KeyRingAdd(19719);
    }
}