# Day 6: Memory Reallocation

<https://adventofcode.com/2017/day/6>

For this problem, we have an array of 16 integers ("banks with number of
blocks.") We want to repeatedly run a redistribution process, which takes
the blocks from the bank with the most blocks---ties go to the
lowest-numbered bank---and then redistributes them one-by-one among the
banks, starting with the next one. (So similar to Mancala, which is probably
the inspiration for this one.)

The goal is to find a loop in the state of the game, so I'll keep a cache,
indexed by the state, with the turn number when this state was seen. That
will let me know the first turn where a repeated state is detected (part 1)
and how long it has been since that state was seen (part 2).

The input is a single row of tab-separated integers.

```
$ perl day6.pl < input.txt 
Part 1 result: 11137
Part 2 result: 1037
```
