# Day 1: Secret Entrance

<https://adventofcode.com/2025/day/1>

Only twelve puzzles this year is kind of a disappointment.

Looks like the first part is just simple modular arithmetic.

Part 2, while not actually hard, is kind of deceptively easy. I made a
couple attempts without working it out first, which gave the wrong answer
because it's easy to get caught with special cases.

Essentially, the way I think about it is that there's a series of ranges
from X to Y, and we want to count up the number of multiples of 100 that
fall in the range (X, Y]. (Exclusive of X, inclusive of Y).

If Y is more than X, then that number is `floor(Y/100) - floor(X/100)`.
If Y is less than X, then it is `floor((X-1)/100) - floor((Y-1)/100`.

So
    0 - 99 => 0
    0 - 100 => 1
    55 - 105 => 1
    55 - 900 => 9
    99 - 1 => 0
    99 - 0 => 1
    0 - -1 => 0
    0 - -99 => 1
    10 - -99 => 1
    20 => -900 => 10

```
$ perl day01.pl < input 
Part 1 result: 1011
Part 2 result: 5937
```
