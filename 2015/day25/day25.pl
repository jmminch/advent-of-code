my $index = 17850354;

my $result = 20151125;
for my $idx (2..$index) {
  $result *= 252533;
  $result %= 33554393;
}

print "part 1 result: $result\n";
