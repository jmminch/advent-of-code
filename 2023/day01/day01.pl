my $sum;

while(<>) {
  $_ =~ /^[^\d]*(\d)/;
  $d1 = $1;
  $_ =~ /(\d)[^\d]*$/;
  $d2 = $1;
  $sum += $d1 . $d2;
}

print "Result: $sum\n";
