
$instanceid = quest::GetInstanceID();

sub EVENT_SAY {
if($text=~/hail/i) {
$client->Message(9,"Hail $name! Currently, the teleporters in this zone don't work if you are in an instance (DZ.) If you go over a teleporter, chances are you will crash and need to use the character mover tool (check link on Discord.) I can offer you a [free ride] to the courtyard to assist. No, you will not need a Ring of Torden!");
}
if($text=~/free ride/i) {
quest::MovePCInstance(209, $instanceid, 122, -4, -640, 100);
}
}
