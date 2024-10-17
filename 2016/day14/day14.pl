use Digest::MD5 qw(md5_hex);
use Memoize;

my $salt = $ARGV[0] // 'qzyelonm';

memoize('hashPt1');
memoize('hashPt2');

my $pt1Count = 0;
my $pt2Count = 0;
my $n = 0;
my ($part1, $part2);

while(!defined($part1) || !defined($part2)) {
  if(checkHash($salt, $n, \&hashPt1)) {
    $pt1Count++;
    $part1 = $n if $pt1Count == 64;
  }
  if(checkHash($salt, $n, \&hashPt2)) {
    $pt2Count++;
    $part2 = $n if $pt2Count == 64;
  }
  $n++;
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";

sub checkHash {
  my ($salt, $n, $func) = @_;
  my $hash = &$func($salt . $n);
  if($hash =~ /(.)\1\1/) {
    my $pattern = $1 x 5;
    for my $i (1..1000) {
      my $hash2 = &$func($salt . ($n + $i));
      if($hash2 =~ /$pattern/) {
        return 1;
      }
    }
  }
  return 0;
}

sub hashPt1 {
  return md5_hex($_[0]);
}

sub hashPt2 {
  my $hash = hashPt1($_[0]);
  for my $i (1..2016) {
    $hash = md5_hex($hash);
  }
  return $hash;
}
