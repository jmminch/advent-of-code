# Day 1: Not Quite Lisp

Starting with a very easy problem.

The input is a string of parentheses; an open parenthesis causes a counter
(elevator floor) to increment and a close parenthesis causes the counter to
decrement.  The counter starts at zero.

The input is a single line.  Simplest solution is to just iterate through
each char and increment/decrement the counter appropriately.

```
$ perl day1-1.pl < input.txt 
part 1 result: 232
```

Part 2: find the position (1-based!) of the character that first results in
the counter reaching -1.

```
$ perl day1.pl < input.txt 
part 1 result: 232
part 2 result: 1783
```
