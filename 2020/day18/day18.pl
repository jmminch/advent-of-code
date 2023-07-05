use strict 'vars';
our $part2 = 0;

my @problems = <>;

# get rid of anything but digits, plus, minus, and parens
for my $i (0..$#problems) {
  $problems[$i] =~ s/[^\d+*()]//g
}

my $result1 = 0;
for my $pbm (@problems) {
  $result1 += evalExpr($pbm);
}

$part2 = 1;
my $result2 = 0;
for my $pbm (@problems) {
  $result2 += evalExpr($pbm);
}

print "part 1 result: $result1\n";
print "part 2 result: $result2\n";

sub evalExpr {
  my $expr = $_[0];

  # repeatedly look for any parenthesized expressions
  while($expr =~ /\([^()]+\)/) {
    my $expr2 = substr($expr, $-[0] + 1, $+[0] - $-[0] - 2);
    substr($expr, $-[0], $+[0] - $-[0], evalExpr($expr2));
  }

  # no parens left
  if(!$part2) {
    # plus and times have the same precedence
    while($expr =~ /(\d+)([+*])(\d+)/) {
      if($2 eq '+') {
        substr($expr, $-[0], $+[0] - $-[0], $1 + $3);
      } else {
        substr($expr, $-[0], $+[0] - $-[0], $1 * $3);
      }
    }
  } else {
    # handle plus first, then times
    while($expr =~ /(\d+)\+(\d+)/) {
      substr($expr, $-[0], $+[0] - $-[0], $1 + $2);
    }
    while($expr =~ /(\d+)\*(\d+)/) {
      substr($expr, $-[0], $+[0] - $-[0], $1 * $2);
    }
  }

  return $expr;
}
