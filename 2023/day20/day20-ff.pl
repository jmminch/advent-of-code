my $step = 0;
my $ctr = 0;
my $mask = 1 | 4 | 8 | 64 | 256 | 512 | 1024 | 2048;
while(($ctr & $mask) != $mask) {
  $ctr++;
  $step++;
  if(($step % 3917) == 0) {
    $ctr ^= 0xFFFF; # invert bits
  }
}

print "Step: $step\n";
