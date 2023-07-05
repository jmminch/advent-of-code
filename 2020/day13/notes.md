# Day 13: Shuttle Search

[This problem](https://adventofcode.com/2020/day/13) looks like more modular
arithmetic.

You have a bunch of buses that depart the station on a regular schedule;
each route departs with a different interval. The first part is, given a
start time (s), determine how long you'll have to wait (t) for the next bus
to depart.

So for each bus route, with interval i, you want to find t such that
(s + t) % i == 0. That means (s % i) + t == i, or t = i - (s % i). Just run
through all the bus IDs to find the minimum value for t.

For part two, you're looking for a time, t, where the first bus in the list
departs at time=t, the second bus in the list departs at time=t+1, etc. They
give the hint that a naive linear search isn't going to work.

We want to find t such that:
```
t % i0 == 0
(t + 1) % i1 == 0
```
etc.

I'm sure that there's a simple approach with modular arithmetic, but I'm not
seeing it. I think this should work, though:

1. Start at t=0, and step forward in intervals of i0 until you find a time t
   where `(t + 1) % i1 == 0`. Call this t `x1`.
2. Calculate a new interval, x1, which is lcm(i0, i1)
3. Now step forward in intervals of x1 until you find a time t where
   `(t + 2) % i2 == 0`. 
4. Calculate a new interval which is lcm(x1, i2)
3. Keep going until you reach the end of the list.

```
$ perl day13.pl < input.txt 
part 1 result: 5257
part 2 result: 538703333547789
```
