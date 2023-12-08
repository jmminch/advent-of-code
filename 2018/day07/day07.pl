use strict vars;
use Storable qw(dclone);

# Read all the instructions
my %steps;
while(<>) {
  if(/Step (.).*step (.)/) {
    $steps{$2}->{$1} = 1;
    # Make sure that step $1 is represented in the list
    $steps{$1} = { } if not exists $steps{$1};
  }
}

# Part 1 -- one worker
my ($part1, undef) = simulate(\%steps, 1);
print "Part 1 result: $part1\n";

# Part 2 -- five workers
my (undef, $part2) = simulate(\%steps, 5);
print "Part 2 result: $part2\n";

sub simulate {
  my $steps = dclone($_[0]);
  my $freeWorkers = $_[1];
  my @workers = ( );
  my $order = "";
  my $time = 0;

  # Loop until all steps complete and all workers are done.
  while((%$steps) || (scalar @workers)) {
    
    # If there are any free workers, try to assign them work.
    if($freeWorkers) {
      for my $step (sort keys %$steps) {
        next if scalar %{$steps->{$step}}; # this step still is waiting
        $freeWorkers--;
        # Push the amount of time that the worker will take onto the active
        # workers list.
        push @workers, [ $step, 61 + ord($step) - ord('A') ];
        delete $steps->{$step};
        $order .= $step;
        last if !$freeWorkers; # Quit if no more workers are free.
      }
    }

    # Simulate forward one second.
    for(my $i = 0; $i <= $#workers; $i++) {
      $workers[$i]->[1]--;
      if($workers[$i]->[1] < 1) {
        # step complete
        for my $step (sort keys %$steps) {
          delete $steps->{$step}->{$workers[$i]->[0]};
        }
        splice @workers, $i, 1; # remove from workers list
        $freeWorkers++; # Add another free worker
        $i--; # adjust index since array was shortened
      }
    }

    $time++;
  }

  return $order, $time;
}
