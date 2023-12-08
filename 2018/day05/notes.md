# Day 5: Alchemical Reduction

<https://adventofcode.com/2018/day/5>

Building a function to perform the reactions is simple enough; just need to
make sure that we keep trying to find units to react until all reactions
have been found.

Rather than starting over at the beginning repeatedly, I can have a pointer
to the current unit I'm looking at. When I find a pair of units to remove,
the pointer just needs to be decremented by one since anything before that
can't have changed and therefore doesn't need to be re-checked. Once I hit
the end of the string, the reaction is complete.

It seems like there might be a clever solution to part two that doesn't
involve trying to remove every type of letter, but I can't come up with one.

```
$ perl day05.pl < input 
Part 1 result: 10762
Part 2 result: 6946
```
