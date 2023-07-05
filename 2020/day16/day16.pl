use Data::Dumper;
use strict 'vars';

# read input.

my %rules;
my $selfTicket;
my @tickets;
my @validTickets;

# first read the field rules
while(<>) {
  last if /your ticket:/;
  if(/^([\w\s]+): /) {
    my $field = $1;
    push @{$rules{$field}}, [ $1, $2 ] while /(\d+)-(\d+)/g;
  }
}

# read your ticket
$_ = <>;
chomp;
$selfTicket = [ split /,/ ];

# the remainder of the input should be nearby tickets
while(<>) {
  if(/^\d/) {
    chomp;
    push @tickets, [ split /,/ ];
  }
}

# Part 1. Scan through all fields of all tickets. If the field cannot
# possibly be valid based on the rules, then reject the ticket, otherwise
# it's valid.

my $invalidSum = 0;  # result for part 1

for my $ticket (@tickets) {
  my $valid = 1;
  VALUE: for my $val (@$ticket) { # each field on the ticket
    for my $ruleList (values %rules) { # each set of rules
      for my $rule (@$ruleList) { # each range for this rule
        next VALUE if $val >= $rule->[0] && $val <= $rule->[1];
      }
    }

    # value is not valid for any field; this ticket is invalid.
    # Need to keep scanning because we want the sum of all invalid fields,
    # and there could be more than one invalid field in a ticket.
    $valid = 0;
    $invalidSum += $val;
  }

  # make a new list of tickets found to be valid to be used in part 2
  push @validTickets, $ticket if $valid;
}

print "part 1 result: $invalidSum\n";

# Part 2. Figure out which field is in which position.

# Build a list of possible positions for each field.
my $mask = (1 << $#$selfTicket) - 1;
my %poss;
for my $key (keys %rules) {
  $poss{$key} = $mask;
}

# Go through all fields for all tickets, and eliminate possibilities
# based on the values in the tickets.
for my $ticket (@validTickets) {
  for my $pos (0..$#$ticket) {
    my $val = $ticket->[$pos];

    for my $key (keys %rules) {
      next if !($poss{$key} & (1 << $pos)); # already eliminated

      my $valid = 0;
      for my $rule (@{$rules{$key}}) {
        $valid = 1 if $val >= $rule->[0] && $val <= $rule->[1];
      }
      $poss{$key} &= ~(1 << $pos) if !$valid;
    }
  }
}

# Loop through the fields, and for any with a single possibility, eliminate
# that field as a possibility for any others.
while(1) {
  my $restart = 0;
  for my $key (keys %poss) {
    # this checks that only one bit is set.
    if(($poss{$key} & ($poss{$key} - 1)) == 0) {
      for my $key2 (keys %poss) {
        next if $key eq $key2;
        $poss{$key2} &= ~$poss{$key};
      }
    } else {
      $restart = 1;
    }
  }

  last if !$restart;
}

my $part2 = 1;
for my $key (grep /^departure /, keys %poss) {
  my $bit = -1;
  my $val = $poss{$key};
  while($val > 0) { $bit++; $val >>=1; };
  $part2 *= $selfTicket->[$bit];
}
print "part 2 result: $part2\n";
