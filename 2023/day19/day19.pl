use strict vars;
use Storable qw(dclone);

our %workflows;
my @parts;

# Read the input data
while(<>) {
  if(/^(\w+)\{(.*)\}/) {
    # This is a workflow line
    my $name = $1;
    my @workflow = ( );
    for my $rule (split /,/, $2) {
      if($rule =~ /(\w+)([<>])(\d+):(\w+)/) {
        push @workflow, [ $1, $2, $3, $4 ];
      } else {
        push @workflow, $rule;
      }
    }
    $workflows{$name} = \@workflow;
  } elsif(/^\{(.*)\}/) {
    # This is a part line
    my %part = ( );
    $part{$1} = $2 while /(\w+)=(\d+)/g;
    push @parts, \%part;
  }
}

# Apply the workflows to the parts until they reach 'A' or 'R'
my $part1 = 0;
for my $part (@parts) {
  my $wf = "in";
  while($wf ne 'A' && $wf ne 'R') {
    $wf = applyWorkflow($wf, $part);
  }
  if($wf eq 'A') {
    $part1 += $part->{x} + $part->{m} + $part->{a} + $part->{s};
  }
}

print "Part 1 result: $part1\n";

# For part 2, work on a range of all possibilities. To start, we have all
# combinations of x,m,a,s from 1-4000 in workflow 'in'.
my @queue = ( [ { x=>[1,4000], m=>[1,4000], a=>[1,4000], s=>[1,4000]}, "in" ] );
my @accepted = ( );

while(my $a = shift @queue) {
  my @results = applyWorkflow2($a->[1], $a->[0]);
  for my $v (@results) {
    next if $v->[1] eq 'R';
    if($v->[1] eq 'A') {
      push @accepted, $v->[0];
      next;
    }
    push @queue, $v;
  }
}

# count up all possibilities from the @accepted list.
my $part2 = 0;
for my $part (@accepted) {
  my $v = 1;
  for my $p (qw(x m a s)) {
    $v *= $part->{$p}->[1] - $part->{$p}->[0] + 1;
  }
  $part2 += $v;
}

print "Part 2 result: $part2\n";

# Apply a workflow to a part and return its destination
sub applyWorkflow {
  my $wf = $workflows{$_[0]};
  my $part = $_[1];

  for my $rule (@$wf) {
    return $rule if !ref $rule;  # final rule
    if($rule->[1] eq '<') {
      return $rule->[3] if $part->{$rule->[0]} < $rule->[2];
    } else {
      return $rule->[3] if $part->{$rule->[0]} > $rule->[2];
    }
  }

  die;  # not supposed to happen
}

sub applyWorkflow2 {
  my $wf = $workflows{$_[0]};
  my $part = $_[1];
  my @results = ( );

  for my $rule (@$wf) {
    
    if(!ref $rule) {
      # Last rule, anything remaining goes to this workflow
      push @results, [$part, $rule];
      last;
    }

    my $range = $part->{$rule->[0]};

    if($rule->[1] eq '<') {
      next if $rule->[2] <= $range->[0]; # nothing in this range
      if($rule->[2] > $range->[1]) {
        # entire range matches this rule
        push @results, [$part, $rule->[3]];
        last;
      }

      # Need to split
      my $newPart = dclone($part);
      $newPart->{$rule->[0]}->[1] = $rule->[2] - 1;
      push @results, [$newPart, $rule->[3]];
      $range->[0] = $rule->[2];
    } else { # >

      next if $rule->[2] >= $range->[1]; # nothing in this range
      if($rule->[2] < $range->[0]) {
        # entire range matches this rule
        push @results, [$part, $rule->[3]];
        last;
      }

      # Need to split
      my $newPart = dclone($part);
      $newPart->{$rule->[0]}->[0] = $rule->[2] + 1;
      push @results, [$newPart, $rule->[3]];
      $range->[1] = $rule->[2];
    }
  }

  return @results;
}
