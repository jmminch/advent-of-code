# Day 24: It Hangs in the Balance

The problem [here](https://adventofcode.com/2015/day/24) is to take a list
of numbers (weights of packages), find the possible ways that you can split
them into three groups where the sums are equal, select the groups with
the smallest number of packages, and find the group where the numbers in
that group have the *smallest possible product.*

The algorithm I came up with was:

1. Find all possible combinations to make a valid group out of the full
   list. Skip if we've already found a valid group that's smaller than this
   one.
2. Find all possible combinations to make a second valid group from the
   remaining ones.
3. The third valid group is what's left over
4. Set the "minimum valid group size" to the minimum of any of these.
5. Skip if the first group found is larger than either of the others
6. Calculate the product, and keep track of it if it's the smallest one
   found so far.

This works, albeit slowly. I first wrote it in perl, and it was taking so
long that I rewrote it in C and almost finished before the perl version
finished.

```
$ ./day24 < input.txt 
part 1 result: 11266889531
```

Part 2 is to split the input into four groups instead of three. This takes
longer because there's more possible combinations.

Because of the way I wrote part 1, I ended up doing a lot of copy-paste
rather than trying to refactor the code to handle both parts. It's ugly, but
it does do the job. Even the C version is pretty slow, though.

```
$ time ./day24 < input.txt 
part 1 result: 11266889531
part 2 result: 77387711

real	4m11.424s
user	4m11.429s
sys	0m0.000s
```

Thinking about it, I think that a better algorithm would be:

1. Starting with a group size of 1 and incrementing, try all possible
   combinations of that size to find a group that sums to the target value
   (one-third or one-quarter of the total, depending on which part).
2. When one is found, then check whether the remaining elements can be
   divided evenly or not. (Just need to find whether there is one, don't
   need to check all combinations). If it cannot, then continue trying
   combinations in step 1.
3. Calculate the product for the group found in step 1 and keep track of the
   minimum product found.
4. Continue checking the remaining groups of this group size to find others
   with the right sum and allow the remainder of the numbers to be divided
   evenly, as in steps 1-2.
5. The lowest product found after checking all groups of this group size is
   the result.

That should prevent a lot of the extra processing that my original algorithm
required. I'm not going to implement that just now, but I might come back at
some point to improve my solution.
