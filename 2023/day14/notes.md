# Day 14: Parabolic Reflector Dish

<https://adventofcode.com/2023/day/14>

The logic for moving the rocks when the board is tilted is to start at the
edge that the rocks are moving towards and move the rocks as far as they can
go towards that edge. So for part 1, start with the rocks in the top row.

My guess is that for part 2 I'll be applying this transformation in multiple
directions (possibly to find out how to generate some pattern) although
since I've been surprised a few times by part 2 I don't want to expend too
much effort on making things general. However, I will create a function that
takes the input map and a direction and spits out the result.

I was right about part 2; I will need to do the "tilt" operation in all four
directions, one after each other; and then determine the result after
repeating it 1,000,000,000 times.

My guess is that the "load" value will probably stabilize into a single
value that repeats after each cycle, so if I look for the load value to
repeat itself several times I can call that the solution.

It turns out that my guess is wrong -- it looks like we end up in a pattern
of repeating load values, but it's not a single value. The test pattern ends
up repeating the values `69, 69, 65, 64, 65, 63, 68` over and over.

In the interests of solving this quickly, I found the pattern for my input
manually:

```
419 102507
420 102504
421 102497
422 102507
423 102512
424 102509
425 102505
426 102500
427 102498
```

The first value is the cycle number; second value is the load value. The
load values repeat every 9 cycles. `(1e9 - 419) % 9 = 5`, so the result
should be the same as in cycle 424; 102509.

I will attack finding the cycle programmatically later.

My usual method to find a cycle in values like this is to have a hash, with
the index based on the state (in this case, the grid), and the values being
the step number when that state was encountered. So after a step, if the
current state already exists in the hash, then the cycle length is the
difference between the current step number and the one stored in the hash.

There's a couple things I could used to index the state. The "load value"
isn't good enough, since we can see from the data above that we frequently
hit the same load values multiple times during a cycle (since there are
multiple load values that correspond to the same state.) One thing that
should work would be to remember the last n load values (say, twenty or so)
and use that as the state; the chances of that many load values repeating
for different states are very low.

Another possibility would be to convert the map into a string and use that
as the key; or perhaps a hash of that string. I could map it to a bit string
where the `O` blocks are 1 and the other cells 0; since the input map is
100x100 that would result in 10,000 bits or 1,250 bytes. That's pretty long,
but it looks like I only need to store a few hundred at the most. This is
the option I'm going to try.

This detects the cycle in the input starting with cycle 101.

```
$ perl day14.pl < input 
Part 1 result: 109424
Part 2 result: 102509

real	0m1.821s
user	0m1.770s
sys	0m0.049s
```

One thing that bothered me about my solution is the "tilt" function
essentially repeats its logic four times, one for each direction.
I'm really opposed to having code that is largely duplicated multiple times,
as it makes maintenance of that code much more difficult.

I had thought about doing a sequence of rotating the board so that the
direction that the boulders are moving is at the top, moving all the
boulders towards the top, and then rotating it back. That would simplify the
code, but it adds a bunch of extra processing to the problem which would
make it much slower, so that doesn't seem like a good plan.

Another way that would reduce the impact is to use the fact that a "spin
cycle" can be implemented by moving all boulders towards the top and then
rotating clockwise by 90°, repeating that procedure four times. At least
that would eliminate half of the rotation steps.

However, as I considered that, I realized that I could instead have a
function that maps the coordinates used by the tilt function into a
different coordinate system based on the rotation. So we would have:

```
dir=0 (up)    x => x, y => y
dir=1 (left)  x => ymax - y, y => x
dir=2 (down)  x => xmax - x, y => ymax - y
dir=3 (right) x => y, y => xmax - x
```

So I can write the tilt function logic as if it's always moving boulders up,
but write a mapX and mapY function to convert into the correct coordinate
system.

At the same time I will change to code to modify the map in-place rather
than cloning it every time, which should get me an extra speedup--hopefully
enough to offset the extra work in doing the coordinate mapping, which
should be pretty fast but is still going to represent a slowdown.

After making the change, unfortunately performance is significantly worse:

```
$ time perl day14-2.pl < input
Part 1 result: 109424
Part 2 result: 102509

real	0m4.248s
user	0m4.229s
sys	0m0.012s
```
