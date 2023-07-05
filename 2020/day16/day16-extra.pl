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
# 1. map the field names to numbers
# 2. for each position, determine which fields may be in that position.
# 3. for any positions that are known (only one possibility), eliminate
#    that field as a possibility for any other position. Repeat until
#    nothing gets eliminated.
# 4. for the first position that has multiple possibilities, try each
#    possibility and recursively do steps (3, 4) until either a
#    contradiction (field with no possibilities) or a solution is found.

# step 1
my @fieldMap = sort keys %rules;
my $mask = (1 << (scalar @fieldMap)) - 1;
my @possibilities = ($mask) x scalar @$selfTicket; # start with all positions possible.

# step 2: Go through all fields for all tickets, and eliminate possibilities
# based on the values in the tickets.
for my $ticket (@validTickets) {
  for my $pos (0..$#$ticket) {
    my $val = $ticket->[$pos];
    for my $ruleId (0..$#fieldMap) {
      my $valid = 0;
      for my $rule (@{$rules{$fieldMap[$ruleId]}}) {
        $valid = 1 if $val >= $rule->[0] && $val <= $rule->[1];
      }
      $possibilities[$pos] &= ~(1 << $ruleId) if !$valid;
    }
  }
}

my $result = solve(\@possibilities);
if($result) {
  my $part2 = 1;
  for my $pos (0..$#possibilities) {
    for my $idx (0..$#fieldMap) {
      if($possibilities[$pos] & (1 << $idx)) {
        if($fieldMap[$idx] =~ /^departure/) {
          $part2 *= $selfTicket->[$pos];
        }
      }
    }
  }
  print "part 2 result: $part2\n";
} else {
  print "no result found!\n";
}

sub solve {
  my $poss = $_[0];
  my @copy = ( @$poss );

  # step 3: look for positions with only one possibility, and eliminate that
  # field as a possibility for any other positions.
  my $change = 1;
  while($change) {
    $change = 0;
    my $multi = 0;
    
    for my $pos (0..$#copy) {
      my $val = $copy[$pos];
      if(!$val) {
        return 0;
      } elsif(($val & ($val - 1)) == 0) {
        # only a single bit set
        for my $pos2 (0..$#copy) {
          next if $pos2 == $pos;
          if($copy[$pos2] & $val) {
            $copy[$pos2] &= ~$val;
            $change = 1;
          }
        }
      } else {
        $multi = 1; # found a position with multiple possibilities
      }
    }

    if(!$multi) {
      # found a solution
      for my $i (0..$#copy) {
        $poss->[$i] = $copy[$i];
      }
      return 1;
    }
  }

  # step 4: look for a position with multiple possibilities, and try them in
  # order.
  for my $pos (0..$#copy) {
    my $val = $copy[$pos];
    next if (($val & ($val - 1)) == 0);

    # found one. try replacing the value at this position one by one.
    for(my $bit = 1; $bit <= $val; $bit <<= 1) {
      next if !($val & $bit);
      $copy[$pos] = $bit;
      next if !solve(\@copy);

      # this solution is valid. Copy to the parent array ($poss)
      for my $i (0..$#copy) {
        $poss->[$i] = $copy[$i];
      }

      return 1; # true result indicates success
    }

    # no possibilities worked.
    return 0;
  }
}
