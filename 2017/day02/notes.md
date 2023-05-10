# Day 2: Corruption Checksum

<https://adventofcode.com/2017/day/2>

The input for this problem is a bunch of rows of numbers; looks like the
number of numbers in each row varies. The first part of the problem is to
find the difference between the largest and smallest values in each row, and
then calculate the sum of those differences for the entire input.

For the second part, instead of that difference, we need to find two numbers
in each line that are evenly divisible, and find the sum of the results of
that division for the entire input. (There should only be one such set of
divisible numbers in each line.)

After writing my solution, I found that in the actual input data, the
columns have been aligned with tab characters, so I needed to adjust my code
to allow for any whitespace, not just a single space. Also it turns out that
there's the same number of elements in each row in the actual data, but that
just means my solution is maybe a bit more general than needed.

```
$ perl day2.pl < input.txt 
Part 1 result: 47136
Part 2 result: 250
```
