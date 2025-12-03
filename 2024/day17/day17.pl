#!/usr/bin/perl

use strict vars;

my %regs = ( );
my @prog;
while(<>) {
  $regs{$1} = $2 if /Register (\w+): (\d+)/;
  if(/Program: (\d.*\d)/) {
    @prog = split /,/, $1;
  }
}

my @output;
runProg(\@prog, \%regs, sub { push @output, $_[0] });
printf "Part 1 result: %s\n", join(',', @output);

# build a table of the first digit of output based on all possibilities for
# the low 10 bits of A.
my %invertTbl;
for my $a (0..1023) {
  my %regs = ( A => $a );
  my @output = ( );
  runProg(\@prog, \%regs, sub { push @output, $_[0] });
  push @{$invertTbl{$output[0]}}, $a;
}

printf "Part 2 result: %d\n", findVal(0, 0, \@prog);

# Now search to find all valid values for A
sub findVal {
  my ($val, $depth, $prog) = @_;
  my $digit = $#prog - $depth;

  return $val if $digit < 0;

  for my $c (values @{$invertTbl{$prog->[$digit]}}) {

    if($depth > 0) {
      # Check that the high 7 bits of $c match what already is in $val.
      next if ($c & 1016) != (($val >> ($digit * 3)) & 1016);
    }

    my $r = findVal($val | ($c << ($digit * 3)), $depth + 1, $prog);
    return $r if $r != -1;
  }

  return -1;
}

sub runProg {
  my ($prog, $regs, $outFn) = @_;
  my $ip = 0;

  my $getOperand = sub {
    my $x = $prog->[$ip + 1];
    return $x if $x <= 3;
    return $regs->{A} if $x == 4;
    return $regs->{B} if $x == 5;
    return $regs->{C} if $x == 6;
  };

  while($ip >= 0 && $ip <= $#$prog) {
    my $op = $prog->[$ip];

    if($op == 0) {
      $regs->{A} = $regs->{A} >> $getOperand->();
    } elsif($op == 1) {
      $regs->{B} = int($regs->{B}) ^ int($prog->[$ip + 1]);
    } elsif($op == 2) {
      $regs->{B} = $getOperand->() & 0x7;
    } elsif($op == 3) {
      $ip = $getOperand->() - 2 if $regs->{A};
    } elsif($op == 4) {
      $regs->{B} = int($regs->{B}) ^ int($regs->{C});
    } elsif($op == 5) {
      $outFn->($getOperand->() & 0x7);
    } elsif($op == 6) {
      $regs->{B} = $regs->{A} >> $getOperand->();
    } elsif($op == 7) {
      $regs->{C} = $regs->{A} >> $getOperand->();
    }

    $ip += 2;
  }
}
