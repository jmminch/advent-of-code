# Day 2: Red-Nosed Reports

<https://adventofcode.com/2024/day/2>

For the first part, we need to figure out if each line of input follows a
set of rules; the delta between each needs to be between 1-3 and they need
to be all increasing or all decreasing.

For part 2, the rules are the same, but there's an added step that a line of
input should count if removing any one number from the line would make it
"safe."

I can think of two ways to solve this. The simplest, codewise, is probably
to simply try removing each number and seeing if it results in a safe line.
I could also do something with having the code look at whether either
jumping one or two elements forward in the line to see if it follows the
rules; but that does leave a weird corner case for removing the first
element in the line.

There's only 1000 lines in the input, so simply trying each possibility
to remove should be easily workable.

```
$ perl day02.pl < input 
Part 1 result: 341
Part 2 result: 404
```
