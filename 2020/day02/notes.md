# Day 2: Password Philosophy

[Part 1](https://adventofcode.com/2020/day/2) is to take strings that look
like: `1-3 b: cdefg` and determine whether the number of times that the
letter given appears in the word at the end (the password), and whether it's
within the numerical range given.

Part 2 is to apply a different rule; the specified character must appear at
one (and only one) of the positions given by the range at the beginning.
Characters are indexed starting at 1.

```
$ perl day02.pl < input.txt 
part 1 result: 550
part 2 result: 634
```
