# Day 17: Pyroclastic Flow

(This problem)[https://adventofcode.com/2022/day/17] is a physical
simulation with fairly complicated rules---five different shapes of objects
that interact with the rocks that have already fallen into place.

The chamber is 7 units wide and infinitely tall; I'll implement that as a
matrix where the lowest row is row 0 and increases with height. I'll want a
function to determine if a given rock can move in a particular direction.

If I implement the shapes and the board as bitfields, then I can use bitwise
operations to detect collisions. The shapes start at 2 units from the left
edge. Using 1 byte for each line of the shapes, my shapes are:

0x3C000000, 0x10381000, 0x08083800, 0x20202020, 0x30300000

If any of the 0x80 bits are set, then the shape is at the left edge; if any
of the 0x02 bits are set, it's at the right edge. To move the shape left or
right, just bitshift the value. To check for collisions moving down, just
bitwise AND the row of the shape with the appropriate row of the board and
see if any bits are set. To add the shape to the board, bitwise OR the rows
of the shape into the rows of the board.
