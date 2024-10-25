# Fading Memories
sub EVENT_SPELL_EFFECT_CLIENT {
    $client->SetEntityVariable("bazaar_fade_timer", time()+60);
}