# Day 11: Hex Ed

<https://adventofcode.com/2017/day/11>

This problem involves an infinite hexagonal grid, oriented with flat edges
of the cells on the north and south sides. Given a list of steps (like
`n,ne,s,se,nw`), determine how far the end point is from the origin.

I decided to do a little research on the subject of hex grids, and found
[this resource](https://www.redblobgames.com/grids/hexagons/) which has some
useful information about various hex-based algorithms. The section "cube
coordinates" seems useful; movement in any of the six directions will
increment or decrement two of the q,r,s coordinates. The nice thing about it
(from the "Distances" section) is that the distance to the origin is just
half of the absolute value of the sum of the coordinates.

Using that approach, this problem becomes fairly trivial.

```
$ perl day11.pl < input.txt 
Part 1 result: 808
Part 2 result: 1556
```
