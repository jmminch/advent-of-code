# Day 7: Bridge Repair

<https://adventofcode.com/2024/day/7>

The only notable thing about today is that I did two solutions. The first
simply iterates through all possible combinations of operators and tries
them one-by-one to see if one works.

The second one is a recursive solution; essentially it works by checking
whether a specified result can be achieved using the last value, any
operator, and the result of the remaining values. This completes far faster
than my original solution---which puzzled me for a little bit. I realized
that the reason is that I get rid of impossible combinations of operators
early: if the result is less than the last number in the list, then
addition cannot be successful, and if the result divided by the last number
is not an integer, then multiplication is not allowed. This must trim off a
ton of possible combinations to check.

While it would be possible to do this sort of optimization with the
iterative solution, it's much more natural with the recursive solution.

```
$ time perl day07.pl input 
Part 1 result: 975671981569
Part 2 result: 223472064194845

real	0m47.213s
user	0m47.209s
sys	0m0.000s

$ time perl day07-2.pl input 
Part 1 result: 975671981569
Part 2 result: 223472064194845

real	0m0.042s
user	0m0.042s
sys	0m0.000s
```

So the recursive solution is roughly 1000x faster.
