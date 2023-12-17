# Day 17: Clumsy Crucible 

<https://adventofcode.com/2023/day/17>

I think this is the first actual path-finding problem of the year, which is
pretty unusual, since those tend to come up a lot. We also really haven't
had a virtual-machine problem yet either.

I happened to have time right when the problem was revealed, so I made an
attempt to solve the problem quickly (and get on the leaderboard), but
wasn't successful. I got a solution for part one, but apparently it was not
efficient enough for part two. So I'm going to go back to try to come up
with a better plan.

The trick with this problem is the rules about when you can (and must) turn.
It is possible that you can enter the same map cell from different starting
points and the distance (total heat) to the target will be different.

I think the way to solve this problem is to make the vertices of the graph
be `(x, y, dir)`, where the direction is either horizontal or vertical. If
you arrive at a square, then you need to turn and then travel some number of
squares (1-3 for part 1, 4-10 for part 2) to the next node. I think that
Djikstra's algorithm should do the job.

It's unclear from the directions whether you can start out going down or
just to the right at the start. If I assume that a downward start is
permissable, then we would have two starting points (at distance 0), at
`(0,0,horiz)` and `(0,0,vert)`.

```
$ time perl day17-2.pl < input 
Part 1 result: 722
Part 2 result: 894

real	0m10.961s
user	0m10.935s
sys	0m0.011s
```

On the test input my revised solution is about 80x faster (I didn't let the
original solution run to completion on the actual input.)
