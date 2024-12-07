# Day 23: A Long Walk

<https://adventofcode.com/2023/day/23>

The problem this time is a pretty straight pathfinding problem, although
this time I'm looking for the longest path possible rather than the shortest
path. So I'll want to try to find all possible paths and keep track of which
one I find is the longest.

A depth-first search is the obvious choice, and works well for part one.
Part two is the same problem but removes the extra rule for slopes; which
makes the code simpler but results in a much larger set of paths.

While I think my solution works, it's unfortunately taking a very long time
to complete. To make it quicker, I either need a way to prune off paths that
won't reach the end faster, or to speed up the process of trying the paths.

Looking at the map, it is a maze of tight passages with occasional
intersections. I could replace it with a graph where each node is an
intersection, and the weight of the connections are the length along the
path to each intersection. Walking along that graph would save me a ton of
overhead of finding my way through the passages each time.

I finally finished this one up a year later. While it wasn't too "hard" from
an algorithmic point of view, it took me a while to create the logic to
build the map of the nodes. Once I had that, the pathfinding was fairly
simple, although it still takes quite a while to complete.

```
$ time perl day23-2.pl input 
Part 1 result: 2282
Part 2 result: 6646

real	0m49.302s
user	0m49.296s
sys	0m0.000s
```
