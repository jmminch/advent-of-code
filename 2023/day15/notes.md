# Day 15: Lens Library

<https://adventofcode.com/2023/day/15>

Part 1 might be the most trivial problem we've had yet this year.

Part 2 is fairly simple, too, it's just that the description is convoluted.

Each box for part 2 will be a list of lenses; the lenses will be represented
as a tuple of ['label', lens]. The operations are to remove a lens with a
given label from the box; replace a lens by label; or add a lens to the back
of the current list (append).

```
$ perl day15.pl < input 
Part 1 result: 509167
Part 2 result: 259333
```
