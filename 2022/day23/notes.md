# Day 23: Unstable Diffusion

[Today's problem](https://adventofcode.com/2022/day/23) involves simulating
the movement of a group of elves until they are no longer adjacent to any
elves. The main thing here is to get the steps correct. From the reading of
the problem, the code should look like:

1. Read the map and store a list of elves as (x,y) coordinates
2. Set direction list to (N, S, W, E)
3. Move until no elves are adjacent:
    1. Loop through elves and calculate a new location based on the rules.
       If no elves need to move, then break out of the movement loop.
    2. Loop through elves and find any that chose to move to the same place;
       clear their new location.
    3. Move all elves to their new location, if they picked one. While doing
       this, also record the min/max x and y coordinates for the set of
       elves.
    4. Rotate the direction list left.
4. Calculate the number of empty tiles within the rectangle found in 3-3.
   That is `((maxx - minx + 1) * (maxy - miny + 1)) - (# of elves)`.

Part 1 is to determine the number of empty squares within the smallest
bounding rectangle for the elves after 10 rounds, while part 2 is just to
simulate the movement to completion and figure out how many rounds that
takes.

```
$ perl  day23.pl < input.txt 
part 1 result: 4034
part 2 result: 960
```
