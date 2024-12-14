# Day 13: Claw Contraption

<https://adventofcode.com/2024/day/13#part2>

For my first part solution (rank 629), I followed the method that the
problem was hinting at: try values 0..99 for both A and B and figure out
which combination works and has the minimum cost.

Obviously that's out for part 2. I decided to look at the problem
geometrically. If you plot the prize position on a graph, and then draw a
line to where the button presses of A leave the arm, and then another line
for the button presses of B, it becomes obvious that if the slope of line A
and line B are different, then there can only be one possible solution to
the number of presses for each button; whether there is a possible solution
will depend on whether the "number of presses" is a non-negative integer or
not.

One side of the triangle is the line starting at the origin, with slope
`Ay/Ax`; the other is the line that passes through the prize point with
slope `By/Bx`. We can create equations for those lines and then set the
y-values equal to determine the x-value where they cross; at which point
it's then easy to determine the number of presses for A and B that result in
ending at the prize point.

At that point, the only trick is to figure out whether the number of presses
is a non-negative integer. Because the prize numbers for part 2 are so big,
floating point error makes it so that I can't just check whether my results
are integers. So instead what I did was check the 3 integers (for both A and
B) around the solution found and verify via multiplication whether the
solution is valid.

This works, and it's fast.

I did ignore one cases that could have been a problem. If the slopes for all
three lines are the same, then this method breaks down. This likely could
only happen in part 2 if the slope was 1 for all three, as because of the
way that the problem is written the slope for the prize location has to be
very close to 1. In any case, it does not seem to have been an issue in my
input.

```
$ perl day13.pl input 
Part 1 result: 40069
Part 2 result: 71493195288102
```
