#!/usr/bin/perl

use strict vars;

sub runIntcode {
  my ($prog, $input, $output) = @_;
  my $ip = 0;
  my $base = 0;

  while(1) {
    my $inst = $prog->[$ip];

    # Decode the operation
    my $op = $inst % 100;
    $inst = int($inst / 100);
    my @modes;
    while($inst) {
      push @modes, $inst % 10;
      $inst = int($inst / 10);
    }

    # Helper function to decode the parameters
    my $getParm = sub {
      my $parm = shift;
      my $output = shift;

      if($output) {
        # Need to return the location referred to
        if($modes[$parm] == 2) {
          # relative mode
          return $base + $prog->[$ip + 1 + $parm];
        } else {
          # position mode
          return $prog->[$ip + 1 + $parm];
        }
      }

      if(($modes[$parm] == 1)) {
        # immediate mode
        return $prog->[$ip + 1 + $parm];
      } elsif($modes[$parm] == 2) {
        # relative mode
        return $prog->[$base + $prog->[$ip + 1 + $parm]];
      } else {
        # position mode
        return $prog->[$prog->[$ip + 1 + $parm]];
      }
    };

    if($op == 1) {
      # add
      $prog->[$getParm->(2, 1)] = $getParm->(0) + $getParm->(1);
      $ip += 4;
    } elsif($op == 2) {
      # mul
      $prog->[$getParm->(2, 1)] = $getParm->(0) * $getParm->(1);
      $ip += 4;
    } elsif($op == 3) {
      # input
      $prog->[$getParm->(0, 1)] = $input->();
      $ip += 2;
    } elsif($op == 4) {
      # output
      $output->($getParm->(0));
      $ip += 2;
    } elsif($op == 5) {
      # jump if true
      if($getParm->(0)) {
        $ip = $getParm->(1);
      } else {
        $ip += 3;
      }
    } elsif($op == 6) {
      # jump if false
      if(!$getParm->(0)) {
        $ip = $getParm->(1);
      } else {
        $ip += 3;
      }
    } elsif($op == 7) {
      # less than
      $prog->[$getParm->(2, 1)] = ($getParm->(0) < $getParm->(1)) ? 1 : 0;
      $ip += 4;
    } elsif($op == 8) {
      # less than
      $prog->[$getParm->(2, 1)] = ($getParm->(0) == $getParm->(1)) ? 1 : 0;
      $ip += 4;
    } elsif($op == 9) {
      $base += $getParm->(0);
      $ip += 2;
    } elsif($op == 99) {
      return;
    } else {
      die "bad op $op";
    }
  }
}

1;
