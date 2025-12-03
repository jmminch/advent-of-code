# Day 21: Keypad Conundrum

<https://adventofcode.com/2024/day/21>

This problem is giving me a little trouble.

It's fairly easy to go one level down: given what button I need to push on
keypad N, figure out which buttons to push on keypad N+1 to do that. The
most efficient method in terms of button pushes on keypad N+1 will be to
move the arm in one direction, then the perpendicular direction, and then
hit the 'A' button.

There may be two different possibilities for how to achieve that (horizontal
first, or vertical first); although one of those may cause the arm to go
over an empty keypad space which isn't allowed, and if the target is a
straight line from the current location, then there's only one possibility.

The problem is whether one of the two possibilities might be more efficient
when you daisy-chain the keypads together. It seems like it might not
matter, but I'm not positive.

However, for a first attempt I'm going to try it assuming that it doesn't
matter. So from the desired button presses, I'll create the string of button
presses on the attached keypad that will generate that; and then repeat that
twice more.

It turns out that the two possibilities don't turn out the same. So I'll
need to try each of the possibilities to determine which is best.

I finally got my solution working, although this was by far the most
difficult problem of the year so far for me. Eventually I came up with a
recursive solution with memoization that solves both parts.

One of the important things for part 2 is to realize that I don't actually
need to build and store the full strings of keypad movements; instead I just
have to track the lengths.

```
$ perl day21.pl input 
Part 1 result: 137870
Part 2 result: 170279148659464
```
