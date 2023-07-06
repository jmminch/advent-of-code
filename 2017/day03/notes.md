# Day 3: Spiral Memory

<https://adventofcode.com/2017/day/3>

For this problem, we've got an infinite grid where the squares are numbered
in a spiral pattern starting at the center; like this:

```
17  16  15  14  13
18   5   4   3  12
19   6   1   2  11
20   7   8   9  10
21  22  23---> ...
```

The first part of the problem is to find the manhattan distance from a given
input square back to square 1 (so we need the x,y coordinates). There are
two ways I could do it---either just walk step-by-step finding the
coordinates until I get to the right square, or find a little more clever of
an algorithm to figure out the coordinates.

My puzzle input (which square to locate) is 312051; that's small enough that
just walking through the grid should work fine (and is probably the easiest
way to go), although finding an algorithm is probably more interesting.
Looking at that first:

The spiral pattern will form a set of concentric squares with odd-length
edges (1x1, 3x3, 5x5, etc.). Cell 1 is on the "edge" of the 1x1 square,
cells 2-9 are on the edge of the 3x3 square, etc. The manhattan distance to
a cell on the edge of one of those squares is the distance from the center
(cell 1) to the center of the edge of one of those squares (e.g., cells 11,
15, 19, or 23 for the 5x5 square); plus the distance from that cell to the
center cell of the side that it's on.

The distance from cell 1 to the side of the square with size nxn is
`(n-1) / 2`; so it's useful to be able to translate from the cell ID to `n`.
That turns out to be the square root of the cell ID, rounded up to the
nearest odd number.

The numbering of the sides starts at the cell directly above the
bottom-right corner cell of the square, which is cell ID `(n-2)*(n-2)+1`.
There will be `n-1` cells in the side, ending at the top-right corner, and
then it repeats for each side. To get the position of the cell ID `x` 
along the side, I can use `p = (x - ((n-2)*(n-2)+1)) % (n-1)`. Finally, the
distance from that cell to the center of the side would be
`abs((n-3)/2 - p)`.

Checking my logic, let's do square 14. `n = sqrt(14) = 3.7`; rounded up to
the nearest odd number `n = 5`. The distance to the side is `(5-1) / 2 = 2`.
The position is `(14-(3*3+1)) % 4 = 0`. The distance to the center of the
side would then be `abs((5-3)/2 - 0) = 1`, and so the total distance is 3,
which is correct.

So now to try the actual input, 312051.

```
n = sqrt(312051) = 558.6
rounded up to n = 559

ds = (559-1)/2 = 279
p = (312051 - (557*557 + 1)) % 558 = 1801 % 558 = 127
dc = abs((559-3)/2 - 127) = 151
d = ds + dc = 430
```

This is the right answer. In practice, if I had been pressed for time, it
almost certainly would have been more efficient to just write a program to
iterate through all the squares instead of trying to figure this out.

Part 2 is very different. It asks you to visit each cell in order,
starting with cell 1. The value '1' should be put into cell 1, and then
each cell thereafter will be given the sum of all adjacent (including
diagonally-adjacent) cells; we're looking for the coordinates of the first
cell that will receive a value larger than the puzzle input.

While there may be a clever way to do this without actually walking through
the grid, it's not obvious to me. So I'll have to create a program that does
that work anyway.

To do that, we want to move in a spiral pattern, first starting by moving
one square right of cell 1. The pattern is: move forward 1 square, turn,
move 1 square, turn, move 2 squares, turn, then 2, then 3, 3, 4, 4, etc.

I'll store the grid as a hash indexed by the "x,y"; that makes it easy to
look up all the adjacent squares.

```
$ perl day3.pl 
Part 1 result: 430
Part 2 result: 312453
```
