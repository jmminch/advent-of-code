# Day 10: Balance Bots

<https://adventofcode.com/2016/day/10>

For this problem, you have a list of instructions that define the behavior
of "bots" that compare "chips" with two values, and move the chips to either
other bots or an output bin. The instructions give some "starting" values,
and whenever a bot has two chips it should activate and move its chips
according to its definition.

To simplify coding, I'll keep the inventory of which chips are being held by
bots or output bins in the same hash; bots will be identified by their
number, and output bins with a number prefixed by 'o'. I thought about
using negative numbers for the output bins, but since you can have both an
output and bot numbered '0' that's problematic.

I got bit by the perl default 'sort' function; I keep forgetting that by
default sort does a string rather than numerical comparison, which means
that, for instance, sorting the list (2, 10) ends up with the 10 first. Took
a little while to figure out why I was ending up with the wrong answers.

```
$ perl day10.pl < adventofcode.com_2016_day_10_input.txt 
Part 1 result: 47
Part 2 result: 2666
```
