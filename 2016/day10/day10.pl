use strict 'vars';
use Data::Dumper;

my %bins;  # both bot bins and output bins
my %bot;  # bot definitions
my @queue;  # list of bots that need to act.

# read all instructions
while(<>) {
  if(/value (\d+) goes to bot (\d+)/) {
    $bins{$2} = [ ] if not exists $bins{$2};
    push @{$bins{$2}}, int $1;
    push @queue, $2 if scalar @{$bins{$2}} > 1;
  } elsif(/(\d+) gives/) {
    my $botId = $1;
    # Translate "bot X" to "X" and "output X" to "oX"
    s/output /o/g;
    s/bot //g;
    /low to (\w+) and high to (\w+)/;
    $bot{$botId} = [ $1, $2 ];
  }
}

# simulate until we've found results for parts 1 and 2.
my $part1 = -1;
my $part2 = -1;

while($part1 == -1 || $part2 == -1) {
  # Should not reach a point where no work needs to be done
  # without finding the solution.
  die "logic error." if scalar @queue < 1;

  my $botId = shift @queue;

  next if not exists $bot{$botId};
  next if scalar @{$bins{$botId}} < 2;

  # remove the first two values from the bin.
  my @vals = sort { $a <=> $b } splice @{$bins{$botId}}, 0, 2;

  # If this bot is comparing 17 and 61, it's the answer to part 1.
  $part1 = $botId if $vals[0] == 17 && $vals[1] == 61;

  my $low = $bot{$botId}->[0];
  my $high = $bot{$botId}->[1];

  $bins{$low} = [ ] if not exists $bins{$low};
  push @{$bins{$low}}, $vals[0];
  push @queue, $low;

  $bins{$high} = [ ] if not exists $bins{$high};
  push @{$bins{$high}}, $vals[1];
  push @queue, $high;

  # If outputs 0, 1, and 2 all exist, then part 2 is those three multiplied
  # together.
  if(exists $bins{"o0"} && exists $bins{"o1"} && exists $bins{"o2"}) {
    $part2 = $bins{"o0"}->[0] * $bins{"o1"}->[0] * $bins{"o2"}->[0];
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
