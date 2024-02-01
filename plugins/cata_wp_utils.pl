my %suffix_to_pretty_name = (
    'A' => 'Antonica',
    'G' => 'Gunthak',
    'O' => 'Odus',
    'F' => 'Faydwer',
    'K' => 'Kunark',
    'V' => 'Velious',
    'L' => 'Luclin',
    'P' => 'The Planes',
    'T' => 'Taelosia',
    'D' => 'Discord',
);

sub get_suffixes {
    return ('A', 'G', 'O', 'F', 'K', 'V', 'L', 'P', 'T', 'D'); 
}

sub get_continent_by_suffix {
    my ($suffix) = @_;  

    return $suffix_to_pretty_name{$suffix} || $suffix;
}

sub get_suffix_by_continent {
    my ($continent) = @_;
    
    my %suffix_by_continent;
    foreach my $suffix (keys %suffix_to_pretty_name) {
        my $pretty_name = $suffix_to_pretty_name{$suffix};
        $suffix_by_continent{$pretty_name} = $suffix;
    }

    return $suffix_by_continent{$continent} || $continent;
}

# Get a map of zone data for each suffix
sub get_zone_data {
    my ($accountID) = @_;
    my %zone_data_by_suffix;

    foreach my $suffix (get_suffixes()) {
        my $teleport_zones = get_zone_data_for_account($accountID, $suffix);
        $zone_data_by_suffix{$suffix} = $teleport_zones;
    }

    return \%zone_data_by_suffix;
}

sub get_flat_data {
    my ($accountID) = @_;
    my %all_elements;

    # Get the nested hashes from get_zone_data
    my $zone_data = get_zone_data($accountID);

    foreach my $suffix (keys %{$zone_data}) {
        my $teleport_zones = $zone_data->{$suffix};

        foreach my $key (keys %{$teleport_zones}) {
            $all_elements{$key} = $teleport_zones->{$key};            
        }
    }

    return \%all_elements;
}

# Check if a particular piece of data (by zone description) is present
sub has_zone_entry {
    my ($accountID, $zone_desc, $suffix) = @_;
    my $teleport_zones = get_zone_data_for_account($accountID, $suffix);

    return exists($teleport_zones->{$zone_desc});
}

# Get character's saved zone data
sub get_zone_data_for_account {
    my ($accountID, $suffix) = @_;
    my $charKey = $accountID . "-TL-Account-" . $suffix;

    my $charDataString = quest::get_data($charKey);

    my %teleport_zones;
    my @zone_entries = split /:/, $charDataString;

    foreach my $entry (@zone_entries) {
        my @tokens = split /,/, $entry;
        $teleport_zones{$tokens[0]} = [@tokens[1..$#tokens]];
    }

    return \%teleport_zones;
}

# Add (or overwrite) data to teleport_zones
# Usage:
#    add_zone_entry(12345, "Zone4", ['data7', 'data8'], '-K');
sub add_zone_entry {
    my ($accountID, $zone_name, $zone_data, $suffix) = @_;
    my $teleport_zones = get_zone_data_for_account($accountID, $suffix);
    $teleport_zones->{$zone_name} = $zone_data;
    set_zone_data_for_account($accountID, $teleport_zones, $suffix);
}

sub set_zone_data_for_account {
    my ($accountID, $zone_data_hash_ref, $suffix) = @_;
    my $charKey = $accountID . "-TL-Account-" . $suffix;

    my @data_entries;

    while (my ($desc, $zone_data) = each %{$zone_data_hash_ref}) {
        my $entry = join(",", $desc, @{$zone_data});
        push @data_entries, $entry;
    }

    my $charDataString = join(":", @data_entries);

    quest::set_data($charKey, $charDataString);
}