# Day 2: I Was Told There Would Be No Math

The goal is to calculate how much wrapping paper is needed for the given
list of presents (rectangular prisms); the amount needed for each one is the
surface area + the area of the smallest (by area) side.

The input is in the form of one line per present, in the format LxWxH.

The correct result for the test input should be 58+43 = 101

```
$ perl day2.pl < input.txt 
part 1 result: 1588178
```

For part 2, also need to calculate the amount of ribbon needed, which is the
perimeter of the smallest (by perimeter) side, plus the volume of the box.

```
$ perl day2.pl < input.txt 
part 1 result: 1588178
part 2 result: 3783758
```
