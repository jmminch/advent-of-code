use strict vars;

my @raceTimes;
my @records;

# Read the "Time:" line
$_ = <>;
push @raceTimes, $1 while(/(\d+)/g);

# Read the "Distance:" line
$_ = <>;
push @records, $1 while(/(\d+)/g);

# Find the product of the number of integers values for "hold time" that win
# each race.
my $part1 = 1;
for my $i (0..$#raceTimes) {
  $part1 *= numWinningTimes($raceTimes[$i], $records[$i]);
}
print "Part 1 result: $part1\n";

# Part 2 is the number of winning times if you concatenate all the digits in
# raceTimes and records.
my $p2Time;
for my $x (@raceTimes) { $p2Time .= $x; }
my $p2Record;
for my $x (@records) { $p2Record .= $x; }
printf "Part 2 result: %d\n", numWinningTimes($p2Time, $p2Record);


# Find the number of integer values for "hold time" that win a particular
# race. The parameters are the race time and winning record.
sub numWinningTimes {
  my ($t, $r) = @_;
  my $minTime = ($t - sqrt($t * $t - 4 * $r)) / 2;
  my $maxTime = ($t + sqrt($t * $t - 4 * $r)) / 2;

  # Find the integers that are more than minTime and less than maxTime
  $minTime = int($minTime + 1);
  $maxTime = int($maxTime - .0001); # kind of hokey

  return $maxTime - $minTime + 1;
}
