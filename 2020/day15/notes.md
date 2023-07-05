# Day 15: Rambunctious Recitation

For [this problem](https://adventofcode.com/2020/day/15), we have to
generate a sequence of numbers based on the following rules after starting
with a given sequence:

* if the previous number had never been used before, then the next number in
  the sequence is 0
* if the previous number had been used before, then the next number in the
  sequence is how far apart the two uses of those numbers was.

To do this, I'll keep a hash of the number to the most recent turn it was
used. When generating a new number, I'll record how many turns it has been
since last seeing that number before recording the new turn number in the
hash.

```
$ perl day15.pl 
part 1 result: 412
part 2 result: 243
```
