# Read all definitions into the $def table
while(<>) {
  chomp;
  if(/(\w+): (.*)/) {
    $def{$1} = $2;
    $def{$1} =~ s/\s//g;
  }
}

sub evalDef {
  my $def = $_[0];
  if($def =~ /^\d+$/) {
    return int($def);
  } elsif($def =~ /^([a-z]+)$/) {
    # just references another var? not sure if that actually will happen
    return evalDef($def{$1});
  } elsif($def =~ /([a-z]+)([+\-*\/])([a-z]+)/) {
    my ($a1, $op, $a2) = ($1, $2, $3);
    if($op eq '+') {
      return evalDef($a1) + evalDef($a2);
    } elsif($op eq '-') {
      return evalDef($a1) - evalDef($a2);
    } elsif($op eq '*') {
      return evalDef($a1) * evalDef($a2);
    } elsif($op eq '/') {
      return evalDef($a1) / evalDef($a2);
    }
  }
  
  print "Bad def: $def\n";
  exit 1;
}

my $part1 = evalDef('root');
print "part 1 result: $part1\n";

# Do binary search of 'humn' to find the number that makes the two arguments
# for 'root' equal.

my $minHumn = 0;
my $maxHumn = $part1;
$def{root} =~ /([a-z]+)\s*\+\s*([a-z]+)/;
my $a1 = $1;
my $a2 = $2;

while(1) {
  $def{humn} = int(($minHumn + $maxHumn) / 2);
  my $v1 = evalDef($a1);
  my $v2 = evalDef($a2);
  if($v1 == $v2) {
    print "part 2 result: $def{humn}\n";
    exit 0;
  }

  if($v1 > $v2) {
    $minHumn = $def{humn} + 1;
  } else {
    $maxHumn = $def{humn} - 1;
  }
}
