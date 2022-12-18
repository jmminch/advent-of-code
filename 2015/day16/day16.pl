my %props = (
  children => 3,
  cats => 7,
  samoyeds => 2,
  pomeranians => 3,
  akitas => 0,
  vizslas => 0,
  goldfish => 5,
  trees => 3,
  cars => 2,
  perfumes => 1 );

while(<>) {
  if(/Sue (\d+)/) {
    my $sue = $1;

    my $part1 = 1;
    while(/(\w+): (\d+)/g) {
      if($props{$1} != $2) {
        $part1 = 0;
        last;
      }
    }
    print "part 1 result: $sue\n" if $part1;

    pos() = 0;

    my $part2 = 1;
    while(/(\w+): (\d+)/g) {
      if($1 eq 'cats' or $1 eq 'trees') {
        if($2 <= $props{$1}) {
          $part2 = 0;
          last;
        }
      } elsif($1 eq 'pomeranians' or $1 eq 'goldfish') {
        if($2 >= $props{$1}) {
          $part2 = 0;
          last;
        }
      } else {
        if($2 != $props{$1}) {
          $part2 = 0;
          last;
        }
      }
    }

    print "part 2 result: $sue\n" if $part2;

  }
}
