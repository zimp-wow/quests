  my $spawn_x = -30;
  my $spawn_y = -10;
  my $spawn_z = -223;
  my $spawn_h = 130;

sub EVENT_DEATH_COMPLETE {
    my $glyph_id  = quest::spawn2(162232, 0, 0, $spawn_x, $spawn_y, $spawn_z, $spawn_h);
    my $glyph_npc = $entity_list->GetMobID($glyph_id);

    $glyph_npc->Shout("FOOLS! Your doom approaches!");
}