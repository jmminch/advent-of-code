# Day 9: Movie Theater

<https://adventofcode.com/2025/day/9>

There are 496 points defined by the input, for a maximum of `496C2 = 122760`
combinations. While I can think of some ways to significantly reduce the
number of pairs to check, this number is small enough that I'm not going to
do so, at least until I get a part 1 result.

Note one trick: the length of the rectangle sides is 1 more than the
difference in the coordinates.

Part 2 is a lot trickier (and the ideas I had to improve part 1 probably
wouldn't have helped any, so good thing I didn't bother.)

My first thought is that each point in the input now defines the (right
angle) corner of a polygon, so we can start at each point and see what the
largest rectangle that can be made starting at that corner would be. It
would never be ideal to start on an edge.

If I could create a list of the edges where we transition from inside to
outside the polygon, then I could start by determining the furthest a 1x
rectangle can extend in one direction; then keep extending that
perpendicularly until it hits an exterior edge. Then we shrink the size of
the first edge approrpiately and keep extending perpendicularly, continuing
until we find the maximum size of the 1x rectrangle extending in the other
direction.

One thing to watch out for would be a diagram like this:

```
1----25---6
|    ||   |
|    34   |
|         |
8---------7
```

A rectangle can extend all the way from 1 to 6, since there's no empty space
between the `23` and `45` walls. While I don't believe that the polygon can
intersect itself based on how the problem is written, this could be a
possible layout. I might want to start by trying to determine if this
actually occurs in the input data (since handling this case is probably
going to take some work.)

I did write a test for adjacent edges; this case does not occur.

To figure out which side of the edges form the interior, I can use Green's
Theorum; if the sum of `x1y2 - x2y1` is positive then the order of the
vertices is clockwise, otherwise it's counterclockwise. (Note that's
backwards from normal, since the convention used here is that increasing Y
is down.) I can then use that to create a list of line segments that are
exterior to the shape. I can check at the same time whether any of them
overlap an edge of the shape (which would mean that I need to handle the
adjacent edge case.)

After that, I want to find all convex vertices, and for each of them do the
process that I described above. In a little more detail, I think the
procedure I want to do is like the following (assuming a top-left corner.)

1. Find the first vertical edge (VE1) to the right of the corner. (Call the
   x-coordinate of this edge X1.)
2. Find the first horizontal edge (HE1) below Y, which overlaps the range
   X -> X1, call the y-coordinate Y1.
3. The rectangle X,Y -> X1,Y1 is a valid rectangle; calculate its area and
   track it if it is the largest one found.
4. If the horizontal edge overlaps X, then we're done. If it doesn't, then
   set X2 to one less than the leftmost edge of HE1.
5. Find the first horizontal edge (HE2) below Y1, which overlaps the range
   X -> X2; this is Y2
6. Repeat steps 3-5 until completing.


This is kind of difficult to keep straight with the different possible
directions, and I don't want to have to rewrite it four times. So instead
what I want to do is define coordinates U,V where the vertex I'm looking at
is at (0,0), the edge lies on the U-axis oriented towards increasing U. Then
I'll just work on transformed coordinates.

After some work, it occurs to me that it would reduce the number of special
cases I have to deal with if the coordinates that I was working with were
the coordinates of the vertices themselves, instead of the coordinates of
the tiles -- a square from (0,0) to (1,1) in tile coordinates is a 2x2
square, which is odd, and it causes some headaches with figuring out where
ranges overlap. So I'm going to preprocess the list of tile locations first
to create a list of vertices.

After implementing, my solution does work. The only problem is it turns out
I misread/misinterpreted the problem -- rectangles still need to be defined
by two red corner squares. My solution found the biggest rectangle that fits
within the shape, even if the corners of the rectangle are on the sides of
the polygon.

A lot of my effort was probably wasted here. There's a few approaches I
could take to solving part 2. The simplest one is probably to do the same
method as part 1, but check whether any edge crosses the rectangle formed by 
the two points.

```
$ time perl day09.pl < input 
Part 1 result: 4769758290
Part 2 result: 1588990708

real	0m18.221s
user	0m18.209s
sys	0m0.009s
```

I'd like to try to do better here. First off, low-hanging fruit -- I don't
need to check whether there's an overlapping edge if the area of the
rectangle I'm looking at is smaller than the largest one found for part to.
That decreases the time to about 8.7 seconds.

Next, I can eliminate a lot of checking if I sort the edges and only check
edges within the range of the rectangle I'm looking at. A simple version of
that gets it down to around 900 ms.

```
$ time perl  day09.pl < input 
Part 1 result: 4769758290
Part 2 result: 1574349244

real	0m0.901s
user	0m0.897s
sys	0m0.004s
```

I attempted to be a bit smarter about the sorting to shave off some more
time, but wasn't very successful (and my implementation got the wrong
answer), so I decided that route wasn't going to be very fruitful.
