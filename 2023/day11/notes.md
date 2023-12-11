# Day 11: Cosmic Expansion

<https://adventofcode.com/2023/day/11>

There are two parts to this problem: "expanding the universe", and then
finding the "shortest path" between galaxies.

At least for part 1, expanding the universe is kind of a pre-processing
step. Although the input is a grid, for this problem I think that a better
internal representation for the galaxies is a hash indexed by the coordinate
where the galaxies are located.

For expansion, the two methods I considered are either to recalculate the
galaxy coordinates after expansion; or to just track which rows/columns
expanded and make them take two steps to cross in the pathfinding step. I
think that applying the expansion at the pathfinding step will be simpler.

The reference to "shortest path" made it sound like I'd be implementing some
kind of pathfinding, but in reality the problem is just asking for the
Manhattan distance between the points. What I'll need to do is calculate the
normal Manhattan distance, and then add in the number of rows and columns in
between those points that expanded.

I found the number of rows/columns that expanding by iterating through the
all possible rows and columns and looking whether there is an entry in my
list of filled rows/columns, which works, although it really is kind of
slow. I could make things quicker by instead keeping a sorted list of filled
rows/columns, doing a binary search to find the array indices corresponding
to the pair of galaxies I'm processing, and then figuring out how many
entries are "missing" in the array (corresponding to empty rows/columns that
need to be expanded.)

```
$ time perl day11.pl < input 
Part 1 result: 9947476

real	0m0.731s
user	0m0.724s
sys	0m0.005s
```

For part two, instead of empty rows expanding by 1, they expand by a factor
of one million. That results in no logical changes to my function; just add
999,999 to the distance for every expanding row/column instead of 1.

```
$ perl day11.pl < input 
Part 1 result: 9947476
Part 2 result: 519939907614
```

I'm actually a little disappointed in part 2...I was expecting something
like the universe expanding while travelling between the galaxies, which may
have gotten interesting.

I made the change described above to count the expanding rows/columns by
finding indexes into a list, but it's actually no faster than my first
implementation interating through all the possible lines. That kind of
surprises me.
