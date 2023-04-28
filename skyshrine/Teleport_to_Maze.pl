
$instanceid = quest::GetInstanceID();


sub EVENT_SAY {
   if($text=~/hail/i)   {
		quest::say("I can grant you passage to the [maze]! This is helpful for Skyshrine class armor quests. Only use this in the Open World, not DZ's!");
   }
   elsif($text=~/maze/i)	{
		quest::MovePCInstance(114, $instanceid, -239, 743, 258, 127);
   }
}