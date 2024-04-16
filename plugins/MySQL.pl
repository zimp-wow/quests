use DBI;
use JSON;

sub LoadMysql {
    my $config = load_config("eqemu_config.json");
    
    # Attempt to connect using 'content_database'
    my $connect = try_connect($config, "content_database");
    
    # If connection to 'content_database' fails, try 'database'
    if (!$connect) {
        $connect = try_connect($config, "database");
    }

    return $connect;
}

sub load_config {
    my $config_file = shift;
	open(my $fh, '<', "eqemu_config.json") or die "cannot open file $filename"; {
		local $/;
		$content = <$fh>;
	}
	close($fh);
    return JSON->new->decode($content);
}

sub try_connect {
    my ($config, $label) = @_;
    return unless exists $config->{"server"}{$label};
    
    my $db_config = $config->{"server"}{$label};
    my @required_keys = qw(db host username password);
    return unless all_keys_exist($db_config, @required_keys);
    
    my $dsn = "dbi:mysql:dbname=$db_config->{db};host=$db_config->{host};port=3306";
    my $connect = DBI->connect($dsn, $db_config->{username}, $db_config->{password}, { RaiseError => 0, PrintError => 0 });
    
    return $connect if $connect;
    warn "Connection attempt failed for $label: $DBI::errstr";
    return;
}

sub all_keys_exist {
    my ($hash_ref, @keys) = @_;
    foreach my $key (@keys) {
        return 0 unless defined $hash_ref->{$key};
    }
    return 1;
}
