# Day 6: Wait For It

<https://adventofcode.com/2023/day/6>

The distance that the boat will move is a function of the race time and the
amount of time the button is held. Specifically, `d = (t - x) * x`, where
`t` is the race time and `x` is the hold time.

We are trying to find all integer values for `x` where `d(x) > r`; `r` is
the record time. So rearranging that into standard form, we want
`-x^2 + tx - r > 0`. Using the quadratic formula, we want all integer values
between (exclusive):

```
(t ± sqrt(t^2 - 4r)) / 2
```

This took me embarrasingly long to figure out; it's been a really long time
since I've had to apply the quadrative formula.

For each race definition, we need to find the number of integers between
those values, and then the result for part 1 is the product of the number of
integers for each race.

```
$ perl day06.pl < input.txt 
Part 1 result: 252000
```

Part 2 is the same question, but just concatenting the digits of the input.
The idea is to make it harder to try all possible combinations (the naive
approach to part 1), but my part 1 solution should work fine.

```
$ perl day06.pl < input.txt 
Part 1 result: 252000
Part 2 result: 36992486
```
