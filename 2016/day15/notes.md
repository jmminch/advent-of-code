# Day 15: Timing is Everything

<https://adventofcode.com/2016/day/15>

This looks like an exercise in modular arithmetic.

We have a bunch of discs that will only let a capsule through at known
intervals. Each disc has a location (`x`), a number of positions (`n`), and
a starting position (`k`). We need to find the first time (`t`) for which
the following is true for every disc: `(t + x + k) % n == 0`.

Doing some searching, [this
link](https://en.wikipedia.org/wiki/Chinese_remainder_theorem) seems
helpful. A lot of the math is beyond me (at least without spending quite a
bit of time on it,) but the description of "sieving" makes sense and I can
see how it would work.

Disc #1 will meet the requirement for `t = (n1 - x1 - k1)`, and then for every
at every `n1` steps thereafter.

I can check every `n1` steps until I find a value that also satisfies disc
#2. Then, I can calculate the LCM of `n1` and `n2` (`L2`) and check every
`L2` steps for a value that satisfies disc #3. Calculate the LCM of `L2` and
`n3` and keep repeating until a value of t that satisfies the requirement
for all discs is found.

I used the Math::Utils::lcm function rather than rolling my own.

```
$ time perl day15.pl input 
Part 1 result: 122318
Part 2 result: 3208583

real	0m0.014s
user	0m0.011s
sys	0m0.003s
```
