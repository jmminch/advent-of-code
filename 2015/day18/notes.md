# Day 18: Like a GIF For Your Yard

[This](https://adventofcode.com/2015/day/18) is a cellular automaton, with
the same rules as the Game of Life, although in this case it uses a finite
100x100 board. For the purposes of the rules, cells outside the grid count
as 'off'.

I'll model it as a 102x102 board, and store it as a single array of 10404
elements, which makes accessing the neighbors easier. That way, I just need
a list of the offsets to find all the neighbors: `(-103, -102, -101, -1, 1,
101, 102, 103)`.

```
$ perl day18.pl < input.txt 
part 1 result: 821
```

For the second part, the four corner cells ( (1,1), etc. ) are "stuck" on.
To simulate this, I'll set those cells to on at the beginning and then after
each step.

```
$ perl  day18.pl < input.txt 
part 1 result: 821
part 2 result: 886
```
