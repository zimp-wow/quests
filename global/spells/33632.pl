sub EVENT_SPELL_EFFECT_CLIENT {
	# Spell-EVENT_SPELL_EFFECT_CLIENT
	# Exported event variables
	quest::debug("spell_id " . $spell_id);
	quest::debug("caster_id " . $caster_id);
	quest::debug("tics_remaining " . $tics_remaining);
	quest::debug("caster_level " . $caster_level);
	quest::debug("buff_slot " . $buff_slot);
	quest::debug("spell " . $spell);


}

    # define a hash of itemid -> weights
    # 700010 -> 100
    # 700011 -> 100
    # 700012 -> 100
    # 700013 -> 100
    # 700015 -> 100
    # 700016 -> 1
    # 700017 -> 100
    # 700018 -> 100
    # 2001800 -> 1
    # 11010 -> 100
    # 2828 -> 25
    # 2829 -> 25
    # 2830 -> 25
    # 2854 -> 25
    # 2855 -> 25
    # 2856 -> 25
    # 2857 -> 25

    define a subroutine which selects one of these items at random given the weights and returns it.