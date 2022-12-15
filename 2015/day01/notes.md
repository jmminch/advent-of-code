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
