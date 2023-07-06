# Day 6: Signals and Noise

[This problem](https://adventofcode.com/2016/day/6) is another string
manipulation problem. The input is a list of strings, and the object is
to identify the most frequent letter at each position for all the strings.

Part 2 is to simply find the least frequent letter. No direction is given
for ties, so presumably that won't happen with the given input.

I'll keep track of the letters with a list of hashes; the first element of
the list will represent the first character of each line, and then for each
character I'll increment that value in the associated hash.

```
$ perl day06.pl < input.txt 
Part 1 result: qrqlznrl
Part 2 result: kgzdfaon
```

Kind of a dissapointment that there's no readable message here, but it's
correct.
