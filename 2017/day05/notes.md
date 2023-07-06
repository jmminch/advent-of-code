# Day 5: A Maze of Twisty Trampolines, All Alike

<https://adventofcode.com/2017/day/5>

The problem in this case involves a list of numbers ("jump instructions".)
Starting from the first element of the list, you move the pointer forward
by the value of that element, and increment the value of the element you
just used by 1. The values may be negative (moving the pointer backwards.)
Part 1 is to determine how long it takes for the pointer to end up outside
the list boundaries.

Part 2 changes the rules a bit: if the offset is three or more, decrement it
rather than incrementing.

```
$ perl  day5.pl < input.txt 
Part 1 result: 391540
Part 2 result: 30513679
```
