# Day 3: Gear Ratios

<https://adventofcode.com/2023/day/3>

The main thing that makes this problem a little tricky is that the numbers
in the grid take up multiple squares, so you can't just look at the
neighbors for one square to identify whether there is a symbol next to a
number.

My assumption is that numbers don't touch (so there's no ambiguity about
whether a digit counts as a "symbol.")

My approach will be:

1. Search through the grid for the first digit in a number (a square
   containing a digit, where the square to the left does not contain a
   digit.) Set the value of the number being processed to zero.
2. Multiply the value by ten and add the current digit.
3. If we haven't already found an adjacent symbol, check all neighboring
   squares for a symbol. If one is found, remember that fact.
4. If the next square to the right is also a digit, move to the next square
   and return to step 2.
5. Otherwise, a number is complete. If a neighboring symbol was found, then
   add the number to the part 1 answer.

Again, this is a pretty tough problem for this early in the month.

```
$ perl day03.pl < input.txt 
Part 1 result: 525911
```
