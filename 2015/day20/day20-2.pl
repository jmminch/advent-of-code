my $target = shift // 29000000;
my $verbose = shift;

my @houses = ( 0 ) x 1000000;
my $elf = 0;

# we can only check the house with the same number as the current elf, as
# later house numbers are still subject to change.
while($houses[$elf] < $target) {
  $elf++;
  for(my $i = 1, my $h = $elf; $i <= 50; $i++, $h += $elf) {
    $houses[$h] += $elf * 11;
  }

  if(($elf & 0xfff) == 0) {
    print "$elf $houses[$elf]\n" if $verbose eq 'v';
  }
}

print "part 2 result: $elf\n";
