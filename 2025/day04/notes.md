# Day 4: Printing Department

<https://adventofcode.com/2025/day/4>

Part 1 is simple; the main thing is to figure out a reasonable way to
represent the data. Since I will want to access cells outside the specified
grid (since I want to treat the edges as rows of empty cells) I will add a
line of '.' before and after the data.

This kind of looked like a cellular automata problem, and part 2 is one,
albeit a very simple one.

```
$ time perl day04.pl < input 
Part 1 result: 1419
Part 1 result: 8739

real	0m0.630s
user	0m0.619s
sys	0m0.009s
```
