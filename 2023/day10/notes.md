# Day 10: Pipe Maze

<https://adventofcode.com/2023/day/10>

There's two methods that come to mind to solve this: I could start at the
start point and have two pointers that move in each direction until they
meet at the middle, or I could arbitrarily pick one direction from the start
point and follow the path all the way around. I'll do the second one.

The first thing to do will be to figure out which type of pipe is beneath
the start tile; after which I'll follow the path around.

Part two is to find the number of cells fully enclosed by the loop. The main
thing that makes this difficult is the rule that "squeezing between adjacent
pipes" is allowed, so simply doing a flood fill on the map isn't going to
work.

One solution is to expand the map so that adjacent pipes have a space
between them. I'll create a new map where coordinates in the new map are
(1+2x), which leaves a border around the edge. Then I fill in squares
corresponding to the loop, as well as squares that correspond to the pipe
exits for all segments of the loop. Finally, I'll do a flood fill starting
at the border, and anything that doesn't end up filled is "inside" the loop.
To get the area I need to count the number of cells that correspond to
original map tiles that are unfilled.

```
$ perl  day10.pl < input 
Part 1 result: 6599
Part 2 result: 477
```
