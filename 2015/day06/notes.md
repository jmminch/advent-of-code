# Day 6: Probably a Fire Hazard

This problem has a 1000x1000 grid of cells, and a set of instructions to
turn on, off, or toggle a given rectangular subset of those cells. The
object is to find the number of cells turned on after running all the
instructions.

I'm just going to actually track the 1000x1000 grid and then count the
results.

While not necessary (1 million cells isn't too much to handle), I'm going to
use the Bit::Vector module to store the rows.

After implementing it, I found that the Bit::Vector module doesn't have
a built-in function to count set bits. (seems like an odd omission.); so I
had to write a function to do that.

```
$ perl  day6.pl < input.txt 
part 1 result: 543903
```

After spending more time than it should have taken due to using the
Bit::Vector module, part 2 requires a counter for each light rather than
just on/off state, so I need to go back and implement it using an array of
integers instead. Oh well.

```
$ perl day6-2.pl < input.txt 
part 2 result: 14687245
```
