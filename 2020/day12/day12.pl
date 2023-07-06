my @actions = <>;

# part 1
my @dirs = ( [0,-1], [1,0], [0,1], [-1,0] );
my $face = 1;
my $x = 0;
my $y = 0;

for $act (@actions) {
  $act =~ /([A-Z])(\d+)/;
  $y -= $2 if $1 eq 'N';
  $y += $2 if $1 eq 'S';
  $x -= $2 if $1 eq 'W';
  $x += $2 if $1 eq 'E';
  $face += int($2 / 90) if $1 eq 'R';
  $face -= int($2 / 90) if $1 eq 'L';
  $face %= 4;
  $x += $2 * $dirs[$face]->[0] if $1 eq 'F';
  $y += $2 * $dirs[$face]->[1] if $1 eq 'F';
}

printf "part 1 result: %d\n", abs($x) + abs($y);

# part 2
$x = 0; $y = 0;
my $wx = 10;
my $wy = -1;
my @cos = ( 1, 0, -1, 0 );
my @sin = ( 0, 1, 0, -1 );

for $act (@actions) {
  $act =~ /([A-Z])(\d+)/;
  $wy -= $2 if $1 eq 'N';
  $wy += $2 if $1 eq 'S';
  $wx -= $2 if $1 eq 'W';
  $wx += $2 if $1 eq 'E';
  $x += $wx * $2 if $1 eq 'F';
  $y += $wy * $2 if $1 eq 'F';
  if($1 eq 'L' || $1 eq 'R') {
    my $rot = int((($1 eq 'L') ? -$2 : $2) / 90) % 4;
    $nx = $wx * $cos[$rot] - $wy * $sin[$rot];
    $ny = $wy * $cos[$rot] + $wx * $sin[$rot];
    $wx = $nx; $wy = $ny;
  }
}

printf "part 2 result: %d\n", abs($x) + abs($y);
