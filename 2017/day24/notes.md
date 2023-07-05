# Day 24: Electromagnetic Moat

<https://adventofcode.com/2017/day/24>

We're playing dominoes!

For this problem there's a set of "components" made up of pairs of numbers.
The object is to arrange them, each one connecting to a different piece with
an identical number, like dominoes. The chain must start with a 0, and we're
looking for the arrangement with the highest "strength" (total of all
numbers in the chain.)

Part 2 is to look for the longest chain, with ties broken by the strength.

This seems fairly straightforward. Have a recursive function that takes the
value of the current end and a list of remaining pieces. That function will
loop through all available pieces in turn, and if it has a matching value
remove it and then call the function with the new end point and list.

If no remaining pieces fit, then check whether the strength is higher than
any other found (if so, then record it as the new max strength), and whether
the length is higher than any other found (if so, record the strength as the
strength for part 2) or the length is equal to the longest found (if so,
then if the strength is longer than earlier ones, record it.)

While writing the code, I decided that instead of modifying the list and
passing it to the function recursively, I would instead just have a global
list that tracks whether each element has already been used (and so can be
excluded.)

My first attempt gives the correct result for the test data, but for the
real data it does not (gives instead the same result for parts 1 and 2.)

```
$ perl day24.pl < adventofcode.com_2017_day_24_input.txt 
Part 1 result: 1906
Part 2 result: 1906
```

Turns out it was a silly mistake where I was not resetting the max recorded
strength correctly when I find a longer chain than we've already found
before. Correcting that and it works fine. It's a little slower than I'd
like, though.

```
$ time perl day24.pl < adventofcode.com_2017_day_24_input.txt 
Part 1 result: 1906
Part 2 result: 1824

real	0m4.903s
user	0m4.894s
sys	0m0.003s
```
