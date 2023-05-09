# Day 4: Security Through Obscurity

[Today's problem](https://adventofcode.com/2016/day/4) is string processing.
There are "room names" in the form \<name\>-\<numerical id\>\[checksum\],
where a valid "checksum" is the five most common letters in the name, most
common first, with ties broken alphabetically.

The first part is to identify which room names have valid checksums, so I'll
need a function that generates the checksums for the room names.

Decryption is done by a rotation cipher of the letters in the room name.
Part 2 is to decrypt the list of room names and find the one "where North
Pole objects are stored." Whatever that means -- I guess I'll need to print
out the list and identify it manually.

Running my program, it gives the right result for part 1:

```
$ perl day04.pl < input.txt
 (skip a bunch)
Part 1 result: 185371
```

There's 337 rooms in that list, but looking for "north":

```
$ perl day04.pl < input.txt | grep north
northpole object storage - 984
```

That's the result for part 2.
