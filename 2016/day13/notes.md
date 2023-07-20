# Day 13: A Maze of Twisty Little Cubicles

<https://adventofcode.com/2016/day/13>

This is a pathfinding problem; we have a grid of open or blocked squares and
need to find the shortest path to a given square (part 1), or how many
distinct locations can be reached in a certain number of steps (part 2.)

The trick here is that instead of providing a map of squares, instead the
state of the squares are defined by a (kind of weird) mathematical function.
That's no problem, though; I'll just define a function like isBlocked(x,y)
which evaluates the function and returns true or false. The puzzle input is
a seed value for that function, in this case 1362.

isBlocked probably should cache its return values. I'm going to try using
the Memoize module to handle that...I've always done the caching code myself
for situations like this, but I've seen references to this module which does
that work for you.

I encoded the coordinates as a single integer using
`c = (512 + x) | ((512 + y) << 16)`. The convenient thing about that is that
you can move through the grid by just adding/subtracting an appropriate
value. This would fall apart if the x/y coordinates get too large, but given
the problem description the coordinates should stay close enough to the
origin.

```
$ perl day13.pl 1362
Part 1 result: 82
Part 2 result: 138
```

It turns out that using memoize() doesn't make any significant difference in
the runtime (it's pretty fast regardless.) Based on how the code works,
you'll only call isBlocked() on a particular cell a maximum of four times,
and usually it will be fewer, so it ends up evening out.
