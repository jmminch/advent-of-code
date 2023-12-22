# Day 22: Sand Slabs

<https://adventofcode.com/2023/day/22>

This is a problem where it can be broken into a bunch of relatively simple
tasks.

The main tasks here are:

1. Convert the input definitions into a usable structure; I think an array
   of block locations would be best.
2. Find which block is present at a particular block location. A hash
   holding the grid may be the most effective.
3. Determine which bricks are supporting a particular brick.
4. Cause a block to drop until it is supported by something. To do that,
   if nothing is supporting this brick, remove it from the hash and move it
   z-1, and then check again.
5. Cause *all* bricks to drop by repeatedly attempting to drop every brick
   in the list until none move.
6. Determine if a brick can be safely removed, by checking whether it is
   *not* the sole support for any other brick.

For part 2, we want to figure out how many bricks would move as a
consequence of removing each particular brick. While I could remove each
brick, then run the `dropAllBricks()` to figure out which bricks move, that
would both be pretty slow and I'd need to reset the map back to its starting
point after each attempt.

The other way to do it would be to determine which bricks are supported
solely by the brick in question, and the bricks solely supported by those,
until no more bricks are found. That's what I'll do.

```
$ time perl day22.pl < input 
Part 1 result: 459
Part 2 result: 75784

real	0m9.535s
user	0m9.489s
sys	0m0.006s
```
