# Day 15: Warehouse Woes

<https://adventofcode.com/2024/day/15>

This one was messy because I felt like I could do reasonably well; I ended
up placing 375 and 419.

The main thing to work out is that you can have a function that determines
if you can push the box in square X to square X+d. If X+d is a floor, then
the answer is yes; if X+d is a wall, then the answer is no, and if X+d is a
box, then you call it recursively to determine if X+d may be pushed into
X+d+d.

Part 2 isn't difficult, but I had a couple simple errors that made it take
much longer than I had expected.
