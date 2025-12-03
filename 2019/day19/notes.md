# Day 19: Tractor Beam

<https://adventofcode.com/2019/day/19>

Another day, another Intcode program. Part 1 seems trivial if you have your
existing intcode interpreter.

At a guess, part 2 might be to expand the range that you're looking at,
which may require analysis of the Intcode program itself, but maybe I'm
getting ahead of myself there.

Part 2 isn't quite what I expected, although simply generating the output
for each square will take too long, so I'll need to be a little more clever.

It does look like the actual shape is similar to the one in the example:
there are two lines going diagonally down and right, and the area between
them is filled in. The bottom-left and top-right corners of the 100-square
box I'm looking for will be on the lines.

So if I work down the rows and find the first set square on that row, then
check whether the square 100 up and to the right is also set, that will be
my bottom-left corner.

```
$ perl day19.pl input 
Part 1 result: 186
Part 2 result: 9760485
```
