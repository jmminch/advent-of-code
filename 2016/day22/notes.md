# Day 22: Grid Computing

<https://adventofcode.com/2016/day/22>

For my first attempt (`day22.pl`) I attempted to do a BFS of all
possible moves. The state at each step was the state of the map. This ran
out of memory within a few steps. Even after some improvements, I still only
got to a depth of 10 before the OOM killer triggered.

I then looked at the input data and noticed that there was an empty node
which could hold most of the data from other nodes, similar to the example
input. I decided to try a similar approach to what was described, where I
only track the position of the empty node and the goal data, and just move
the empty node around. That reduces the search space a ton, and I find a
solution with length 227, which is the right answer.

This isn't really a general solution, though.

```
$ time perl day22-2.pl < input 
Part 1 result: 892
Part 2 result: 227

real	0m9.506s
user	0m9.482s
sys	0m0.024s
```
