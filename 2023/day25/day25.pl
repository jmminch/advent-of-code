#!/usr/bin/perl

use strict vars;
use Data::Dumper;

# Read the graph
my %graph;
while(<>) {
  chomp;
  if(/(\w+): (\w(.*\w)?)$/) {
    my $node1 = $1;
    my @connect = split / /, $2;
    for my $node2 (@connect) {
      $graph{$node1}->{$node2} = 1;
      $graph{$node2}->{$node1} = 1;
    }
  }
}

my $iterations = 1;
while(1) {
  my ($edges, $size1, $size2) = findCut(\%graph);
  if($edges == 3) {
    printf "Part 1 result: %d\n", $size1 * $size2;
    #print "iterations = $iterations\n";
    last;
  }
  $iterations++;
}

sub findCut {
  # Make a copy of the input graph.
  my %graph;
  my %size;
  for my $node (keys %{$_[0]}) {
    $graph{$node} = { %{$_[0]->{$node}} };
    $size{$node} = 1;
  }

  while((scalar keys %graph) > 2) {
    # Pick a random node 
    my $node = (keys %graph)[rand keys %graph];

    # If any of the edges attached to this node have a weight of more than
    # 3, then a valid solution requires merging them -- so pick that
    # attached node to merge.
    my $node2 = undef;
    for my $x (keys %{$graph{$node}}) {
      if($graph{$node}->{$x} > 3) {
        $node2 = $x;
        last;
      }
    }

    if(!defined $node2) {
      # Now pick a random node that it's connected to to merge into.
      $node2 = ((keys %{$graph{$node}})[rand keys %{$graph{$node}}]);
    }

    # Move all of the other edges attached to $node to $node2.
    for my $x (keys %{$graph{$node}}) {
      next if $x eq $node2;
      $graph{$node2}->{$x} += $graph{$node}->{$x};
      $graph{$x}->{$node2} += $graph{$x}->{$node};
      delete $graph{$x}->{$node};
      delete $graph{$node2}->{$node};
    }

    $size{$node2} += $size{$node};

    delete $graph{$node};
    delete $size{$node};
  }

  my @nodes = keys %graph;
  return ($graph{$nodes[0]}->{$nodes[1]}, $size{$nodes[0]}, $size{$nodes[1]});
}
