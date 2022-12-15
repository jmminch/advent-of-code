my $line = <>;

for my $c (split //, $line) {
  $counter++ if $c eq '(';
  $counter-- if $c eq ')';
}

print "part 1 result: $counter\n";
