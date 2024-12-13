sub RL_GetTaskZones {
	my $crushbone_task = 50000;
	return ($crushbone_task, "crushbone");
}

sub RL_GetTaskList {
	my %task_zones = RL_GetTaskZones();
	my @retVal = ();
	while(my ($task_id, $value) = each(%task_zones)) {
		push(@retVal, $task_id);
	}
	return @retVal;
}

sub RL_GetZoneNPCs {
	my $injured_typeid = 2000914;

	return {"crushbone", [
		[$injured_typeid, 145, -572, 3, 197]
	]};
}

sub RL_GetDZName {
	return "Roguelike";
}

sub RL_StartTask {
	my ($client, $task_id) = @_;
	my $dz_name = RL_GetDZName();
	my $dz_version = quest::get_rule("Custom:FarmingInstanceVersion") || 100;
	my %task_zones = RL_GetTaskZones();

	my $task_zone = $task_zones{$task_id};
	if(! defined $task_zone) {
		return;
	}

	if(!$client->IsTaskActive($task_id)) {
		$client->AssignTask($task_id);
		if(!$client->IsTaskActive($task_id)) {
			quest::whisper("Looks like you've already got your hands full with another task");
			return;
		}
	}

	my $dz = $client->GetExpedition();
	if(defined $dz && $dz->GetName() eq $dz_name && $dz->GetZoneName() eq $task_zone) {
		$dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
		$client->MovePCInstance($dz->GetZoneID(), $dz->GetInstanceID(), quest::GetZoneSafeX($dz->GetZoneID()), quest::GetZoneSafeY($dz->GetZoneID()), quest::GetZoneSafeZ($dz->GetZoneID), quest::GetZoneSafeHeading($dz->GetZoneID));
		return;
	}

	if(defined $dz) {
		quest::whisper("Please abandon your current expedition to proceed");
		return;
	}

	my $dz = $client->CreateExpedition($task_zone, $dz_version, 604800, $dz_name, 0, 1);
	if(defined $dz) {
		$dz->AddReplayLockout(2 * 60 * 60);
		$dz->SetSafeReturn($zonesn, $client->GetX(), $client->GetY(), $client->GetZ(), $client->GetHeading());
		$client->MovePCInstance($dz->GetZoneID(), $dz->GetInstanceID(), quest::GetZoneSafeX($dz->GetZoneID()), quest::GetZoneSafeY($dz->GetZoneID()), quest::GetZoneSafeZ($dz->GetZoneID), quest::GetZoneSafeHeading($dz->GetZoneID));
		return;
	}
}

sub RL_PrepareZone {
	my ($client, $instanceid) = @_;

	my $dz = $client->GetExpedition();
	if(! defined $instanceid || ! defined $dz || $dz->GetInstanceID() != $instanceid || $dz->GetName() ne RL_GetDZName()) {
		quest::debug("Not a roguelike dz");
		return;
	}

	my $zone_name = $dz->GetZoneName();
	my $zone_npcs = RL_GetZoneNPCs();
	my $npclist = $zone_npcs->{$zone_name};
	if(! defined $npclist) {
		quest::debug("Nothing to prepare for ".$zone_name);
		return;
	}
	
	my @idlist = ($npclist->[0]->[0]);
	my $spawned = quest::isnpcspawned(@idlist);
	if($spawned) {
		quest::debug("Detected npcs are already spawned");
		return;
	}

	quest::debug("Spawning npcs");
	foreach my $npc(@{$npclist}) {
		my ($type_id, $x, $y, $z, $heading) = @{$npc};
		quest::spawn2($type_id, $0, 0, $x, $y, $z, $heading);
	}
}

sub RL_GetActiveTask {
	my ($client) = @_;
	foreach $task(RL_GetTaskList()) {
		if($client->IsTaskActive($task)) {
			return $task;
		}
	}

	return -1;
}

sub RL_GetTargetZone {
	my %task_zones = RL_GetTaskZones();
	my ($task_id) = @_;
	if(exists($task_zones{$task_id})) {
		return $task_zones{$task_id};
	}

	return "";
}
