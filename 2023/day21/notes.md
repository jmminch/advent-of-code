# Day 21: Step Counter

<https://adventofcode.com/2023/day/21>

Part 1 is just doing a search to find all squares that can be reached in 64
steps from the starting point. The main thing to notice is that all squares
with an *even* distance (<=64) from the starting point can also be reached
in 64 steps, so I don't have to keep recalculating distances for squares
that I've already visited.

For the reason why that works, imagine the map as a chessboard: each step
in a cardinal direction will take you to a square of the opposite color. So
after 64 steps, you will end up on a square of the same color that you
started--the squares reachable with even numbers of steps. You can reduce
the steps by 2 at the beginning of a path by taking one step away and back,
so there exists a 64-step path to any of those squares.

I'll just track the map of distances from the starting point, and then when
I've filled it out to 64 steps count how many of them have even distances.


Part 2 seems rough. It's not going to be possible to simulate all those
steps since the map size will grow with the square of the number of steps.

Thinking about it, I expect that as time increases, if you took a long view,
the map of visited squares would be roughly diamond-shaped, with all the
reachable squares in the center copies of the layout having been already
reached, and the border evolving. I'd expect a pattern in how the border
squares get filled up. So maybe this problem could be as simple as finding
that pattern. That's going to be a little trickier than just finding some
repeating value, though, because (at least I think) it's going to be based
on the square of the steps.

What I'm going to try first is to simulate a couple thousand steps, and for
each step print out the number of squares at that distance, and the *maximum
x coordinate reached*. The purpose of looking at the max X coordinate is to
help me determine how long any pattern takes to repeat (we cover another
copy of the map every "n" steps, I'm hoping.)

Even running a couple thousand steps takes a while with my code. My input is
a 131x131 square, so I'm going to look at the steps when we reach X=131,
X=262, etc.

After some optimization (no longer storing the entire map; just a list of
cells visited in the last couple steps) I can reasonably simulate the 5000
steps that we have given data for the test input. Looking at that, I do
start seeing a pattern:

```
Step 4840   MaxX 4840   Squares 8809

Step 4851   MaxX 4851   Squares 8829

Step 4862   MaxX 4862   Squares 8849

Step 4873   MaxX 4873   Squares 8869
```

So we're increasing the number of squares per step linearly, every 11 steps.

If the number of squares for each individual step increases linearly, then
so will the total number of squares added for the entire 131-square loop.
Since we will be adding in only the squares reachable during odd-numbered
steps, let's try printing the sums of the squares added during each loop,
appropriately calculating which step to start at to end at step 26501365.

```
$ perl day21-pt3.pl 2000 < input 
Step 65   Squares 4581  Delta 4581
Step 327   Squares 122363  Delta 117782
Step 589   Squares 397911  Delta 275548
Step 851   Squares 831225  Delta 433314
Step 1113   Squares 1422305  Delta 591080
Step 1375   Squares 2171151  Delta 748846
Step 1637   Squares 3077763  Delta 906612
Step 1899   Squares 4142141  Delta 1064378
```

The delta values are increasing linearly (by 157766 per loop of 262 steps),
after the "startup" of the first couple loops. So the number of squares
`s(n) = s(n-1) + (s(n-1) - s(n-2) + 157766)`.

So I'm trying to just get this solved, and then make it "nice" later. It
shouldn't be too hard to figure that out explicitly, but instead I just
defined that function in day21-hack1.pl. The answer should be s(101150).

```
$ perl day21-hack1.pl 
807081347405931
```

The site says my answer is too high, however. So the question is if my logic
is wrong and I don't have the right pattern, or if my logic is right but my
implementation is giving me the wrong values.

Found an error while doing the accumulation; next calculations:

```
$ perl day21-pt3.pl < input 
Step 65   Squares 3911  Delta 3911
Step 327   Squares 96435  Delta 92524
Step 589   Squares 312055  Delta 215620
Step 851   Squares 650771  Delta 338716
Step 1113   Squares 1112583  Delta 461812
Step 1375   Squares 1697491  Delta 584908
Step 1637   Squares 2405495  Delta 708004
Step 1899   Squares 3236595  Delta 831100
```

So fixing my relationship:

```
$ perl day21-hack1.pl 
629720570456311
```

That was the right answer.

I'll try to fix up my code some other time.
