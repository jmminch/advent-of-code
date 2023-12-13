# Day 13: Point of Incidence

<https://adventofcode.com/2023/day/13>

The algorithm to check for reflections is pretty straightforward--just
iterate through the possible horizontal locations and check for reflections,
followed by the possible vertical locations.

I'll just represent the board as a list of strings; for the vertical
reflection I'll be able to compare lines with `eq`; for horizontal
reflections I'll generate a set of strings representing the columns.

For part 2, the one tricky point is that the new reflection line is required
to be different than the old one; so I'll add a parameter to my function
that determines the location of a reflection to skip the location found
before.

I will just iterate through the map, flipping one character at a time, until
I find the one that results in a new reflection. I'm sure I could come up
with a more efficient way to do this though.

```
$ perl day13.pl < input 
Part 1 result: 28895
Part 2 result: 31603
```

One way to make this more efficient is to go through the rows/columns and
determine:

1. For part 1, which rows/cols are identical? When an identical pair is
   found, then the midpoint of those pairs could be a reflection line
2. For part 2, which rows/cols differ by a single character? Try flipping
   the character at that location, and then check the midpoint of that pair
   for a reflection line.

I implemented this as day13-2.pl. It is quite a bit faster (about 4x on my
system; but even the first implementation takes less than 100ms.) I suspect
I could do a little better as the way I check for a single-character
difference is still kind of slow.
