use JSON;
use Data::Dumper;

# read all of stdin into a string.
my $input = do { local $/; <> };

while($input =~ /([\d-]+)/g) {
  $total += $1;
}

print "part 1 result: $total\n";

$json = decode_json($input);

sub sum {
  my $json = $_[0];
  my $total = 0;

  if(!(ref $json)) {
    while($json =~ /([-\d]+)/g) {
      $total += $1;
    }
  } elsif(ref $json eq 'ARRAY') {
    for $e (@$json) {
      $total += sum($e);
    }
  } elsif(ref $json eq 'HASH') {
    for $e (values %$json) {
      return 0 if $e eq 'red';
      $total += sum($e);
    }
  }

  return $total;
}

print "part 2 result: ", sum($json), "\n";
