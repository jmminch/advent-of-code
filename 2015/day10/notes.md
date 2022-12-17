# Day 10: Elves Look, Elves Say

The problem today is to take a string of digits, and generate a new string
where each run of identical digits (of any length, including 1 digit) is
replaced by two numbers: the first the number of digits and the second the
digit itself.

Part 1 is to return the length after 40 iterations.  It does look like it's
possible for the size to grow really fast, but I'll try the iterative
approach before seeing if I need to be more clever.

The puzzle input is 1321131112.

```
$ perl day10.pl 
Part 1 result: 492982
```

Part 2 is just to run it ten more times.

```
$ perl day10.pl 
Part 1 result: 492982
Part 2 result: 6989950
```
