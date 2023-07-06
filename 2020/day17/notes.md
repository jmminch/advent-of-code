# Day 17: Conway Cubes

[This](https://adventofcode.com/2020/day/17) is a cellular automata problem
in three dimensions.

For this sort of problem, I like to use a hash indexed by the coordinates;
since for this problem the cells can be either active or inactive, I'll just
say that if the coordinate exists in the hash it is active.

Since the state during the next step only depends on the state of adjacent
cells, we only have to check cells which are currently active or adjacent to
active cells. At first, I just looped through the list of active cells (hash
keys) and processed all cells in the 3x3x3 cube around it, which worked
fine, although it leads to reprocessing a lot of cells.

Part 2 is to do the same problem, but in four dimensions rather than 3.
This approach also worked fine, although it was a little slow:

```
$ time perl day17.pl < input.txt 
part 1 result: 257
part 2 result: 2532

real	0m7.982s
user	0m7.966s
sys	0m0.009s
```

I made a simple change to check whether the cell has been processed or not
already, which cut the time down to under a second:

```
$ time perl day17.pl < test.txt 
part 1 result: 112
part 2 result: 848

real	0m0.689s
user	0m0.679s
sys	0m0.010s
```
