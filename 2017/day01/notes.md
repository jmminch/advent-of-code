# Day 1: Inverse Captcha

<https://adventofcode.com/2017/day/1>

This problem asks you to process a string of digits, and calculate the sum
of all digits in the string that match the next digit in the list. The
string should be treated circularly, so for the last digit we need to check
the first digit in the list.

The second part of the problem is to look at the digit halfway around the
list.

So the best way to do this is to have a function that calculates the sum
based on the digits that are `n` digits away from the current one; part 1
will set n=1, and part 2 will set n=(length / 2).

```
$ perl  day1.pl < input.txt 
Part 1 result: 1136
Part 2 result: 1092
```
