# Day 7: Laboratories

<https://adventofcode.com/2025/day/7>

For the first part, at least, I don't actually have to store or build the
map -- instead I just need a list of beam locations and then process the
current line.

I'll use a hash to track the beam locations, since two beams landing on the
same position are treated as a single beam.

So my procedure:

1. Read the first line, and look at the index of the 'S' character to find the
starting location of the beam.
2. For each line:
    1. For each '^' character:
        1. If there is a beam at that location, remove it and add beams at
           the locations to either side.

Note that there are no cases where two splitters are next to each other.
Because of the way the problem is written, it's unclear what the result
would be in that case.

For part 2, we essentially need to consider multiple beams at the same
location as being different. This could be done by using a list instead of a
hash. However, I kind of suspect that would result in running out of memory.

Instead, I think I should just keep a counter of the beams at each location.
When we split beams, we need to add the number of incoming beams to both the
left and right locations.

```
$ perl day07.pl < input 
Part 1 result: 1504
Part 2 result: 5137133207830
```
