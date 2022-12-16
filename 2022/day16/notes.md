# Day 16: Proboscidea Volcanium

More searching for an optimal path. We've got a graph of nodes (valves) and
connections; each minute we can open a valve (releasing pressure for the
rest of the 30 minute time) or move along a tunnel to another valve. The
object is to release maximum amount of pressure within the time constraints.

The result for the test data should be 1651.


This problem looks ideal for depth-first processing; since the maximum path
length is only 30 it shouldn't grow out of control. Some simple pruning we
could do:
  1 - don't backtrack if you haven't opened a valve, since that's a
      pointless waste of time.
  2 - don't try to open valves with rate=0
  3 - if all nonzero valves are open, just wait for the end


This problem can be solved with an approach similar to 2016 day 24 (which I
happen to remember since I recently did it.) The solution should be to take
the shortest path to a valve, open it, and repeat. Therefore, if I find all
the permutations of the valves with non-zero flow, I can find the best
result by calculating the result of visiting the valves in those orders.

This is similar enough to 2016 day 24 that I will start with that code and
modify it to suit this problem.

Trying out my solution, it's taking too long for the input data; the number
of "interesting" valves is too high (15), so it needs to check 15!
permutations, which is over 1e12.  A fairly easy optimization is to stop
checking later permutations if the earlier items already take more than the
30 minute limit.

It still takes a little while to run, but not too bad.

```
part 1 result: 2114

real	0m12.977s
user	0m10.551s
sys	0m2.321s
```

For part 2, we've got to have two entities moving in parallel (you and an
elephant.) The time limit is reduced to 26 minutes. At first I thought that
the calculation would require simulating the state each minute, but then
realized that if I have the "self" and "elephant" paths, I can just
calculate the pressure release due to each of them and add them together.

So if I iterate through all combinations of assignments of valves to the
self and elephant paths, and then for each one calculate the maximum
pressure for each as in part 1, the sum is the maximum total pressure for
that assignment of valves.

This approach is really slow, but I didn't come up with a way to improve it
in less than the 15 minutes it took to run.

```
$ time perl day24.pl < input.txt 
part 1 result: 2114
part 2 result: 2666

real	15m14.415s
user	15m14.414s
sys	0m0.000s
```
