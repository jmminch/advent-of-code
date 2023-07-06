# Day 3: Squares With Three Sides

[This problem](https://adventofcode.com/2016/day/3) is a simple math
problem: given lists of 3 integers, determine which ones have the property
that any number in the list is smaller than the sum of the other 2.

Part 2 changes how the input should be interpreted. Instead of each row
being a set, three rows together form three sets: the first in each row
being one set, the second in each row being another, etc. It does mean that
I need to track multiple rows at a time.

What I decided was to suck up lines, and when I get 3 of them, process all
three at once (both line-by-line for part 1 and column-by-column for part
2.)  Then I clear the array of lines and start over.

```
$ perl day03.pl < input.txt 
Part 1 result: 1032
Part 2 result: 1838
```
