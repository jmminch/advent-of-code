# Day 3: Gear Ratios

<https://adventofcode.com/2023/day/3>

The main thing that makes this problem a little tricky is that the numbers
in the grid take up multiple squares, so you can't just look at the
neighbors for one square to identify whether there is a symbol next to a
number.

My assumption is that numbers don't touch (so there's no ambiguity about
whether a digit counts as a "symbol.")

My approach will be:

1. Search through the grid for the first digit in a number (a square
   containing a digit, where the square to the left does not contain a
   digit.) Set the value of the number being processed to zero.
2. Multiply the value by ten and add the current digit.
3. If we haven't already found an adjacent symbol, check all neighboring
   squares for a symbol. If one is found, remember that fact.
4. If the next square to the right is also a digit, move to the next square
   and return to step 2.
5. Otherwise, a number is complete. If a neighboring symbol was found, then
   add the number to the part 1 answer.

Again, this is a pretty tough problem for this early in the month.

```
$ perl day03.pl < input.txt 
Part 1 result: 525911
```

For part 2, I need to find the numbers that are adjacent to all "gears" (`*`
symbols.) The code I've written isn't well-suited to solve that directly,
but since I'm already finding symbols next to each number, what I will do is
keep track of gears whenever I find a `*` symbol, and then add the number I
find to a list associated with that gear. Then I can process the list of
gears at the end to solve part 2.

I get the right answer with my solution for the test input, but the site
says my result is too low for the actual input.

```
$ perl day03.pl < input.txt 
Part 1 result: 525911
Part 2 result: 75476845
```

Since it's too low, that suggests I'm missing at least one valid gear.

To figure out what's going wrong, I'm going to change the code to remove all
found gears from the input, and print it back out. Then I can look at the
result manually to see if I can identify which gear isn't being correctly
counted.

While I was writing that, I found the mistake---a silly error. When
recording the positions of found gears in a hash, I am indexing the hash
with a string version of the coordinates. I was intending to use "$y,$x",
but accidentally used simply "$y$x" without a comma. That resulted in some
unique locations mapping to the same index---for instance, (12,1) would be
the same as (1,21). After fixing that I get the right result.
