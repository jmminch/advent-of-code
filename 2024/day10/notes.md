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

I originally just copy/pasted the part 1 logic and altered it for part 2,
but later went back and changed it so that I just ran the part 2 logic
(returning a list of all peaks, with duplicates when there are multiple
paths to a peak,) and then filter out the duplicates to get the part 1
answer. It's slightly faster, but not by much.

I originally did the memoization of the code manually, as I wasn't sure
whether the Memoize module would handle returning arrays. I tried it with
the Memoize module, and it works, although it does take measurably longer to
complete. (That said, it's still only in the 10-20 ms range total, so it's
not a significant time.)
