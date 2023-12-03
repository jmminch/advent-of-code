# Day 2: Cube Conundrum

<https://adventofcode.com/2023/day/2>

Part one is mostly string parsing. To solve part one, you have to find the
maximum number of each color listed on each line, and then determine which
ones don't exceed the maximums of 12 red, 13 green, or 14 blue. For this
part the "sets" don't actually matter, since all I care about is the
maximums.

Most likely I'll have to parse the sets for part 2, but I'll wait on that
until I know what part 2 will look like.

Turns out that there's no need to parse the sets for part 2 either; instead
we are looking for the maximum value for each color on the line, and then
multiplying those together.

```
$ perl day02.pl < input.txt 
Part 1 result: 2913
Part 2 result: 55593
```

This problem was far simpler than yesterday's.
