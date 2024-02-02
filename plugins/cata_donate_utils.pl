my $eom_id = 6;
my $eom_log = "total-eom-spend";

# Spend EOM. Returns true on success, false on failure
# usage: plugin::SpendEOM($client, $amount)
sub SpendEOM {
    my ($client, $amount) = @_;
    my $eom_available = $client->GetAlternateCurrencyValue($eom_id);

    if ($eom_available >= $amount) {
        $client->SetAlternateCurrencyValue($eom_id, $eom_available - $amount); # Use $amount instead of hardcoding 5
        $client->Message(15, "You have SPENT $amount [".quest::varlink(46779)."]."); # Reflect the dynamic $amount

        if (!$client->GetGM()) {
            my $current_eom_spend = quest::get_data($eom_log) || 0; # Defaults to 0 if not previously set
            quest::set_data($eom_log, $current_eom_spend + $amount);
        }

        return 1;
    }
    return 0;
}