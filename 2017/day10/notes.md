# Day 10: Knot Hash

<https://adventofcode.com/2017/day/10>

This problem involves calculating a "hash value" by repeatedly reversing
subsets of a list of values. The main trick is that the list is to be
handled circularly.

To reverse a sublist, I'll have a pointer to both ends of the sublist, and
then repeatedly swap the pointed-to elements and move the pointers towards
each other, wrapping around appropriately. It may not be terribly efficient,
but it should make the code straightforward.

For part 2, there are several steps, but they all are pretty
straightforward.

My part 1 result is correct, but part 2 is not.

```
$ perl  day10.pl < input.txt 
Part 1 result: 826
Part 2 result: cd857ae8e5833954c76b950d8f952dd2
```

I found a problem in my part 2 implementation (typoed one of the magic
numbers that are appended to the length,) but I'm still getting the wrong
answer. Since the part 1 result is right, I've probably got the main hashing
transformation correct, but maybe there's something wrong with the other
steps.

Reading through the problem again, I realize that I missed an important
point---the input is now to be interpreted as a stream of bytes instead of a
list of integers.

```
$ perl  day10.pl < input.txt 
Part 1 result: 826
Part 2 result: d067d3f14d07e09c2e7308c3926605c4
```

This is the correct answer.
