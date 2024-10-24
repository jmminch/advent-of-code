# Adapted from day18.pl

use Math::Prime::XS qw(is_prime);

our @inst = <>;
chomp @inst;

# state for part 1 program
my %state = ( ip => 0, regs => { } );

run(\%state);
print "Part 1 result: $state{mulCount}\n";

# Reset registers for part 2. 
$state{regs} = { a=>1 };

run(\%state);
print "Part 2 result: $state{regs}->{h}\n";

sub run {
  my $state = $_[0];
  my $ip = 0; # instruction pointer
  my $regs = $state->{regs};

  while($ip >= 0 && $ip <= $#inst) {
    my @cmd = split / /, $inst[$ip];
    if($cmd[0] eq 'set') {
      $regs->{$cmd[1]} = getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'sub') {
      $regs->{$cmd[1]} -= getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'mul') {
      $regs->{$cmd[1]} *= getReg($regs, $cmd[2]);
      $state->{mulCount}++;
    } elsif($cmd[0] eq 'jnz') {
      if(getReg($regs, $cmd[1]) != 0) {
        $ip += getReg($regs, $cmd[2]);
        $ip--;
      }
    } elsif($cmd[0] eq 'mod') {
      # new opcode for part 2.
      $regs->{$cmd[1]} %= getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'pri') {
      # new opcode for part 2.
      $regs->{$cmd[1]} = isPrime(getReg($regs, $cmd[2]));
    }
    $ip++;
  }
  
  $state->{ip} = $ip;
  return;
}

# If the parameter is a letter, then return the value of the register;
# otherwise return the value itself.
sub getReg {
  return int(($_[1] =~ /[a-z]/) ? $_[0]->{$_[1]} : $_[1]);
}

sub isPrime {
  return (is_prime($_[0]) ? 1 : 0);
}
