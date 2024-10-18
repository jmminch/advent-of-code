#!/usr/bin/perl

use strict 'vars';
my $disk1Len = 272;
my $disk2Len = 35651584;

my $input = shift // '10001001100000001';
my $data = $input;

# Repeatedly expand the data until enough data has been generated.
# assumes disk2len > disk1len
while(length $data < $disk2Len) {
  $data = generate($data);
}

printf "Part 1 result: %d\n", checksum(substr($data, 0, $disk1Len));
printf "Part 2 result: %d\n", checksum(substr($data, 0, $disk2Len));

sub generate {
  my $data = $_[0];
  my $dataLen = length $data;

  my @newData;
  @newData = map { (int $_) ? 0 : 1 } reverse split //, $data;
  return $data . '0' . join('', @newData);
}

sub checksum {
  my $data = $_[0];

  # Repeatedly process the string until it has an odd length.
  do {

    my @checksum;
    # Step through the string two characters at a time.
    for(my $i = 0; $i < length $data; $i += 2) {
      my $x = substr($data, $i, 2);
      push @checksum, ($x eq '00' || $x eq '11') ? 1 : 0;
    }
    $data = join('', @checksum);
    
  } while((length($data) % 2) == 0);

  return $data;
}
