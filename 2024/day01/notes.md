# Day 1: Historian Hysteria

<https://adventofcode.com/2024/day/1>

For the first part, we have two lists of numbers, and I need to sort both
lists and then compare the pairs in order.

```
$ perl day01.pl < input 
Part 1 result: 1646452
```

For part 2, we have to find out how often each number appears in list two. I
think the easiest way is to first process list two and generate a count of
how many times each number appears, and then go through list one and
calculate the "similarity score."

```
$ perl day01.pl < input 
Part 1 result: 1646452
Part 2 result: 23609874
```
