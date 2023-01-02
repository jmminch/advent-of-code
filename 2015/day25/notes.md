# Day 25: Let It Snow

For [this problem](https://adventofcode.com/2015/day/25), it looks like an
exercise in modular arithmetic.

To find the "code index" for the code in row i, column j:

The starting index numbers in row i are 1, 2, 4, 7, etc. So that would be 1 +
sum(1 to (i - 1)).

Then the numbers in that row are (x, x + (i + 1), x + (i + 1) + (i + 2),
etc.) So if we want column j in that row, we want x + sum(i .. i+j-1) - i.

So the index number at i,j is 1 + sum(1 to i - 1) + sum(i+1 to i+j-1), or
1 + sum(1 to i+j-1) - i.

The puzzle input is to find the code at 2947, 3029. So the code index for
that is 1 + sum(1 to 5975) - 2947 = 1 + 17853300 - 2947 = 17850354.

Then, the codes are calculated by taking a seed value, 20151125, and then
for each step multiply it by 252533 and then get the remainder mod 33554393.
There's probably a quick mathematical way to do that, but it's easier to just
write a program to do it, since it's only 17 million steps.

```
$ perl day25.pl 
part 1 result: 19980801
```
