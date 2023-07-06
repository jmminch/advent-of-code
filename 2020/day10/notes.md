# Day 10: Adapter Array

For [this problem](https://adventofcode.com/2020/day/10), the first part
involves taking the set of input numbers (the "joltage ratings" of a set of
adapters), which have to be arranged in ascending order. For part 1, you
need to use the full set, which means that the list has to be sorted; and
then need to count the number of 1-jolt steps and the number of 3-jolt steps
in the sorted list.

```
$ perl day10.pl < input.txt 
part 1 result: 2201
```

Part 2 is more interesting. Using the rule that each entry in the chain must
be 1, 2, or 3 more than the previous one, it asks how many unique
combinations of the given adapters could you use to connect your device. It
gives a hint that the number is over a trillion, so enumerating them all
will be impractical.

I think the trick is that whenever you have a 3-jolt jump between adapters,
you know that those two have to be part of any valid sequence, since the
valid sequence cannot jump more than 3 at a time. So you only need to
consider combinations of the adapters that are in between the ones before
and after the 3-jolt jump.

Those combinations are completely independent, though, so if you have a
chain like: `(a-b-C)-3-(D-e-f)` where there is a 3-jolt jump from C to D,
then the total number of combinations should be the number of valid
combinations for `a-b-C` times the number of valid combinations for `D-e-f`.
That suggests an algorithm:

1. Split the list into smaller lists that are bounded by 3-jolt jumps
2. Enumerate all valid combinations for each smaller list
3. Multiply together to find the result

To find the number of combinations of the smaller list, I can use the
following:

1. For a list of length 1 or 2, the number of combinations is 1.
2. For a list of more than that, find the number of combinations after
   skipping 0, 1, or 2 entries, depending on whether by skipping the entries
   the increment is <= 3.

```
$ perl day10.pl < input.txt 
part 1 result: 2201
part 2 result: 169255295254528
```

By caching the return values from my function to count the combinations of
the sublist, I'm wondering if the earlier trick to separate the list into
smaller lists is actually required.

With caching and separating into sublists:
```
$ time perl day10.pl < input.txt 
part 1 result: 2201
part 2 result: 169255295254528

real	0m0.007s
user	0m0.003s
sys	0m0.004s
```

Without caching (makes effectively no difference):
```
$ time perl day10.pl < input.txt 
part 1 result: 2201
part 2 result: 169255295254528

real	0m0.007s
user	0m0.002s
sys	0m0.005s
```

With caching, but just processing the full list:
```
$ time perl day10.pl < input.txt 
part 1 result: 2201
part 2 result: 169255295254528

real	0m0.007s
user	0m0.004s
sys	0m0.003s
```

Without the caching, as expected it does not finish. So I guess the extra
optimization to separate the list into smaller sublists is not required,
although at least it worked effectively.
