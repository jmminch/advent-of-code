my @lines = <>;

@keypad = qw(XXXXX X123X X456X X789X XXXXX);
$x = 2;
$y = 2;

print "Part 1 result: ", decode(), "\n";

@keypad = qw(XXXXXXX XXX1XXX XX234XX X56789X XXABCXX XXXDXXX XXXXXXX);
$x = 1;
$y = 3;

print "Part 2 result: ", decode(), "\n";

sub decode {
  my %dirs = (
    'U' => [0,-1], 'D' => [0,1], 'L' => [-1,0], 'R' => [1,0]
  );
  my $r = "";

  for my $line (@lines) {
    while ($line =~ /([UDLR])/g) {
      my $d = $1;
      my $nx = $x + $dirs{$d}->[0];
      my $ny = $y + $dirs{$d}->[1];
      if(substr($keypad[$ny], $nx, 1) ne 'X') {
        $x = $nx;
        $y = $ny;
      }
    }
    $r .= substr($keypad[$y], $x, 1);
  }

  return $r;
}
