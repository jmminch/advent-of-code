my @inst = <>;
chomp @inst;

# part 1, find accumulator value after running program
my (undef, $val) = run(\@inst);
print "part 1 result: $val\n";

# part 2, find which instruction to flip to cause the program to terminate.
# step through the program, flipping instructions one at a time and trying
# them out.
for my $i (0..$#inst) {
  my $op = substr($inst[$i], 0, 3);
  if($op eq 'jmp') {
    $newOp = 'nop';
  } elsif($op eq 'nop') {
    $newOp = 'jmp';
  } else {
    # acc opcode
    next;
  }

  substr($inst[$i], 0, 3) = $newOp;
  my ($r, $val) = run(\@inst);
  if($r == 2) {
    print "part 2 result: $val\n";
    last;
  }
  substr($inst[$i], 0, 3) = $op;
}

sub run {
  my $prog = $_[0];
  my $ip = 0;
  my $acc = 0;
  my @exec = ( ); # the element of this array corresponding to the instruction
                  # will be set after it's executed, to detect loops.

  while($ip >= 0 && $ip <= $#$prog) {
    if($exec[$ip] == 1) {
      return (1, $acc);
    }
    $exec[$ip] = 1;
    $prog->[$ip] =~ /^(...) ([+\-0-9]+)/;
    if($1 eq 'acc') {
      $acc += int($2);
      $ip++;
    } elsif($1 eq 'jmp') {
      $ip += int($2);
    } else {
      # nop
      $ip++;
    }
  }

  return (2, $acc);
}
