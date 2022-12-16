%reg = ( a=>0, b=>0, c=>0, d=>0 ); # registers

# read program
@inst = <>;

run();
print "part 1 result: $reg{a}\n";

# For part 2, initialize c to 1.
%reg = ( a=>0, b=>0, c=>1, d=>0 ); # registers
run();
print "part 2 result: $reg{a}\n";

sub get {
  my $arg = $_[0];
  if($arg =~ /\d/) {
    return int($arg);
  } else {
    return $reg{$arg};
  }
}

sub run {
  my $ip = 0; # instruction pointer
  while($ip >= 0 && $ip <= $#inst) { # program halts when $ip goes out of range.

    my $inst = $inst[$ip];

    if($inst =~ /cpy ([-\w]+) ([-\w]+)/) {
      $reg{$2} = get($1);
    } elsif($inst =~ /inc ([\w-]+)/) {
      $reg{$1}++;
    } elsif($inst =~ /dec ([\w-]+)/) {
      $reg{$1}--;
    } elsif($inst =~ /jnz ([\w-]+) ([\w-]+)/) {
      my ($a1, $a2) = ($1, $2);
      if(get($a1) != 0) {
        $ip += get($a2);
        $ip--; # because $ip is going to get incremented before the next loop.
      }
    }

    $ip++;
  }
}
