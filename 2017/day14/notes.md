# Day 14: Disk Defragmentation

<https://adventofcode.com/2017/day/14>

This problem uses the "knot hash" from day 10. It asks us to consider a grid
formed of 128 knot hashes (which are each 128 bits long); the hashes are
generated using the pattern `<input>-<x>`, where `input` is a string (the
puzzle input) and `x` is the row number (starting from zero.)

Part 1 is to calculate the number of "on" bits in the set of 128 hashes.
So for that one I'll just reuse the hash generation code from day 10 and
then count all 128 bits.

Part 2 is to find the number of disconnected "regions" of on bits there are.
A region is a set of on bits that touch each other (orthogonally; diagonals
don't count.) For this, I'll need to create a map structure to look up what
is at a coordinate `(x,y)`. An algorithm that should work:

1. Find any on bit, mark it as in the region. Push its coordinate onto a
   queue.
2. Pop the head of the queue. Check all four of its neighbors. If any of
   them are on, mark it as in the region and push its coordinate onto the
   queue. Repeat until the queue is empty.
3. Increment the count of regions.
4. Turn off any bits in the region from the map.
5. If there are any more on bits, go back to 1.

While writing the code, I realized that it makes things easier to simply
turn off bits from the map as soon as I add the coordinates to the queue;
that way I don't need to find them later to turn them all off in step 4.

The final result is a little slow, although most of that is due to the
amount of time that it takes to generate the 128 knot hashes.

```
$ time perl  day14.pl 
Part 1 result: 8304
Part 2 result: 1018

real	0m1.468s
user	0m1.459s
sys	0m0.005s
```

If I exit right after calculating the hashes, it takes about 1.31 seconds,
so roughly 90% of the time is spent generating those hashes.
