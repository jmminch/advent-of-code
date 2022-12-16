# Day 24: Air Duct Spelunking

Basically pathfinding with a twist; instead of trying to get to a particular
target, instead you want to find a path that visits all of a list of other
points at least once. The question is the minimum required number of steps
to visit all of the marked points.

Since backtracking may be required, you can't remove already-visited cells
from consideration.  However, it seems like the best path will take the
shortest path between each set of points that it visits, and so it's pretty
easy to use Djikstra's algorithm to find the correct path for each segment.

The problem description says that the points are identified as digits; 0 is
the starting point; so there's up to 9 other points that need to be visited.
It should be tractable to brute-force search the 9! =~ 363,000 permutations
of the order to visit the points.

We don't have to run the pathfinding algorithm each time; instead we just
need to calculate the distance from point A to point B once and then cache
that.  The number of combinations should be 10 nCr 2 = 45. (Which I Googled,
since it's been that long since I've done real math.)

To find the permutations, I loop through each number in the list, and then
recursively find the permutations of the remaining numbers in the list.

```
$ perl  day24.pl < input.txt 
part 1 result: 498
```

Part 2 is just the shortest path to start at 0, visit every other point,
then return to 0. The part 1 logic still works, just need to add the
distance from the final point back to 0.

```
$ perl  day24.pl < input.txt 
part 1 result: 498
part 2 result: 804
```
