# Day 16: Reindeer Maze

<https://adventofcode.com/2024/day/16>

This one probably should have been easier than I found it; mostly because I
spent a lot of time trying to work out how to use a Perl heap module.

To find the shortest path from the start to the end, I wanted to use
Dijkstra's algorithm; since the cost (distance) for turns is different than
for single steps, I need a way to queue the nodes I'm working on and keep
them in order. A heap is the best choice for that; I'm familiar with the
idea but I haven't ever written one myself.

So I figured that there had to be some perl modules implementing a heap;
there are several. I first found Heap::Simple, which seemed like it would
be ideal; but after messing with the module for a while I gave up; I
couldn't get it to compile correctly.

So instead I found <https://metacpan.org/pod/Heap>, which was available in
the Debian repo, so at least I could use it. However, if you want to use it
for anything beyond numerical values you have to create a class based on
Heap::Elem to use it. Since I'm not very familiar with perl OOP, and the
documentation on this module is pretty poor, it took some trial and error
for me to figure out how to use it effectively.

However, once that was done, solving the problem was fairly simple.

For part 2, we need to continue searching until we've found every path as
long as the first one found (so until the nodes pulled off the heap have a
higher distance than the part 1 result.) The other thing is that I need to
be able to work out the path taken; I do that by recording in each node the
nodes that can be used to reach that node in the minimum distance (there may
be multiple, since there are multiple paths through the maze.)

```
$ time perl day16.pl input 
Part 1 result: 102460
Part 2 result: 527

real	0m1.688s
user	0m1.680s
sys	0m0.008s
```
