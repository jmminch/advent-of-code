# Day 22: Monkey Market

<https://adventofcode.com/2024/day/22>

The PRNG that the monkeys used sounds a lot like an XORSHIFT generator.

Part 1 is simply to implement the RNG as described.

For part 2, I eventually just built a big table of the results of every
possible set of deltas, and then when I'm done find the maximum value.
It is kind of slow.

```
$ time perl day22.pl input 
Part 1 result: 17960270302
Part 2 result: 2042

real	0m4.816s
user	0m4.812s
sys	0m0.004s
```
