# Day 13: Knights of the Dinner Table

[Today's problem](https://adventofcode.com/2015/day/13) is to take a list of
people and find the arrangement that makes the group "happiest", based on
the input of how much more or less happy each person gets sitting next to
each other.

I'll just generate all permutations and figure out which of them results in
the highest resulting happiness.

```
$ perl day13-1.pl < input.txt 
part 1 result: 618
```

Part 2 is to add one more person (yourself) to the list, who doesn't change
any happiness by sitting next to anyone.

```
$ perl day13-1.pl < input.txt 
part 1 result: 618
part 2 result: 601
```

So the group is less happy due to your existence.
