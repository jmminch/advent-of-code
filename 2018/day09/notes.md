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

This takes about 60 ms to run. After solving it I went back to my previous
solutions since this was a year that I had done before; turns out last time
I did the solution in perl using perl arrays to store the marble circle.
While it's a simple solution to write, that's very slow. Turns out that it
takes more than an hour to solve part 2.

I re-implemented my C version in perl, using a linked list rather than a
perl array.

```
$ time perl day09.pl 
High score: 3505711612

real	0m4.706s
user	0m4.286s
sys	0m0.411s
```

So it's slower by about a factor of 100, but still usable. Given that it's
only about half the length of the C version maybe I should have started with
that, although I think that both versions took me about the same amount of
time to write.
