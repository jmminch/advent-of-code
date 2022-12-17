# Day 9: All in a Single Night

This is pretty much the travelling salesman problem (although you can
start/end on whatever node you want.) The answer they want is the shortest
possible path length, so I'll just generate the permutations and figure out
which is shortest.

```
$ perl day09.pl < input.txt 
part 1 result: 207
```

Part 2 is just to find the longest rather than shortest path.

```
$ perl day09.pl < input.txt 
part 1 result: 207
part 2 result: 804
```
