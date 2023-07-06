our @inst = <>;
chomp @inst;

# state for part 1 program
my %statePt1 = ( part => 1, ip => 0, regs => { p => 0 }, sndFreq => 0 );

# state for part 2 programs
my %state0 = ( part => 2, ip => 0, regs => { p => 0 }, input => [ ] );
my %state1 = ( part => 2, ip => 0, regs => { p => 1 }, input => [ ] );

$state0{output} = $state1{input};
$state1{output} = $state0{input};

run(\%statePt1);

print "Part 1 result: $statePt1{sndFreq}\n";

# For part 2, run them, alternating, until there is a deadlock. The
# return value from run is the number of instructions performed.
while(1) {
  run(\%state0);
  last if run(\%state1) == 0; # no instructions performed; must be deadlocked.
}

print "Part 2 result: $state1{sendCount}\n";

sub run {
  my $state = $_[0];

  my $ip = $state->{ip}; # instruction pointer
  my $regs = $state->{regs};
  my $part = $state->{part};

  my $instCount = 0;

  while($ip >= 0 && $ip <= $#inst) {
    my @cmd = split / /, $inst[$ip];
    if($cmd[0] eq 'snd') {
      if($part == 1) {
        $state->{sndFreq} = getReg($regs, $cmd[1]);
      } else {
        push @{$state->{output}}, getReg($regs, $cmd[1]);
        $state->{sendCount}++;
      }
    } elsif($cmd[0] eq 'set') {
      $regs->{$cmd[1]} = getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'add') {
      $regs->{$cmd[1]} += getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'mul') {
      $regs->{$cmd[1]} *= getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'mod') {
      $regs->{$cmd[1]} %= getReg($regs, $cmd[2]);
    } elsif($cmd[0] eq 'rcv') {
      if($part == 1) {
        last if getReg($regs, $cmd[1]) != 0;
      } else {
        last if scalar @{$state->{input}} == 0;
        $regs->{$cmd[1]} = shift @{$state->{input}};
      }
    } elsif($cmd[0] eq 'jgz') {
      if(getReg($regs, $cmd[1]) > 0) {
        $ip += getReg($regs, $cmd[2]);
        $ip--;
      }
    } 
    $ip++;
    $instCount++;
  }
  
  $state->{ip} = $ip;
  return $instCount;
}

# If the parameter is a letter, then return the value of the register;
# otherwise return the value itself.
sub getReg {
  return int(($_[1] =~ /[a-z]/) ? $_[0]->{$_[1]} : $_[1]);
}
