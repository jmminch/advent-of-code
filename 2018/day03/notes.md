# Day 3: No Matter How You Slice It

<https://adventofcode.com/2018/day/3>

Here we have a bunch of rectangles and need to determine where they overlap.

The brute-force method is to just create a map of all the cells and track
how many rectangles contain that cell. Since the problem statement gives the
size as 1000 inches (cells) on a side, that's 1 million cells--a lot, but
I think that should be tractable.

```
$ time perl day03.pl < input 
Part 1 result: 115348
Part 2 result: 188

real	0m0.241s
user	0m0.228s
sys	0m0.012s
```

Runs in 240 ms, so it's probably not worth the extra work to make it more
efficient. Given that I'm using a string-keyed hash to hold the map, I could
probably make it run a lot faster by using an array too.
