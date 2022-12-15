# Looking for the lowest positive integer n such that MD5('ckczppom' . n)
# starts with 5 zeroes.

use Digest::MD5 qw(md5_hex);

my $key = shift // 'ckczppom';

# loop until appropriate md5 hash found.
my $idx = 1;
while(1) {
  my $hash = md5_hex($key . $idx);
  if($hash =~ /^00000/) {
    last;
  }
  $idx++;
}

print "part 1 result: $idx\n";

# again, this time for 6 zeroes. We can start at the current idx, since
# we know that no value less than this has even 5 zeroes; but we do need to
# check the current idx again since the very first one found could have had
# 6 zeroes.
while(1) {
  my $hash = md5_hex($key . $idx);
  if($hash =~ /^000000/) {
    last;
  }
  $idx++;
}

print "part 2 result: $idx\n";
