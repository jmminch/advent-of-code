use strict vars;
use List::Util qw(max);

my $maxMarble = shift // 7194400;
my $players = shift // 423;

my @marbles = ( [ 0, 0 ] );
my @scores = ( 0 x $players );

my $ptr = 0;
my $player = 0;
for my $id (1..$maxMarble) {

  if($id % 23) {
    $ptr = $marbles[$ptr]->[1];

    $marbles[$id] = [ $ptr, $marbles[$ptr]->[1] ];

    $marbles[$marbles[$ptr]->[1]]->[0] = $id;
    $marbles[$ptr]->[1] = $id;

    $ptr = $id;
  } else {
    $scores[$player] += $id;

    for my $i (1..7) {
      $ptr = $marbles[$ptr]->[0];
    }

    $marbles[$marbles[$ptr]->[0]]->[1] = $marbles[$ptr]->[1];
    $marbles[$marbles[$ptr]->[1]]->[0] = $marbles[$ptr]->[0];

    $scores[$player] += $ptr;
    $ptr = $marbles[$ptr]->[1];
  }

  $player++;
  $player = 0 if $player >= $players;
}

printf "High score: %d\n", max(@scores);
