# Day 2: Inventory Management System

<https://adventofcode.com/2018/day/2>

Again pretty trivial. I'll count the number of each letter in each string
using a hash indexed by the letter, so I just have to go through each
string.

Part 2 doesn't have much to do with part 1. For part 2, I want to find two
strings which are identical except for one letter. The simplest way to do it
is to compare every string to string #1, and if no match is found then
compare string #2 with strings #3-, etc. It might be interesting to try to
find a way to find the matches in a single pass.

```
$ perl day02.pl < input 
Part 1 result: 5456
Part 2 result: megsdlpulxvinkatfoyzxcbvq
```
