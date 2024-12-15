sub EVENT_SPELL_EFFECT_CLIENT {
	# Spell-EVENT_SPELL_EFFECT_CLIENT
	# Exported event variables
	quest::debug("spell_id " . $spell_id);
	quest::debug("caster_id " . $caster_id);
	quest::debug("tics_remaining " . $tics_remaining);
	quest::debug("caster_level " . $caster_level);
	quest::debug("buff_slot " . $buff_slot);
	quest::debug("spell " . $spell);

    # define a hash of itemid -> weights
    # 700012 -> 1
    # 700013 -> 1
    # 700010 -> 1
    # 700011 -> 1
    # 700017 -> 1
    # 700018 -> 1
    # 
}