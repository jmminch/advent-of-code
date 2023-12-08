# Day 12: Subterranean Sustainability

<https://adventofcode.com/2018/day/12>

This problem is a 1-dimensional cellular automaton, with the next state of
each cell dependent on the state of the cell and the two cells to either
side (so five total).

This is pretty straightforward to simulate, but then part 2 throws a wrench
into it, as it's asking about the state after 50 billion generations,
which is going to be way to much to simulate.

One possibility is that the sum follows some sort of pattern that I'll be
able to identify; might as well start by looking for that.

Since the cells extend off to infinity in both directions, I can't just use
a simple array. Two options are a hash with the indexes representing 'on'
cells; or store them in an array as well as an offset so I know that the
first element corresponds to cell -50, or whatever.

Since the new state of a cell depends on the two cells to the left or the
right, and "all empty" maps to an empty cell, the most that the field can
grow by in one step is 2 cells.

I think I will use the hash method for my first attempt. When figuring out
which cells to look at for the step, I can go through the hash and add all
cells within 2 cells of an 'on' cell to the list of cells to process.

I simulated 20,000 generations and printed out the sum, as well as the delta
between the sum of the current generation and the last generation. It turns
out that, starting with generation 94, the sum for each generation is 98
more than for the previous generation. For generation 100 the sum is 11593,
and so the result for part 2 should be `11593 + (50e9 - 100) * 98 =
4900000001793`, which is the correct answer.

For a programmatic solution, I will track how many times the delta is the
same until I've had some large number of generations where the delta remains
the same. Then I just use the formula above to solve for the sum at
generation 50e9.

With some CAs (don't know about this one) it would be possible that there
wouldn't be a pattern like this; or that the pattern might be more
complicated. So this isn't a general solution.

```
$ perl day12.pl < test 
Part 1 result: 325
Part 2 result: 999999999374
```
