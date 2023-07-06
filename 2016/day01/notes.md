# Day 1: No Time for a Taxicab

[This problem](https://adventofcode.com/2016/day/1) is to take a list of
movement directions in the form 'L1, R2, L3', which means to turn left, go
forward 1 block, turn right, go forward 2 blocks, etc; and then find the
manhattan distance between the start and end point.

I like to represent the directions as an array like:
( [0,-1], [1,0], [0,1], [-1,0] ). North is direction 0, and to turn right
the direction is incremented by 1; to turn left it's decremented by 1
(wrapping around when necessary.)

Because of the format, all I have to do is find all instances of L, R, or a
number in order, and either turn or move forward.

```
$ perl day1.pl < input.txt 
Result: 353
```

Part 2 is to find the first location visited twice. To do that, after each
movement, I will store the resulting location in a hash, and when I detect a
collision that's the first location found twice.

Trying that with the example input (R8 R4 R4 R8), it doesn't work (doesn't
find any location visited twice.) I realize that we can't just count the
final location for a movement as a "visited location;" they want us to count
all squares walked through. The easy way to solve this is to just move by
taking one step at a time.

```
$ perl day1.pl < input.txt 
Part 1 result: 353
Part 2 result: 152
```
