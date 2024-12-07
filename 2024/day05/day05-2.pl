#!/usr/bin/perl

use strict vars;

my %rules;
my $part1 = 0;
my $part2 = 0;

# Read all input
while(<>) {
  chomp;
  if(/(\d+)\|(\d+)/) {
    # A rule; add the page to the rules hash. If $rules{x}->{y} is set, then
    # page x must be before page y in the page list.
    $rules{$1}->{$2} = 1;
  } elsif(/,/) {
    # A page list; check if it follows all rules. Note that all rules have
    # been read at this point.
    my @pages = split /,/;
    my $result = 1;
    # For each page in the list, check whether any earlier pages are
    # disallowed.
    LOOP: for my $i (0..$#pages) {
      for my $j (0..$i - 1) {
        if(exists $rules{$pages[$i]}->{$pages[$j]}) {
          $result = 0;
          last;
        }
      }
    }

    if($result) {
      $part1 += $pages[$#pages / 2]; # The middle page number.
    } else {
      # Incorrect order. Sort them, and then add the middle page number to
      # the part2 result.
      @pages = sort {
                      return -1 if exists $rules{$a}->{$b};
                      return 1 if exists $rules{$b}->{$a};
                      return 0; # probably can't happen
                    } @pages;
      $part2 += $pages[$#pages / 2]; # The middle page number.
    }
  }
}

print "Part 1 result: $part1\n";
print "Part 2 result: $part2\n";
