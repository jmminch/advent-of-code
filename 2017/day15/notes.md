# Day 15: Dueling Generators

<https://adventofcode.com/2017/day/15>

This problem is about random number generators; specifically [Lehmer
RNGs](https://en.wikipedia.org/wiki/Lehmer_random_number_generator), which
are based on the relation `x[n] = (a * x[n-1]) % m`. The two generators
being used here have `m = 2,147,483,647`, and `a = 16807` for one, `a =
48271` for the other. (These are the values referenced in that Wikipedia
article.)

The first problem is to generate the first 40 million numbers from each
generator, and determine how many of the pairs of numbers (the first from
generator A and the first from generator B, etc.) are identical in their low
16 bits.

The second part is to generate the first 5 million numbers from generator A
that are multiples of 4, and the first 5 million from generator B that are
multiples of 8, and then compare them the same way.

This is the kind of problem that will probably be much more efficient
written in C rather than perl (and not much harder to write), so I'm
going to do it that way.

At first I was getting the wrong results; it turned out that with the naive
approach you have to make sure you're using 64-bit arithmetic. Once I fixed
that, it worked fine.

```
$ ./day15 
Part 1 result: 594
Part 2 result: 328
```
