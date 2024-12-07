# Day 6: Guard Gallivant

<https://adventofcode.com/2024/day/6>

Part 1 has a guard moving around a map by a fairly simple set of rules; the
main thing is that I have to keep track of all visited squares (a hash of
visited squares will work here.)

For part 2, the movement logic is the same, but I need the ability to find a
loop. All I have to do is keep track of the location and direction at each
step, and if there is a repetition, then we know that a loop has been found.

I'll pull the movement logic into a subroutine that determines whether or
not the loop ends, and returns that as well as the number of squares
visited. So for part 2, I just need to try adding an obstacle at each point
and see if the loop ends.

As an optimization, every possible position for a new obstacle that would
create a loop must by necessity be on the original path. So if I could
return the list of visited squares in part 1, then I could check only those
for part 2.

```
$ time perl day06.pl input 
Part 1 result: 4819
Part 2 result: 1796

real	0m11.572s
user	0m11.567s
sys	0m0.004s
```

Slow, but it does work.
