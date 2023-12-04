# Day 4: Scratchcards

<https://adventofcode.com/2023/day/4>

Part one is pretty easy. Parse each line to extract the lists of "winning
numbers" and "numbers you have;" figure out how many of the "numbers you
have" are in the "winning numbers" list, and then the score is `2^(n-1)`
where `n` is the number of "numbers you have" in the "winning numbers" list.

```
$ perl  day04.pl < input.txt 
Part 1 result: 24542
```

For part 2, the matching logic is the same, but scoring is different. This
looks like a problem looking for a recursive solution, since the question of
how many points one card is worth depends on how much others are worth. The
'Memoize' module should be helpful here.

```
$ perl day04.pl < input.txt 
Part 1 result: 24542
Part 2 result: 8736438
```

Just for fun, I tried it without using Memoize to see what the difference
is; without that enabled it took about 3 seconds to complete, while with it
enabled it took about 20 milliseconds.
