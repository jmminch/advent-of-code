# Day 8: Memory Maneuver

<https://adventofcode.com/2018/day/8>

Parsing the list of data for this problem should be fairly straightforward.
I'll want a function (parseNode) that parses a node starting at the
beginning of the stream of numbers, and removes numbers as they're used.
It will return:

```
{ children => [child nodes], metadata => [meta values] }
```

Calculating both the metadata total and the node values can then be easily
calculated with a recursive function.

I solved it with one hiccup--I didn't notice that the metadata references
into the children arrays are 1-based rather than 0-based.

```
$ perl day08.pl < input
Part 1 result: 47112
Part 2 result: 28237
```
