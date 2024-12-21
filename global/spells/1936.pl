sub EVENT_SPELL_EFFECT_CLIENT {
    my $slot = $client->FindSpellBookSlotBySpellID(1936);
    if ($slot < 0) {
        $client->ScribeSpell(1936, $client->GetFreeSpellBookSlot(), 1);
    }
}