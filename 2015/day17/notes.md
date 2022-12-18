# Day 17: No Such Thing as Too Much

[This problem](https://adventofcode.com/2015/day/17) is to take a list of
containers with various capacities, and determine how many different
combinations of those containers could be used to create a total capacity of
exactly 150.

There are 20 containers, so there's 2^20 possible combinations.

An easy way to generate all combinations is to just increment a counter from
0 to (2^20 - 1), with each 1 bit indicating the associated container should
be used.  Since 2^20 is only about a million, probably no more optimization
will be needed.

```
$ perl day17.pl < input.txt 
part 1 result: 4372
```

For part 2, we want to know how many different combinations of containers
use the *least number of containers possible*. So when I find a combination,
I check how many bits are set (number of containers used); if that's lower
than the current minimum found, then I reset my counter of combinations
found and record this as the current minimum. If it's the same as the
current minimum bit number, then I increment my counter of combinations and
if it's greater than the current minimum then I skip this combination.

```
$ perl day17.pl < input.txt 
part 1 result: 4372
part 2 result: 4
```
