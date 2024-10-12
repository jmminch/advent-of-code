our (@vclues, @hclues);

my ($h, $w, $vclues, $hclues) = loadCWD(STDIN);

my %board = (
  h => $h,
  w => $w,
  vclues => $vclues,
  hclues => $hclues );

print "size: ${h}x$w\n";

solveBoard(\%board);

sub printBoard {
  my $board = $_[0];

  for my $y (0..$board->{h} - 1) {
    for my $x (0..$board->{w} - 1) {
      my $c = $board->{"$x.$y"};
      print (($c == 0) ? ' ' : (($c == 1) ? '#' : '.'));
    }
    print "\n";
  }
}

sub loadCWD {
  # Load clues from a .cwd file
  my $fh = $_[0];
  my (@vclues, @hclues);
  my $h = int(<$fh>);
  my $w = int(<$fh>);
  for my $i (1..$h) {
    $_ = <$fh>;
    my $clues = [ map { int $_ } split(/[, ]+/) ];
    push @hclues, $clues;
  }
  my $dummy = <$fh>;
  for my $i (1..$w) {
    $_ = <$fh>;
    my $clues = [ map { int $_ } split(/[, ]+/) ];
    push @vclues, $clues;
  }

  return ($h, $w, \@vclues, \@hclues);
}

sub solveBoard {
  my $board = $_[0];
  my $solved = 0;
  my $vclues = $board->{vclues};
  my $hclues = $board->{hclues};

  # loop until all cells have been solved.
  while($solved < $board->{h} * $board->{w}) {

    my $solvedLoop = 0;

    # Infer as much info as possible about each column.
    for(my $x = 0; $x < $board->{w}; $x++) {
      my $line = extractCol(\%board, $x);
      my $c = solveLine2($line, $vclues->[$x]);
      #my $line2 = extractCol(\%board, $x);
      #my $c2 = solveLine($line2, $vclues->[$x]);
      #if($c != $c2) {
      #  print "trace 1\n";
      #}
      if($c > 0) {
        $solvedLoop += $c;
        setCol(\%board, $x, $line);
      }
    }

    # Now each row.
    for(my $y = 0; $y < $board->{h}; $y++) {
      my $line = extractRow(\%board, $y);
      my $c = solveLine2($line, $hclues->[$y]);
      if($c > 0) {
        $solvedLoop += $c;
        setRow(\%board, $y, $line);
      }
    }

    $solved += $solvedLoop;
    print "Solved cells: $solved\n";
    printBoard(\%board);
    print "\n\n";

    last if $solvedLoop == 0;
  }
}

sub extractCol {
  my $board = $_[0];
  my $x = $_[1];
  my @line;

  for(my $y = 0; $y < $board->{h}; $y++) {
    push @line, int($board->{"$x.$y"});
  }

  return \@line;
}

sub setCol {
  my $board = $_[0];
  my $x = $_[1];
  my $line = $_[2];

  for(my $y = 0; $y < $board->{h}; $y++) {
    $board->{"$x.$y"} = $line->[$y];
  }
}

sub extractRow {
  my $board = $_[0];
  my $y = $_[1];
  my @line;

  for(my $x = 0; $x < $board->{w}; $x++) {
    push @line, int($board->{"$x.$y"});
  }

  return \@line;
}

sub setRow {
  my $board = $_[0];
  my $y = $_[1];
  my $line = $_[2];

  for(my $x = 0; $x < $board->{w}; $x++) {
    $board->{"$x.$y"} = $line->[$x];
  }
}

# method 1 - cell-by-cell solver
sub solveLine {
  my $line = $_[0];
  my $clues = $_[1];
  my @possible;
  my $solveCount = 0;

  for(my $i = 0; $i < scalar @$line; $i++) {
    if($line->[$i] == 0) {
      
      # Check whether this cell can be marked.
      if(!($possible[$i] & 1)) {
        my @work = @$line;
        $work[$i] = 1;
        my $out = find_solution(\@work, $clues);
        if(defined $out) {
          for(my $j = 0; $j < scalar @$line; $j++) {
            $possible[$j] |= $out->[$j];
          }
        }
      }

      # Check whether this cell can be unmarked.
      if(!($possible[$i] & 2)) {
        my @work = @$line;
        $work[$i] = 2;
        my $out = find_solution(\@work, $clues);
        if(defined $out) {
          for(my $j = 0; $j < scalar @$line; $j++) {
            $possible[$j] |= $out->[$j];
          }
        }
      }

      if($possible[$i] != 3) {
        # Only one possibility for this cell.
        $line->[$i] = $possible[$i];
        $solveCount++;
      }
    }
  }

  return $solveCount;
}

sub find_solution {
  my $line = $_[0];
  my $clues = $_[1];
  my @solution = @$line;
  if(check_addition($line, $clues, \@solution, 0)) {
    # Found a valid solution for this line.
    return \@solution;
  } else {
    return undef;
  }
}

sub check_addition {
  my $line = $_[0];
  my $clues = $_[1];
  my $work = $_[2];
  my $len = $_[3];

  if(!check_valid($work, $clues, $len)) {
    return 0;
  }

  if($len == scalar @$line) {
    return 1;
  }

  if($line->[$len] > 0) {
    $work->[$len] = $line->[$len];
    return check_addition($line, $clues, $work, $len + 1);
  } else {
    $work->[$len] = 1;
    return 1 if check_addition($line, $clues, $work, $len + 1);
    $work->[$len] = 2;
    return check_addition($line, $clues, $work, $len + 1);
  }
}

sub check_valid {
  my $line = $_[0];
  my $clues = $_[1];
  my $len = $_[2];
  my $groupLen = 0;
  my $cluePtr = 0;

  for($ptr = 0; $ptr < $len; $ptr++) {
    if($line->[$ptr] == 1) {
      $groupLen++;
      return 0 if $clues->[$cluePtr] < $groupLen;
    } else {
      if($groupLen > 0) {
        return 0 if $clues->[$cluePtr] != $groupLen;
        $groupLen = 0;
        $cluePtr++;
      }
    }
  }

  if($len == scalar @$line) {
    return 0 if $clues->[$cluePtr] != $groupLen;
    $cluePtr++;
    return 0 if $cluePtr < scalar @$clues;
  }

  return 1;
}

# method 2 - group placement solver.
# Solving the line involves iterating through each possible placement of
# groups and determining which are valid, and then based on that which cells
# are known.

sub solveLine2 {
  my $line = $_[0];
  my $clues = $_[1];
  my $solveState = [
      [ ],
      [ ( 0 ) x scalar @$line ] ];

  placeGroup($line, $clues, 0, 0, $solveState);

  my $solvedCells = 0;
  for my $pos (0..$#$line) {
    next if $line->[$pos] != 0;  # cell already known
    next if $solveState->[1]->[$pos] == 3;  # Could be either state
    $solvedCells++;
    $line->[$pos] = $solveState->[1]->[$pos];
  }

  return $solvedCells;
}

sub placeGroup {
  my ($line, $clues, $clueIdx, $startPos, $solveState) = @_;

  # Determine the last possible position.
  # "count" is how much space is required for the remaining clues in the
  # list.
  my $count = 0;
  for my $i ($clueIdx + 1 .. $#$clues) { $count += $clues->[$i]; }
  $count += $#$clues - $clueIdx;
  my $endPos = $#$line - $count - $clues->[$clueIdx] + 1;
  my $emptyLine = 0;

  LOOP: for my $pos ($startPos .. $endPos) {

    # Check whether putting this group at $pos will conflict with any
    # known information.
    
    # Note that if there is a known set cell before this group, then
    # any position for this group after this point is invalid.
    last LOOP if $pos > 0 && $line->[$pos - 1] == 1;

    # Check that there isn't a known set cell directly after this group.
    # This check isn't actually needed (it will get checked when doing the
    # preceding check for the next group.)
    #next LOOP if $pos + $clues->[$clueIdx] < $#$line &&
    #             $line->[$pos + $clues->[$clueIdx]] == 1;

    # Check that there are no known empty cells within the bounds of this
    # group.
    for my $i ($pos..$pos+$clues->[$clueIdx]-1) {
      next LOOP if $line->[$i] == 2;
    }
    
    # For the last clue, also check that the remainder of the line is empty.
    if($clueIdx == $#$clues && !$emptyLine) {
      for my $i ($pos + $clues->[$clueIdx] .. $#$line) {
        next LOOP if $line->[$i] == 1;
      }
      # Keep track that we've already determined the remainder of the line
      # is empty; this saves redoing this check over and over.
      $emptyLine = 1;
    }

    # This placement is ok.
    $solveState->[0]->[$clueIdx] = $pos;

    # If this was the last clue, then the entire line is OK.
    if($clueIdx == $#$clues) {
      my ($ptr, $clue);
      for($ptr = 0, $clue = 0;
          $clue <= $#$clues;
          $clue++) {
        # Mark anything preceding this clue as empty.
        for( ; $ptr < $solveState->[0]->[$clue]; $ptr++) {
          $solveState->[1]->[$ptr] |= 2;
        }

        # Mark the group
        for(my $i = 0; $i < $clues->[$clue]; $ptr++, $i++) {
          $solveState->[1]->[$ptr] |= 1;
        }
      }

      # Mark anything after the last group empty.
      for( ; $ptr <= $#$line; $ptr++) {
        $solveState->[1]->[$ptr] |= 2;
      }
      
    } else {
      # recursively check the next clue.
      placeGroup($line, $clues,
                 $clueIdx + 1, $pos + $clues->[$clueIdx] + 1,
                 $solveState);
    }
  }
}
