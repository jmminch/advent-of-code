# Day 8: Resonant Collinearity 

<https://adventofcode.com/2024/day/8>

If we have two antennas, and the vector from A1 to A2 is v, then there is an
antinode at A1 - v. So part one is pretty trivial. For each antenna, find
all matching frequency antennas, and then calculate the vectors between each
to locate all the antinodes.

Part 2 requires just a minor change from part 1. Instead of just marking one
position per antinode, instead we step forward until stepping off the edge
of the map. I did a copy/paste to do it quickly (actually ranked on the
leaderboard for star 2, which I usually do not), but it would be nicer to
generalize the function for both parts.

One thing that I didn't know whether I would have to handle is cases like:

```
......
.A..A.
......
```

The description "any grid position exactly in line with at least two
antennas" makes me think that everything on the middle line should be an
antinode. However, my code gave the expected answer for the test input by
just stepping 3 spaces each time, so that's what I did for the actual input,
which turned out OK. I'm not positive whether that's because this sort of
scenario doesn't occur in the input data or whether this is the way we're
expected to interpret the problem.

Since the requirement was "exactly in line", my thinking was that I might
have to find the GCF of dx/dy and reduce the fraction first, but turns out
that's not needed.

```
$ perl day08.pl input 
Part 1 result: 398
Part 2 result: 1333
```
