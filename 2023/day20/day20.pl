use strict vars;
use Data::Dumper;

# Read in the circuit definition
our %circuit;
while(<>) {
  chomp;
  if(/([&%]?)([a-z]+)\s*->\s*(.*)/) {
    $circuit{$2} = { type=>$1, output=> [ split /,\s*/, $3 ] };
  }
}

# For all conjunction modules, we need to identify all of its inputs.
for my $mod (keys %circuit) {
  my $module = $circuit{$mod};
  if($module->{type} eq '&') {
    # The 'inputs' hash contains the last pulse received from each connected
    # input.
    $module->{inputs} = { };
    for my $mod2 (keys %circuit) {
      for my $mod3 (@{$circuit{$mod2}->{output}}) {
        $module->{inputs}->{$mod2} = 0 if $mod3 eq $mod;
      }
    }
  }
}

our @pulseQueue;
our @pulseCounts;

my $part1 = -1;
my $part2 = -1;
my $loopCount = 0;
my $vdState = 1;
while($part1 == -1 || $part2 == -1) {
  $loopCount++;
  push @pulseQueue, [ 'broadcaster', 'button', 0 ];
  while(my $pulse = shift @pulseQueue) {
    #print join ' ', @$pulse;
    #print "\n";
    # check if a low pulse is sent to rx
    $part2 = $loopCount if $pulse->[0] eq 'rx' &&
                           $pulse->[2] == 0 && $part2 == -1;
    simPulse($pulse);

    if($pulse->[0] eq 'll') {
      print "$loopCount - &ll - ";
      my $mod = $circuit{ll};
      for my $input (sort keys %{$mod->{inputs}}) {
        print $mod->{inputs}->{$input};
      }
      print "\n";
    }
  }
  $part1 = $pulseCounts[0] * $pulseCounts[1] if $loopCount == 1000;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub simPulse {
  my ($tgt, $src, $pulse) = @{$_[0]};
  my $mod = $circuit{$tgt};

  $pulseCounts[$pulse]++;

  if($mod->{type} eq '%') {
    # flip-flop
    if($pulse == 0) {
      $mod->{state} = $mod->{state} ? 0 : 1;
      for my $target (@{$mod->{output}}) {
        push @pulseQueue, [ $target, $tgt, $mod->{state} ];
      }
    }
  } elsif($mod->{type} eq '&') {
    # conjunction
    $mod->{inputs}->{$src} = $pulse;
    my $send = 0;
    for my $input (keys %{$mod->{inputs}}) {
      if($mod->{inputs}->{$input} == 0) {
        $send = 1;
        last;
      }
    }
    for my $target (@{$mod->{output}}) {
      push @pulseQueue, [ $target, $tgt, $send ];
    }
  } else {
    # broadcaster
    for my $target (@{$mod->{output}}) {
      push @pulseQueue, [ $target, $tgt, $pulse ];
    }
  }
}

sub printState {
  for my $modName (sort keys %circuit) {
    my $mod = $circuit{$modName};
    if($mod->{type} eq '%') {
      print "%$modName - $mod->{state}\n";
    } elsif($mod->{type} eq '&') {
      print "&$modName - ";
      for my $input (sort keys %{$mod->{inputs}}) {
        print $mod->{inputs}->{$input};
      }
      print "\n";
    }
  }
}
