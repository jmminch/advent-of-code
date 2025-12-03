#!/usr/bin/perl

use strict vars;

require "./intcode.pl";

my $line = <>;
chomp;
my @program = split ',', $line;

runIntcode(\@program, undef, sub { print chr($_[0]) });
