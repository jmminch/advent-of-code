# Day 23: Opening the Turing Lock

[Today's problem](https://adventofcode.com/2015/day/23) is one where you
need to emulate a simple computer architecture; this one seems easier than
some of the ones there's been in other years: 3 instructions to change a
register and 3 to jump on various conditions.

While debugging my code, I went through the input program, which turns out
to be very simple: the first 40 lines are setting an initial value in
register a (lines 1-21 if a starts at 0, and lines 23-40 if a starts at 1 --
which tells me that part 2 is probably going to be "run the same thing with
a starting at 1.") It then runs a loop which increments b, and then halves a
if a is even, or sets a=3a+1 if a is odd, quitting when a reaches 1. No
interesting optimization is required for this one, which is a break from
similar problems in other years.

```
$ perl  day23.pl < input.txt 
part 1 result: 255
part 2 result: 334
```
