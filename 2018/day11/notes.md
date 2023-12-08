# Day 11: Chronal Charge

<https://adventofcode.com/2018/day/11>

Since we're going to need to refer to the power levels of the various cells
many times, I'm going to start by pre-calculating the power level of each
cell in the 300x300 matrix.

The simplest way to solve the problem is just to check every possible square
of cells from size 1x1 to size 300x300 to find the maximum total power.
However, I think I can make it faster by caching the results for various
squares and lines.

If I want to find the power for square `A,B,N`, I can find it by adding the
power for `A,B,N-1`, the vertical line `A+N-1,BxN`, and the horizontal line
`A,B+N-1xN-1`. If I work from size 1 to size 300, then I'll have already
calculated the square `A,B,N-1`. A line can be calculated as the power of
the line `A,BxN-1` + the last cell.

This works, but it is quite a bit slower than I was anticipating.

```
Part 1 result: 243,17
Part 2 result: 233,228,12

real	1m16.928s
user	1m16.166s
sys	0m0.760s
```
