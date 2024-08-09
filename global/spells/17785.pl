sub EVENT_SPELL_EFFECT_CLIENT {
    quest::debug("spell_id " . $spell_id);

    $client->ConsumeItemOnCursor();
}