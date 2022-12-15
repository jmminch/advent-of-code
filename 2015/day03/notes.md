# Day 3: Perfectly Spherical Houses in a Vacuum

Similar to day 1, each character of the input indicates a movement, this
time in 2 dimensions (n,s,e,w represented by ^,v,>,<).  The question is to
figure out how many locations were visited, including the starting location.

For this type of problem I like to represent x,y as a single integer in the
form of 0xYYYYXXXX; then directional movement becomes simple as you can just
add/subtract a single number. The start point will be at 0x8000, 0x8000, in
the middle.

A perl hash is the easy way to track which locations you've visited.

```
$ perl day3.pl < input.txt 
part 1 result: 2081
```

For part 2, we've got to track the locations of 2 Santas; one of which
follows the directions for characters 1, 3, ... and the other for characters
2, 4, ....  Need to keep track of 2 locations instead of 1 and flip between
them each time.

```
$ perl day3.pl < input.txt 
part 1 result: 2081
part 2 result: 2342
```

...and something's wrong; 2342 is too high. Trying a couple of the provided
examples, I get a wrong answer for "^>v<"; should be 3 but my program
returns 4.
