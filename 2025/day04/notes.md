# Day 4: Printing Department

<https://adventofcode.com/2025/day/4>

Part 1 is simple; the main thing is to figure out a reasonable way to
represent the data. Since I will want to access cells outside the specified
grid (since I want to treat the edges as rows of empty cells) I will add a
line of '.' before and after the data.

This kind of looked like a cellular automata problem, and part 2 is one,
albeit a very simple one.

```
$ time perl day04.pl < input 
Part 1 result: 1419
Part 1 result: 8739

real	0m0.630s
user	0m0.619s
sys	0m0.009s
```

I decided to try improving the efficiency on this. A couple things that I
noticed:

1. For part 2, there's no actual requirement to remove each set of '@' in
   discrete steps, so I don't actually need to maintain two copies of the
   map (and recopy it each time).
2. After each '@' is removed, I only actually have to look at the adjacent
   squares to determine if there is any more work to do.

So my approach will be:

- Store the number of adjacent '@' cells for each cell in the map.
- Make a hash of all cells that contain an '@'. During this, count the number
  of cells that have less than 4 neighbors; that is the result for part 1.
- Repetitively remove one key from the hash
  - If the cell has less than 4 neighbors, then count it for part 2, and
    remove it by decrementing the counts for all of its neighbors. Add all
    of its neighbors to the hash.

```
$ time perl  day04-2.pl < input 
Part 1 result: 1419
Part 2 result: 8739

real	0m0.034s
user	0m0.030s
sys	0m0.004s
```

One problem I ran into was that I couldn't figure out a good way to get an
arbitrary key that exists in a hash. (keys %q)[0] works, but it's really
slow. So what I ended up doing was having a list, as well as a hash that
represents what elements are present in the list.
