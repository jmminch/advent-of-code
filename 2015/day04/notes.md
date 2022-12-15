# Day 4: The Ideal Stocking Stuffer

The puzzle is to find an input, which is a key concatenated with a decimal
integer (> 0), that has an MD5 hash that starts with five zeroes.  We want
to find the lowest integer that, combined with the puzzle input, has that
result.

Puzzles involving MD5 hashes seem to have been common in earlier years as
I've gone backwards, they've gotten away from that in later years. So far
I've just used the perl Digest::MD5 module rather than trying to implement
it myself.

Easiest way is to simply start from 1 and calculate MD5 sums until finding
one that starts with 5 zeroes.

The puzzle input is given to day4.pl as a parameter rather than being
received from stdin.

test data provided:
abcdef should result in 609043
pqrstuv => 1048970

```
$ perl day4.pl 
part 1 result: 117946
```

Part 2 is just to do the same, looking for six zeroes instead of five.

```
$ perl day4.pl ckczppom
part 1 result: 117946
part 2 result: 3938038
```
