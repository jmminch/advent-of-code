$input = shift // 7;

# read program
@inst = <>;

my $input = 1;
while(1) {
  #print "Testing $input... \n";
  %reg = ( a=>$input, b=>0, c=>0, d=>0 );
  my $out = run();
  #print "$out correct values generated.\n";
  if($out == -1) {
    print "result: $input\n";
    exit 0;
  }
  $input++;
}

run();
print "part 1 result: $reg{a}\n";

sub get {
  my $arg = $_[0];
  if($arg =~ /\d/) {
    return int($arg);
  } else {
    return $reg{$arg};
  }
}

sub run {
  my $expected = 0; # We're expecting a 0 to start.
  my $outcount = 0; # count of how many output values generated.

  my %stateCache = ( );

  my $ip = 0; # instruction pointer
  while($ip >= 0 && $ip <= $#inst) { # program halts when $ip goes out of range.

    my $inst = $inst[$ip];

    if($inst =~ /cpy ([-\w]+) ([-\w]+)/) {
      my ($a1, $a2) = ($1, $2);
      if(!($a2 =~ /\d/)) { # make sure the second arg is a register, not a number
        $reg{$a2} = get($a1);
      }
    } elsif($inst =~ /inc ([\w-]+)/) {
      my $a1 = $1;
      if(!($a1 =~ /\d/)) { # make sure arg is a register
        $reg{$a1}++;
      }
    } elsif($inst =~ /dec ([\w-]+)/) {
      my $a1 = $1;
      if(!($a1 =~ /\d/)) { # make sure arg is a register
        $reg{$a1}--;
      }
    } elsif($inst =~ /jnz ([\w-]+) ([\w-]+)/) {
      my ($a1, $a2) = ($1, $2);
      if(get($a1) != 0) {
        if(get($a2) != 0) { # would result in an infinite loop.
          $ip += get($a2);
          $ip--; # because $ip is going to get incremented before the next loop.
        }
      }
    } elsif($inst =~ /tgl ([\w-]+)/) {
      my $a1 = get($1);
      my $tglp = $ip + $a1;

      # check whether the target is a valid instruction, if not then no
      # action should be taken.
      if($tglp >= 0 && $tglp <= $#inst) {
        my $op = substr($inst[$tglp], 0, 3);
        if($op eq 'inc') {
          $op = 'dec';
        } elsif($op eq 'dec' || $op eq 'tgl') {
          $op = 'inc';
        } elsif($op eq 'jnz') {
          $op = 'cpy';
        } elsif($op eq 'cpy') {
          $op = 'jnz';
        }

        substr($inst[$tglp], 0, 3) = $op;
      }
    } elsif($inst =~ /mul ([\w-]+) ([\w-]+)/) {
      # added opcode -- multiply reg 1 by argument 2
      my ($a1, $a2) = ($1, $2);
      if(!($a1 =~ /\d/)) { # make sure arg is a register
        $reg{$a1} *= get($a2);
      }
    } elsif($inst =~ /out ([\w-]+)/) {
      my $a1 = get($1);
      $outcount++;
      if($a1 == $expected) {
        $expected = $expected ? 0 : 1;
      } else {
        return $outcount;
      }

      # find out whether this state has repeated. The state is the four
      # registers; we would need to include the instruction pointer too but
      # there's only a single out opcode in the input program.
      my $state = "$reg{a}.$reg{b}.$reg{c}.$reg{d}";
      if(exists $stateCache{$state}) {
        return -1;
      }
      $stateCache{$state} = 1;
    }

    $ip++;
  }

  return $outcount;
}
