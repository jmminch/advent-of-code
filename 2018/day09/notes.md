# Day 9: Marble Mania

<https://adventofcode.com/2018/day/9>

This is the type of problem that probably has an elegant solution with
modular arithmetic, but I don't see it; so I'm just going to simulate the
game to completion. For part 1 we're going to place 71945 marbles; for part
2 7194500. That shouldn't be prohibitive to simulate.

I'm going to use C instead of Perl for this one, since for this type of
problem C tends to lend itself to much faster runtimes. This problem is
easily simulated with a doubly-linked list (ring, since the beginning is
linked to the end.)

```
jmminch@ghost  ~/git/advent-of-code/2018/day09
$ ./day09 71944
High score: 418237
jmminch@ghost  ~/git/advent-of-code/2018/day09
$ ./day09 7194400
High score: 3505711612
```
