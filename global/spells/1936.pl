sub EVENT_SPELL_EFFECT_CLIENT {
    my $slot = $client->FindMemmedSpellBySpellID(1936);
    if ($slot < 0) {
        $client->ScribeSpell(1936, $client->GetFreeSpellBookSlot(), 1);
    }
}