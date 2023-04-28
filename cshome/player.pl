
sub EVENT_TRADE {
	$ssfkey = $client->AccountID() . "ssf";
	if (quest::get_data($ssfkey) == "") {
	$client->Disconnect();	
	}

}
