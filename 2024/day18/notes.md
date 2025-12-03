# Day 18: RAM Run

<https://adventofcode.com/2024/day/18>

This puzzle is weirdly simple given how late in the month it is; it's
basically just "find the shortest path through this grid."

For the second part, I just added a cell to the map and repeated the
pathfinding until I couldn't find a path; that was really quick to add.
I could make it run a lot quicker by using a binary search to find the first
entry that makes the pathfinding function fail, but that would have taken
somewhat longer to write.

```
$ time perl day18.pl input 
Part 1 result: 432
Part 2 result: 56,27

real	0m11.083s
user	0m11.083s
sys	0m0.000s
```

With a binary search:

```
$ time perl day18-2.pl input 
Part 1 result: 432
Part 2 result: 56,27

real	0m0.039s
user	0m0.039s
sys	0m0.000s
```
