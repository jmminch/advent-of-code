while(<>) {
  chomp;
  if(/(\d+)-(\d+) (.): (.*)/) {
    my ($r0, $r1, $let, $password) = ($1, $2, $3, $4);

    # count number of times let appears in $password.
    my $count = 0;
    for(my $idx = index($password, $let, 0); $idx > -1;
      $idx = index($password, $let, $idx+1)) {
      $count++;
    }
    $part1++ if $count >= $r0 && $count <= $r1;

    # determine if let appears at character index r0-1 or r1-1
    my $x0 = substr($password, $r0-1, 1);
    my $x1 = substr($password, $r1-1, 1);
    $part2++ if $x0 eq $let and $x1 ne $let;
    $part2++ if $x0 ne $let and $x1 eq $let;
  }
}

print "part 1 result: $part1\npart 2 result: $part2\n";
