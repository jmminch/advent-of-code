# Day 12: Garden Groups 

<https://adventofcode.com/2024/day/12>

It seems like the way to go solve part 1 is to find a plant that hasn't been
counted yet; use a flood-fill algorithm to find all squares in that region;
then look at each square and for each border that each has with a square not
in the region, increment the perimeter.

For part 2 I need to know the number of straight lines in the perimeter
instead of the total length. One way to do that is to only increment the
perimeter for the topmost adjacent cell for vertical walls, or leftmost
adjacent cell for horizontal walls.

```
$ perl  day12.pl input 
Part 1 result: 1381056
Part 2 result: 834828
```
