use strict vars;
use Data::Dumper;

my $input = <>;
our @vals = split /\s+/, $input;

my $root = parseNode();

printf "Part 1 result: %d\n", metaSum($root);
printf "Part 2 result: %d\n", nodeValue($root);

sub parseNode {
  # First two values are number of children and number of metadata entries.
  my $nChild = shift @vals;
  my $nMeta = shift @vals;

  # Parse all child nodes
  my @children;
  for(1..$nChild) { push @children, parseNode(); }

  # Get all meta nodes
  my @meta = splice @vals, 0, $nMeta;

  return { children => \@children, metadata => \@meta };
}

sub metaSum {
  my $node = $_[0];
  my $total = 0;
  for my $child (@{$node->{children}}) {
    $total += metaSum($child); 
  }
  for my $metaVal (@{$node->{metadata}}) {
    $total += $metaVal;
  }
  return $total;
}

sub nodeValue {
  my $node = $_[0];

  # If a node has no children, then its value is the sum of the meta
  # entries.
  if(scalar @{$node->{children}} == 0) {
    return metaSum($node);
  }

  my $total = 0;
  for my $metaVal (@{$node->{metadata}}) {
    # Note that the metadata references are 1-based rather than 0.
    $total += nodeValue($node->{children}->[$metaVal - 1]);
  }
  return $total;
}
