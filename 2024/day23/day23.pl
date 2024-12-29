#!/usr/bin/perl

use strict vars;
use Bit::Vector;

our %connections;

while(<>) {
  if(/(..)-(..)/) {
    my $c1 = $1;
    my $c2 = $2;

    $connections{$c1}->{$c2} = 1;
    $connections{$c2}->{$c1} = 1;
  }
}

my @comp = keys %connections;
my @groups;

for my $i (0..$#comp - 2) {
  my $ic = $comp[$i];
  for my $j ($i + 1 .. $#comp - 1) {
    my $jc = $comp[$j];
    for my $k ($j + 1 .. $#comp) {
      my $kc = $comp[$k];

      if($connections{$ic}->{$jc} &&
         $connections{$ic}->{$kc} &&
         $connections{$jc}->{$kc}) {
        if($ic =~ /^t/ ||
           $jc =~ /^t/ ||
           $kc =~ /^t/) {
          push @groups, [ sort ($ic, $jc, $kc) ];
        }
      }
    }
  }
}

printf "Part 1 result: %d\n", scalar @groups;

our @cliques = ( );
my $P = { };
for my $v (keys %connections) {
  $P->{$v} = 1;
}

BronKerbosch({ }, $P, { });

my ($maxSize, $maxClique);
for my $c (@cliques) {
  if(scalar(keys %{$c}) > $maxSize) {
    $maxSize = scalar keys %{$c};
    $maxClique = $c;
  }
}

printf "Part 2 result: %s\n", join(',', sort keys %{$maxClique});

sub BronKerbosch {
  my ($R, $P, $X) = @_;

  #printf "R: %s\n", printSet($R);
  #printf "P: %s\n", printSet($P);
  #printf "X: %s\n", printSet($X);
  #print "\n";

  if(scalar(keys %{$P}) == 0 && scalar(keys %{$X}) == 0) {
    #printf "clique size %d\n", scalar keys %$R;
    push @cliques, $R;
  }

  for my $v (keys %$P) {
    # Create R + $v
    my $R2 = { %$R };
    $R2->{$v} = 1;

    # Restrict P and X to neighbors of $v
    my $P2 = { };
    for my $v2 (keys %$P) {
      $P2->{$v2} = 1 if exists $connections{$v}->{$v2};
    }

    my $X2 = { };
    for my $v2 (keys %$X) {
      $X2->{$v2} = 1 if exists $connections{$v}->{$v2};
    }


    BronKerbosch($R2, $P2, $X2);

    delete $P->{$v};
    $X->{$v} = 1;
  }
}

sub printSet {
  return join(',', keys %{$_[0]});
}
