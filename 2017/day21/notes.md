# Day 21: Fractal Art

<https://adventofcode.com/2017/day/21>

The problem here is to take a grid, each cell of which can be on or off,
and split it up into either 2x2 or 3x3 tiles. Then for each tile, there are
rules for how to expand it into a larger tile (3x3 or 4x4). So each
iteration, the grid grows.

The main trick here is that when searching for a matching rule, we need to
rotate/flip the tiles. I'll reduce them to a bitfield and then normalize
them by choosing the representation with the lowest value---to do that,
I'll just try every flip/rotation combination and figure out the lowest.

The result is not short, but it is fairly straightforward.

```
$ perl  day21.pl < input.txt 
Part 1 result: 133
Part 2 result: 2221990
```
