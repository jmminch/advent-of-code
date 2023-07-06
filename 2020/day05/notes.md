# Day 5: Binary Boarding

[Today's problem](https://adventofcode.com/2020/day/5) deals with
identifying a spot on a grid (airline seats) using "binary space
partitioning," which I imagine is probably a reasonably well-studied
mathematical concept, although I'm not familiar with it---the characters in
the identifier repeatedly split the remaining options into 2 until you find
the desired location.

Part 1 is to decode all the given identfiers, work out the row/column, and
then find the one with the highest seat id (`row*8 + column`) in the list.
Part 2 is to then find a 1-seat "gap" in the seat ID list.

Thinking about this, it's easier than I thought. Essentially these
identifiers are just binary values, starting with the MSB. It just wasn't
clear to me because of how the problem was described.

```
$ perl day5.pl < input.txt 
part 1 result: 987
part 2 result: 603
```
