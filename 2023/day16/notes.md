# Day 16: The Floor Will Be Lava

<https://adventofcode.com/2023/day/16>

For this problem I will keep separate maps of the layout and of the beams
going through each square. The map of the beams needs to independently track
at least vertical and horizontal beams. I'm not sure that I actually need to
track all four directions since if you end up with a beam going backwards
over an already-travelled path it will simply go backwards through the same
cells that were already covered.

I'll model the beam by having a list of beams with position and direction.
For each step it will do the following until the list is empty:

1. Pull the first entry off the list
2. Move one square in that direction
3. If the square is outside the map bounds, loop back to 1
4. If the square already contains a beam going in this direction, loop back
   to 1
5. Add this beam to the beam map.
6. If the square is empty or has a splitter in this direction, put a new
   beam on the queue on this square in the same dir and loop back to 1
7. If the square has a mirror, turn in the appropriate dir, put a new beam
   on this square in that dir, and loop back to 1.
8. If the square has a splitter going in the opposite direction, then put
   two new beams on the queue, one in each of the perpendicular dirs, and
   loop back to 1.

When the list is empty, then count the cells that have beams passing through
them.

I see now that my assumption that you only need to track horizontal/vertical
beams isn't quite right, since angled mirrors can have a beam come in
horizontally in both directions with a different result. While I probably
could add some extra cases to bail out early for cases where it doesn't
matter, for the moment I'll just track all four directions in the beam map.

Part 2 asks you to determine which entry point results in the most cells
being energized. So I will split the logic to simulate the beam into its own
function, and then loop through the possibilities.

I thought at first that I could make an optimization that when I was done
simulating, to assume that if the beam left the map at a certain point, that
a beam fired backwards at that point would have the same result. That isn't
true, though, due to the way beam splitters behave. I don't see any other
way to optimize this.

```
Part 1 result: 7996
Part 2 result: 8239

real	0m5.054s
user	0m5.024s
sys	0m0.008s
```
