# Day 17: Two Steps Forward

<https://adventofcode.com/2016/day/17>

This is a pathfinding problem. For part 2, we need to find the longest
possible path. There shouldn't be any way for paths to "loop" (either they
will terminate in a dead end or will reach to target square), so I need to
find every possible path.

The easiest way to do that is to have a queue of states to check (the
current room and the maze state string), and then repeatedly pop the head of
the queue and evaluate it (either adding new states to the queue, or
recording the info if the square is the target.)

```
$ time perl day17.pl  
Part 1 result: RDRLDRDURD
Part 2 result: 596

real	0m0.061s
user	0m0.056s
sys	0m0.004s
```
