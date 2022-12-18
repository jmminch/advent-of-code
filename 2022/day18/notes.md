# Day 18: Boiling Boulders

In [this problem](https://adventofcode.com/2022/day/18), we take a 3D object
(formed from 1-unit cubes) and have to find the surface area; which can be
found by looking at each cube and finding all the faces that aren't
connected to another cube.

If I store the cube locations as keys in a hash, then I can quickly look up
whether or not there is a cube at the adjacent locations.

```
$ perl day18.pl < input.txt 
part 1 result: 3550
```

For part 2, I need to exclude any contained areas (holes in the middle of
the structure.)  To do that, I can use a flood-fill type algorithm to fill
all the exterior, and then anything left unfilled can be filled with rock
before recalculating the surface area.

```
$ perl day18.pl < input.txt 
part 1 result: 3550
part 2 result: 2028
```
