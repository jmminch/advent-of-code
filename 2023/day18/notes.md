# Day 18: Lavaduct Lagoon

<https://adventofcode.com/2023/day/18>

For this problem, all I need to do is follow the directions in the input to
form a loop, and then fill the interior.

It's not clear whether or not two trenches can touch each other (similar to
the pipe maze problem from a few days ago.) In the test input given they do
not, so I will assume that the same holds true for the actual input.

I can either fill the exterior with a known value and then know that
everything unfilled is in the interior, or I can find an interior point and
fill from there.

```
$ perl day18.pl < input 
Part 1 result: 40761
```

Now for part 2...for this part of the problem, they change the instructions
so that the distances are huge. For the test input the total area is just
shy of 1 trillion, so even if the actual input isn't any larger that will
be impractical to actually save a map of the whole thing.

It seems like "area of a polygon with known vertices" is probably a pretty
well-known problem, so I did some searching. Turns out that Green's theorum
is useful (which I'm not sure I've used since college, but after reading a
bit on it it became familiar.)
https://math.blogoverflow.com/2014/06/04/greens-theorem-and-area-of-polygons/
is a good source.

Pretty much what I want to find is:

```
A = sum((x.k+1 + x.k) * (y.k+1 - y.k) / 2)
```

Where the `x.k, y.k` pairs are the vertices.

After trying that (and getting the wrong answer) I realized that I have to
account for the size of the trenches as well. If I had a square that looked
like this:

```
##
##
```

Each dig length is 1, but it's really a square from `(0,0)` to `(2,2)`. I'll
solve that by adding in half the perimeter of the polygon.

```
$ perl day18.pl < input 
Part 1 result: 40761
Part 2 result: 106920098354636
```

After making these changes for part 2, this becomes much simpler.
