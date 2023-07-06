my @prog = <>;
my $mask = 0;
my $maskVal = 0;
%mem = ( );

# part 1
for my $line (@prog) {
  if ($line =~ /mask = ([X10]+)/) {
    my $masks = decodeMask($1);
    $mask = $masks->[2];  # all 'X' bits
    $maskVal = $masks->[1];  # all '1' bits
  } elsif ($line =~ /mem\[(\d+)\] = (\d+)/) {
    $mem{$1} = ($2 & $mask) | $maskVal;
  }
}

my $tot = 0;
for my $val (values %mem) {
  $tot += $val;
}
print "part 1 result: $tot\n";


# part 2
%mem = ( );
my $masks = [ 0, 0, 0 ];

for my $line (@prog) {
  if ($line =~ /mask = ([X10]+)/) {
    $masks = decodeMask($1);
  } elsif ($line =~ /mem\[(\d+)\] = (\d+)/) {
    my $addr = $1 & $masks->[0]; # keep bits corresponding to mask value 0
    $addr |= $masks->[1]; # force bits on for mask value 1
    setBits($masks->[2], 0, $addr, $2);
  }
}

$tot = 0;
for my $val (values %mem) {
  $tot += $val;
}
print "part 2 result: $tot\n";

# parse the mask info
sub decodeMask {
  my $maskDef = $_[0];
  my $masks = [ 0, 0, 0 ];

  for my $ch (split //, $maskDef) {
    $masks->[0] <<= 1;
    $masks->[1] <<= 1;
    $masks->[2] <<= 1;
    $masks->[0] |= 1 if $ch eq '0';
    $masks->[1] |= 1 if $ch eq '1';
    $masks->[2] |= 1 if $ch eq 'X';
  }

  return $masks;
}

sub setBits {
  my ($mask, $bit, $addr, $val) = @_;
  my $bitVal = 1 << $bit;
  if($bitVal > $mask) {
    $mem{$addr} = $val;
    return;
  } elsif($mask & $bitVal) {
    $addr &= ~$bitVal;
    setBits($mask, $bit + 1, $addr, $val);
    $addr |= $bitVal;
    setBits($mask, $bit + 1, $addr, $val);
  } else {
    setBits($mask, $bit + 1, $addr, $val);
  }
}
