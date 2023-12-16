use strict vars;

# Part 1 - sum of hashes of all steps
my $part1 = 0;
my $input = <>;
chomp $input;
for my $s (split /,/, $input) {
  $part1 += hash($s);
}
print "Part 1 result: $part1\n";

# Part 2
my @boxes = ( );
LOOP: for my $s (split /,/, $input) {
  if($s =~ /(\w+)-/) {
    # Remove a lens from a box.
    my $lbl = $1;
    my $id = hash($lbl);
    for my $i (0..$#{$boxes[$id]}) {
      if($boxes[$id]->[$i]->[0] eq $lbl) {
        splice @{$boxes[$id]}, $i, 1;
        next LOOP;
      }
    }
  } elsif($s =~ /(\w+)=(\d+)/) {
    # Replace an existing lens if there is one.
    my $lbl = $1;
    my $lens = $2;
    my $id = hash($lbl);
    for my $i (0..$#{$boxes[$id]}) {
      if($boxes[$id]->[$i]->[0] eq $lbl) {
        $boxes[$id]->[$i]->[1] = $lens;
        next LOOP;
      }
    }
    
    # Append a new lens to the list
    push @{$boxes[$id]}, [ $lbl, $lens ];
  }
}

# calculate the focusing power
my $part2 = 0;
for my $box (0..$#boxes) {
  for my $i (0..$#{$boxes[$box]}) {
    # note that box number and lens slot number are 1-based
    $part2 += ($box + 1) * ($i + 1) * $boxes[$box]->[$i]->[1];
  }
}

print "Part 2 result: $part2\n";


sub hash {
  my $r = 0;
  for my $ch (split //, $_[0]) {
    $r = (($r + ord($ch)) * 17) % 256;
  }
  return $r;
}
