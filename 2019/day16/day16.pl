#!/usr/bin/perl

use strict vars;

my $input = <>;
chomp $input;
our @digits = split //, $input;

my $part1 = [ @digits ];
for my $i (1..100) {
  $part1 = fft($part1);
}
printf "Part 1 result: %s\n", join('', @{$part1}[0..7]);

exit 0;
# Note that the part 2 version blows up for the input; see my notes and use
# day16.c to calculate part 2.

print "Part 2 result: ";
my $offset = int(join('', @digits[0..6]));
for my $i ($offset..$offset+7) {
  print fft2At(100, $i);
}
print "\n";

sub fft {
  my $digits = $_[0];
  my @output;

  for my $i (1..$#$digits + 1) {
    # For each digit:
    # start at index $i, and add the next $i numbers
    # skip $i numbers
    # subtract the next $i numbers
    # skip $i numbers
    # repeat
    my $tmp = 0;
    my $j = $i - 1;
    while($j <= $#$digits) {
      for my $x (1..$i) {
        last if $j > $#$digits;
        $tmp += $digits->[$j];
        $j++;
      }

      $j += $i;

      for my $x (1..$i) {
        last if $j > $#$digits;
        $tmp -= $digits->[$j];
        $j++;
      }

      $j += $i;
    }

    $tmp = -$tmp if $tmp < 0;
    $tmp %= 10 if $tmp > 9;
    push @output, $tmp;
  }

  return \@output;
}

sub getDigit {
  my ($data, $digit) = @_;
  if($digit < $data->{prefixLen}) {
    return $data->{prefix}->{$digit};
  } else {
    return $data->{loop}->[($digit - $data->{prefixLen}) % $data->{loopLen}];
  }
}

sub fft2 {
  my $data = $_[0];
  my $out = { };
  
  # Use 30 repetitions of the loop data, which from my testing is sufficient.
  my $digits = $data->{prefixLen} + $data->{loopLen} * 30;

  my $i = 0;
  my %sums;
  my $sum = 0;
  while(1) {

    # Generate one digit of data.
    my $digit = 0;
    for(my $j = $i; $j < $digits; $j++) {
      for my $x (1..$i+1) {
        last if $j >= $digits;
        $digit += getDigit($data, $j);
        $j++;
      }

      $j += $i + 1;

      for my $x (1..$i+1) {
        last if $j >= $digits;
        $digit -= getDigit($data, $j);
        $j++;
      }

      $j += $i + 1;
    }
    $digit = -$digit if $digit < 0;
    $digit %= 10 if $digit > 9;

    # Add this digit to the output prefix
    push @{$out->{prefix}}, $digit;

    # Update the sum for the most recent 50 digits
    if($i < 50) {
      $sum += $digit;
    } else {
      $sum += $digit - $out->{prefix}->[$i - 50];
    }

    if(exists $sums{$sum} && $i > 100) {
      # Potential loop found; verify it.
      my $x = $sums{$sum} - 49;
      my $y = $i - 49;
      my $loop = 1;
      for my $j (1..50) {
        if($out->{prefix}->[$x + $j] != $out->{prefix}->[$y + $j]) {
          $loop = 0;
        }
      }

      if($loop) {
        # Found a loop! We're done
        $out->{loopLen} = $i - $sums{$sum};
        $out->{loop} = [ splice @{$out->{prefix}}, -($i - $sums{$sum}) ];
        return $out;
      }
    }

    $sums{$sum} = $i;

    $i++;
  }
}

our @cache;
our $cacheCount = 0;

sub fft2At {
  my ($step, $digit) = @_;

  if(ref $cache[$step] && $cache[$step]->[$digit] > 0) {
    return $cache[$step]->[$digit] - 1;
  }

  my $len = (scalar @digits) * 10000;

  if($step == 0) {
    # The input digits
    return $digits[$digit % scalar @digits];
  }

  if($digit == $len - 1) {
    # Last digit stays the same.
    return $digits[-1];
  }

  my $r = ((fft2At($step - 1, $digit) + fft2At($step, $digit + 1)) % 10);

  if(!ref $cache[$step]) {
    $cache[$step] = [ ];
    $#{$cache[$step]} = $len - 1;
  }

  $cache[$step]->[$digit] = $r + 1;

  $cacheCount++;
  print "$step $cacheCount\n";
  return $r;
}
