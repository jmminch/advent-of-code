# Day 8: Playground

<https://adventofcode.com/2025/day/8>

I need to find the 1,000 closest pairs of points in the data. There are 1000
points in the input data, so there's `SUM(1,999) = 499,500` possible
connections. It's probably tractable to simply try them all, store the
results, and then pick the shortest 1000.

```
$ time perl day08.pl < input 
Part 1 result: 129564
Part 2 result: 42047840

real	0m1.292s
user	0m1.252s
sys	0m0.040s
```

I don't have any really bright ideas to significantly improve this.
