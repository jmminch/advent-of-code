use Data::Dumper;

my @queue = (); # List of wires to check.
%wires = (); # Table of values for each wire.
my %rules = (); # Table of all rules that reference each wire.

while(<>) {
  chomp;
  if(/^(NOT )?(\d+) -> (\w+)/) {
    # This is a starting point. assign the value and push the wire name onto
    # the queue.
    $wires{$3} = (defined $1) ? (0xffff ^ $2) : int($2);
    push @queue, $3;
  } elsif(/^(NOT )?(\w+) ->/) {
    $x = $2;
    $rules{$x} = [ ] if not exists $rules{$x};
    push @{$rules{$x}}, $_;
  } elsif(/(\w+) (AND|OR|[LR]SHIFT) (\w+) ->/) {
    $x = $1;
    $y = $3;

    if($x =~ /[a-z]/) {
      $rules{$x} = [ ] if not exists $rules{$x};
      push @{$rules{$x}}, $_;
    }

    if($y =~ /[a-z]/) {
      $rules{$y} = [ ] if not exists $rules{$y};
      push @{$rules{$y}}, $_;
    }
  }
}

sub get {
  my @args = @_;
  my @r = ( );
  for my $arg (@args) {
    if($arg =~ /\d/) {
      push @r, int($arg);
    } else {
      return () if !exists $wires{$arg};
      push @r, $wires{$arg};
    }
  }
  return @r;
}

while(not exists $wires{a}) {
  my $w = shift @queue;
  for my $rule (@{$rules{$w}}) {

    $rule =~ /-> (\w+)/;
    my $t = $1;
    next if exists $wires{$t};  # already calculated this.
    
    if($rule =~ /^(NOT )?(\w+) ->/)  {
      my @args = get($2);
      next if !@args;
      $wires{$t} = (defined $1) ? ($args[0] ^ 0xFFFF) : $args[0];
      push @queue, $t;
    } elsif($rule =~ /^(\w+) (AND|OR|LSHIFT|RSHIFT) (\w+)/) {
      my @args = get($1, $3);
      next if !@args;

      if($2 eq 'AND') {
        $wires{$t} = $args[0] & $args[1];
      } elsif($2 eq 'OR') {
        $wires{$t} = $args[0] | $args[1];
      } elsif($2 eq 'RSHIFT') {
        $wires{$t} = $args[0] >> $args[1];
      } elsif($2 eq 'LSHIFT') {
        $wires{$t} = ($args[0] << $args[1]) & 0xFFFF;
      }

      push @queue, $t;
    }

  }
}

print "part 1 result: $wires{a}\n";
