sub EVENT_SPELL_EFFECT_CLIENT {
    quest::debug("spell_id " . $spell_id);
    quest::debug("caster_id " . $caster_id);
    quest::debug("tics_remaining " . $tics_remaining);
    quest::debug("caster_level " . $caster_level);
    quest::debug("buff_slot " . $buff_slot);
    quest::debug("spell " . $spell);

    $client->ConsumeItemOnCursor();
}