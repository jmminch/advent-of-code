# Day 11: Reactor

<https://adventofcode.com/2025/day/11>

Part 1 is pretty simple pathfinding. Since I need to count all possible
paths, I'll just do a depth-first search.

For part 2, I think I just need to find the number of paths from `svr->fft`,
then from `fft->dac`, and finally from `dac->out`, and multiply the results
together.

This isn't quite right -- since the problem says that it has to visit them
"in any order", they could also go from `svr->dac->fft->out`. However, I
don't think there can be any loops in the data, and so only one of the
possibilities of orders for those two can actually be correct.

It was taking a long time; I realized afterwards that although part 1 ran
quickly, by starting from `svr` it must introduce many more paths than when
starting from `you`. I added memoization for the numPaths function.

```
$ time perl day11.pl < input 
Part 1 result: 555
Part 2 result: 502447498690860

real	0m0.025s
user	0m0.017s
sys	0m0.007s
```

Since the part 2 number of paths is gigantic, it probably never would have
finished.
