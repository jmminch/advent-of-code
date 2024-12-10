# Day 10: Hoof It

<https://adventofcode.com/2024/day/10>

While I tend to favor a queue-based BFS for this sort of problem, a
recursive DFS will probably work best here. I can have a function that
returns the reachable "peaks" from any particular square; for a square with
height 9 that is just the square itself, while for other squares it is all
of the peaks reachable from adjacent squares that are one higher than the
current square.

The results of this from each square can be cached, which should make it run
pretty fast.

Part 2 is a pretty easy change; while for part 1 I exclude duplicate peaks,
the only difference is that in part 2 I need to keep them.

```
$ perl day10.pl input 
Part 1 result: 468
Part 2 result: 966
```
