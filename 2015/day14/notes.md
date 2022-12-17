# Day 14: Reindeer Olympics

[This problem](https://adventofcode.com/2015/day/14) is to figure out how
far reindeer travel given that they travel at a particular speed for some
number of seconds, then stop for some number of seconds.

The example:

* Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
* Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.

So for Comet, one loop is 137 seconds, during which he flies 140 km. After
1000 seconds (the total time for the example), he flies:

floor(1000/137) = 7, \* 140km = 980km in the first 959 seconds
Then in the final 41 seconds he'll fly another 140 km, for a total of 1120
km.

```
$ perl day14.pl < input.txt 
part 1 result: 2696
```

For part 2, each second, the reindeer in the lead gets a point, and the
puzzle is to determine how many points the winning reindeer has when time is
up. While there's probably a clever solution, I don't see it, so I'll just
simulate the race for the total number of seconds since it's not very high
anyway.

```
$ perl day14.pl < input.txt 
part 1 result: 2696
part 2 result: 1084
```
