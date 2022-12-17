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

```
$ perl day17.pl < input.txt 
part 1 result: 3067
```

Part 2 asks the same question for after 1000000000000 (1e12) rocks fall -- so
obviously simulating this is out of the question.

Eventually the pattern has to repeat. We have 5 states for the order of the
shapes, and strlen(input) states for the order of the jets, but given the
same state of those there's also the shape of the floor to account for.

Here's what I'll do -- every time we reach (0, 0) for the shape and input
state, I'll keep track of how many downward steps it takes for the next ten
shapes to come to rest. The assumption being that if those are identical,
then we have an identically-shaped surface for further shapes to land on.
It's a bit ugly, but barring something strange I think it should work.

I realized after starting that looking at (0,0) is a bad idea, because we
start with a solid floor that probably won't be encountered again, so the
first rocks may not be part of the eventual loop.  So what I did was to
start by dropping 1000 rocks to get any pattern started, and store away the
shape/input state. Every time it comes back to the same state of those
values, I then simulate another ten rocks and track the number of steps it
takes them to come to rest; keeping track of those numbers as well as the
current height and number of rocks dropped.

Once I find a matching state, then it's just some arithmetic to figure out
how many loops we'll go through and the corresponding increase in height,
and also how many more steps to take after those loops.

```
$ perl day17-2.pl < input.txt 
Found loop! height = 1537 after 1010, and 4119 after 2715
Simulating 575 more steps.
part 2 result: 1514369501484
```

I realized after submitting that I actually missed something...I forgot to
write the code to keep track of how far the extra ten pieces fell. My answer
was right, so I guess the shortest loop is the correct one, but for
completeness I added the missing code to my solution.
