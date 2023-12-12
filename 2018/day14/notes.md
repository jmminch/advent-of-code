# Day 14: Chocolate Charts

<https://adventofcode.com/2018/day/14>

I ran into a bit of trouble debugging my solution for day 13, so I decided
to skip forward a bit and then come back to it.

This problem is mostly just about creating a number sequence by a kind of
weird set of rules. I don't see any straightforward way to generate the
sequence besides just following the procedure as outlined, so that's what
I'll do.

One trick is that each round will add 1-2 numbers to the sequence, so for
part 2 we need to check whether the last numbers match the sequence we're
trying to find after adding each digit, rather than when a round is
finished.

```
$ time perl day14.pl 540561
Part 1 result: 1413131339
Part 2 result: 20254833

real	0m18.286s
user	0m17.634s
sys	0m0.605s
```

Kind of slow due to needing to generate over 20 million numbers of the
sequence, but I don't see a good way of speeding it up much. The method I
use to check whether the last digits match (doing a join on the array slice)
is relatively slow, so I added an extra check of just the first digit before
doing that. That gets me about a 35% speedup.

Doing this in C would probably be quite a bit faster since, if I store the
board as a character array, I could just do the comparisons for part 2 using
memcmp. Decided to try it...

```
$ time ./day14 540561
Part 1 result: 1413131339
Part 2 result: 20254833

real	0m0.278s
user	0m0.270s
sys	0m0.007s
```
