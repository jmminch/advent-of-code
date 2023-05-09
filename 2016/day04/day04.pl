my @rooms = <>;

my $part1 = 0;

for my $room (@rooms) {
  next if not $room =~ /([a-z\-]+)-(\d+)\[([a-z]{5})\]/;
  my ($name, $id, $cksum) = ($1, $2, $3);
  if($cksum eq checksum($name)) {
    $part1 += $id;
    print decode($name, $id), " - $id\n";
  }
}

print "Part 1 result: $part1\n";

sub checksum {
  my $name = $_[0];
  my @counts;
  
  # first count up all instances of the letters.
  while($name =~ /([a-z])/g) {
    my $c = $1;
    $counts[ord($c) - ord('a')]++;
  }

  # create a list of [ letter, count ] for sorting.
  for $i (0..$#counts) {
    $counts[$i] = [ chr($i + ord('a')) , $counts[$i] ];
  }

  # now sort that list, first by count, and then alphabetically.
  my @sorted = sort {
    return 1 if $b->[1] > $a->[1];
    return -1 if $b->[1] < $a->[1];
    return $a->[0] cmp $b->[0];
  } @counts;

  my $cksum;
  for my $i (0..4) {
    $cksum .= $sorted[$i]->[0];
  }
  return $cksum;
}

sub decode {
  my ($name, $id) = @_;
  my $r;
  for my $c (split //, $name) {
    if($c eq '-') {
      $r .= " ";
    } else {
      my $val = ((ord($c) - ord('a')) + $id) % 26;
      $r .= chr($val + ord('a'));
    }
  }

  return $r;
}
