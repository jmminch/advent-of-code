# Day 3: Lobby

<https://adventofcode.com/2025/day/3>

This problem seems to want to trick you into trying every combination of
digits on each line, which isn't going to be the best way to go about part
1, at least. For part 1, we want to find the maximum number formed by two
digits (in order) from the string. The first digit would be the maximum
digit in the string, leaving out the last digit of the string. The last
digit would be the maximum digit occurring after the first occurance of the
first digit.

For part 2, the logic is basically the same, but we need to find 12-digit
numbers instead. So to find the first digit of the largest n-digit number in
a string of digits, we want to find the first instance of the largest digit
in the string, not considering the last n-1 digits. Then we repeat the
process to find the largest n-1 digit number in the set of digits following
the found digit, etc.

```
$ perl day03.pl < input 
Part 1 result: 17343
Part 2 result: 172664333119298
```
