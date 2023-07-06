# Day 22: Sporifica Virus

<https://adventofcode.com/2017/day/22>

For this problem, we've got a "virus carrier" (robot) that moves through an
infinite grid, moving and infecting cells based on a set of rules. The rules
for part 1 and part 2 are a little different; the object in both is to
determine how many of the first `n` steps result in a cell becoming
infected.

For this one, I'll use a hash to represent the grid; non-existent entries
are "clean".

There's a bit of ambiguity in the problem description where it asks
"how many bursts cause a node to become infected? (Do not count nodes that
begin infected.)" Based on the correct answer, by this they meant that a
node that we should still count a node that starts infected, becomes clean,
and then infected again.

```
$ perl  day22.pl < input.txt 
Part 1 result: 5196
Part 2 result: 2511633
```
