# Day 24: Blizzard Basin

[Today](https://adventofcode.com/2022/day/24) is pathfinding again, with the
trick that the "walls" are moving. The map is rectangular, with the start and
end points on the outside walls. During each move the expedition can move or
stand still; it may need to go back to already-visited squares as the state
of the walls changes.

Although fairly straightforward, my first implementation had a bug -- I
stored a list of the "next" set of locations to move to, and since I didn't
make sure that there weren't duplicates it grew until the OOM killer killed
my desktop. I fixed that by storing the list in a hash instead.

```
$ perl day24.pl < input.txt 
part 1 result: 283
```

Part 2 is to first go to the end, then back to the start, then back to the
end again. The quickest path from one point to the next should be find (no
need to consider longer paths), so just need to repeat the pathfinding a
couple times. I just pulled the pathfinding code into a function to make
doing so easy.

```
$ perl  day24.pl < input.txt 
part 1 result: 283
part 2 result: 883
```
