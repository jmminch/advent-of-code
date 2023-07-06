# Day 9: Stream Processing

<https://adventofcode.com/2017/day/9>

The object of this task is to parse a string that contains "groups"
delimited by `{ }`, and "garbage" delimited by `< >`. Groups can have
multiple children, separated by commas, and garbage can contain characters
escaped by `!`.

The best way to attack this is a recursive parser; I read the characters
one-by-one, and when I encounter a '{' or '<' I call the appropriate
function to read a group or a garbage string.

To get the answer to part 1, I need to calculate a total score for the
entire stream, which is based on structure of the groups; a recursive
approach works best there. For part 2, I need to count the number of
non-cancelled garbage characters, which is easiest to simply track during
the parsing phase.

```
$ perl day9.pl < input.txt 
Part 1 result: 16689
Part 2 result: 7982
```
