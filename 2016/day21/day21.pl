#!/usr/bin/perl

my $pt1Input = 'abcdefgh';
my $pt2Input = 'fbgdceah';
my @inst = <>;

printf "Part 1 result: %s\n", scramble(\@inst, $pt1Input, 0);
printf "Part 2 result: %s\n", scramble(\@inst, $pt2Input, 1);

sub scramble {
  my ($inst, $input, $reverse) = @_;

  my @inst = @$inst;
  @inst = reverse @inst if $reverse;

  for (@inst) {
    if(/swap position (\d) with position (\d)/) {
      my $l1 = substr($input, $1, 1);
      substr($input, $1, 1) = substr($input, $2, 1);
      substr($input, $2, 1) = $l1;
    } elsif(/swap letter (.) with letter (.)/) {
      my $idx1 = index($input, $1);
      my $idx2 = index($input, $2);
      my $l1 = substr($input, $idx1, 1);
      substr($input, $idx1, 1) = substr($input, $idx2, 1);
      substr($input, $idx2, 1) = $l1;
    } elsif(/rotate (left|right) (\d+) step/) {
      my $dir = $1;
      my $steps = $2;
      $steps = 8 - $steps if $dir eq 'right';
      $steps = 8 - $steps if $reverse;
      # rotate left by $steps
      my $c = substr($input, 0, $steps, '');
      $input .= $c;
    } elsif(/rotate based on position of letter (.)/) {
      # Rotation rules for forward rotation
      my @rotate1 = ( 7, 6, 5, 4, 2, 1, 0, 7 );
      # Rotation rules for backward rotation
      my @rotate2 = ( 1, 1, 6, 2, 7, 3, 0, 4 );
      my $idx = index($input, $1);
      my $steps = $reverse ? $rotate2[$idx] : $rotate1[$idx];
      # rotate left by $steps
      my $c = substr($input, 0, $steps, '');
      $input .= $c;
    } elsif(/reverse positions (\d) through (\d)/) {
      my $idx1 = $1;
      my $idx2 = $2;

      # not sure if this is required
      if($idx1 > $idx2) {
        my $t = $idx1;
        $idx1 = $idx2;
        $idx2 = $t;
      }

      my $c = reverse substr($input, $idx1, $idx2 - $idx1 + 1);
      substr($input, $idx1, $idx2 - $idx1 + 1, $c);
    } elsif(/move position (\d) to position (\d)/) {
      my $idx1 = $reverse ? $2 : $1;
      my $idx2 = $reverse ? $1 : $2;
      my $c = substr($input, $idx1, 1, '');
      substr($input, $idx2, 0, $c);
    }
  }

  return $input;
}
