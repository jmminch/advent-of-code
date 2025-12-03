# Day 2: Gift Shop

<https://adventofcode.com/2025/day/2>

My first attempt for part 1 will be to test each number within the range. I
can probably improve that significantly, though.

This works and is fast enough. Part 2 changes the validation condition, so
improving the efficiency of part 1 wouldn't really help.

Improving the efficiency of part 2 over the naive method is possible, but
probably not required.

```
$ time perl day02.pl < input 
Part 1 result: 21898734247
Part 2 result: 28915664389

real	0m2.026s
user	0m2.022s
sys	0m0.004s
```

I'm going to make an attempt to improve the efficiency of my solution.

To simplify the logic, I will break the ranges up into ranges of numbers
with the same number of digits. So 998-1002 will be turned into two ranges,
998-999 and 1000-1002.

When checking the range of IDs, the valid prefixes will range in length from
1 to L/2. We can skip checking any prefix that is not a factor of L.

If the range is X-Y, with a prefix length of n, then we need to check all
possible prefixes from the first n digits of X to the first n digits of Y.
Since there's only one possible ID made of those n digits repeated with
length L, it's easy to check whether that ID falls within the range.

In fact, for any prefix between the min and max prefix (exclusive), we don't
have to check anything to know it exists within the range.

So the logic will be:

1. Loop through each given range, splitting up input ranges as required.
2. For each prefix length `l` from 1 to L/2 for range X-Y:
    1. For each prefix from substr(X, 0, l) to substr(Y, 0, l), check if
       it is in the range and if so add it to $part2.
    2. Also add to $part1 if l == L/2.

I realize that there's a problem here, though: the ID `12121212`, for
example, would get counted twice. I think the easiest solution is to keep a
hash of found IDs.

Much better:

```
$ time perl day02-2.pl < input 
Part 1 result: 21898734247
Part 2 result: 28915664389

real	0m0.008s
user	0m0.004s
sys	0m0.004s
```
