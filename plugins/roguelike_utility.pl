my $crushbone_task = 50000;
my @task_list = ($crushbone_task);
my %task_zones = ($crushbone_task, "crushbone");

sub RL_StartTask {
	my ($client, $task_id) = @_;
	my $dz_name = "Roguelike";
	my $dz_version = quest::get_rule("Custom:FarmingInstanceVersion") || 100;

	my $task_zone = $task_zones{$task_id};
	quest::debug($task_id. " ".$task_zone);
	if(not defined $task_zone) {
		return;
	}

	$client->AssignTask($task_id);
	if(!$client->IsTaskActive($task_id)) {
		return;
	}

	my $dz = $client->GetExpedition();
	if(defined $dz && $dz->GetName() eq $dz_name && $dz->GetZoneName eq $task_zone) {
		$dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
		$client->MovePCInstance($dz->GetZoneID(), $dz->GetInstanceID(), quest::GetZoneSafeX($dz->GetZoneID()), quest::GetZoneSafeY($dz->GetZoneID()), quest::GetZoneSafeZ($dz->GetZoneID), quest::GetZoneSafeHeading($dz->GetZoneID));
		return;
	}

	my $dz = $client->CreateExpedition($task_zone, $dz_version, 604800, "Roguelike", 0, 1);
	if(defined $dz) {
		$dz->AddReplayLockout(2 * 60 * 60);
		$dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
		$client->MovePCInstance($dz->GetZoneID(), $dz->GetInstanceID(), quest::GetZoneSafeX($dz->GetZoneID()), quest::GetZoneSafeY($dz->GetZoneID()), quest::GetZoneSafeZ($dz->GetZoneID), quest::GetZoneSafeHeading($dz->GetZoneID));
		return;
	}
}

sub RL_GetActiveTask {
	my ($client) = @_;
	foreach $task(@task_list) {
		if($client->IsTaskActive($task)) {
			return $task;
		}
	}

	return -1;
}

sub RL_GetTargetZone {
	my ($task_id) = @_;
	if(exists($task_zones{$task_id})) {
		return $task_zones{$task_id};
	}

	return "";
}
