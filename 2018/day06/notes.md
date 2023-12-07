# Day 6: Chronal Coordinates

<https://adventofcode.com/2018/day/6>

It's easy enough to create a map and determine which cell each cell of the
map is closest to. The main trick is eliminating sections where the area is
infinite.

Because of the way the Manhattan distance works, if you have a rectangle
bounding all of the points, and determine the closest point to a point on
the edge, then if you travel directly away from the edge, you'll always be
closest to that same point. So if I draw a rectangle that encloses all the
points, and determine the closest point to every cell in or on that
rectangle, then any region that touches the edge of the rectangle will have
infinite area.

So my algorithm will be to determine a bounding rectangle; then step through
all squares of the rectangle, finding and recording the closest point to
each and keeping track of the area of each region. Finally, go along the
perimeter of the rectangle and eliminate any regions that touch the
perimeter from consideration.

For part 2, we just need to find the number of cells where the total
distance to all points is less than a threshold. That's easy to calculate
while finding the distances for part 1.

```
$ perl day06.pl < input 
Part 1 result: 3401
Part 2 result: 49327
```

This is the right answer, but there could potentially be an issue, because
it's theoretically possible for points outside the bounding box to be within
the threshold total distance from all points.

One approach might be to check whether cells in the part 2 set are on the
boundary, and if they are, then grow the area. Every step outside the area
will increase the total distance by the number of points, so if a point on
the edge is 100 units below the threshold, then we could move the boundary
out `100 units / n points`; do that on all edges and then there shouldn't be
any cells on the boundary less than the threshold.

Implementing this approach appears to work; running with the test set with
the threshold set to 10,000 gives an answer which at least seems reasonable.
Since the test points are all close together compared to the threshold, and
there are 6 points, I would expect the set of points with total distance
less than 10,000 to be a diamond shape that extends 1666 units (`10000 / 6`)
in each direction. The bounding square would be 1.1e7 units in area, and the
diamond area should be about 5.6e6 units in area.

```
$ perl day06.pl < test 
Part 1 result: 17
Part 2 result: 5554416
```

So that's in my estimated ballpark.  It's a little slow to run (takes about
20 seconds on my system), but since the "real" input only takes about 1
second to run I don't think it's worth trying to optimize.

Doing a little experimentation to determine at what threshold this logic
would be required, it turns out that it would be for my input if the
threshold was set around 10,300. So it's actually potentially pretty
reasonable that with another set of input points this logic might be needed.
