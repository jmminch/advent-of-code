# Day 12: Hot Springs

<https://adventofcode.com/2023/day/12>

To solve this problem, I'll work through each string left to right, trying
to replace each '?' with either a '.' or '#' until finding a contradiction
or reaching the end of the string.

Most simplistically, I could just try the combinations until reaching the
end of the string and then checking whether the result matches the group
sizes given. It looks like the number of unknowns in a line don't go past
about 10 or so, which is only around 1,000 combinations; so we could try
them all.

To get fancier and more interesting, I could determine if the partial line
that I've built matches the group sizes and bail out early if it does not.
To do that, I would determine the group sizes for the partial group built;
something like:

`#.##.## => 1,2,2+`

The final group is unclosed, and so this could match any group size line
that starts `1,2` and then has a number 2 or larger for the third group.

```
$ time perl day12.pl < input 
Part 1 result: 7163

real	0m11.978s
user	0m11.957s
sys	0m0.004s
```

My first attempt (without any attempt at optimization) runs, but it's rather
slower than I expected. Part 2 expands the size of the strings and so will
take way longer to run, so I will need to improve its efficiency.
