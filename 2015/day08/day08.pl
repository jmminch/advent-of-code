my @lines = <>;
chomp @lines;

my $total = 0;
for $_ (@lines) {
  while(/\\(.)/g) {
    if($1 ne '\\' && $1 ne '"' && $1 ne 'x') {
      print "Can't handle the following ($1) $_\n";
      die;
    }
  }

  my $s = eval($_);
  $total += length($_) - length($s);
}

print "part 1 result: $total\n";

$total = 0;
for $_ (@lines) {
  my $len = length($_);
  s/(["\\])/\\\1/g;
  $_ = "\"$_\"";
  $total += length($_) - $len;
}

print "part 2 result: $total\n";
