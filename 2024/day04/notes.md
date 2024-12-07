# Day 4: Ceres Search

<https://adventofcode.com/2024/day/4>

I can think of two obvious ways to solve this. The first is to iterate
through each square on the board, and check whether the word XMAS appears in
any of the 8 possible directions starting at that square.

The second is to split the board into lines and find out how many times XMAS
appears in each line; to do that I'd need a way to generate all vertical,
horizontal, and diagonal lines.

I think the first will be a little simpler to implement, so I'll do that.

For part 2, I can't really reuse much of the part 1 code, but a similar
technique should work. For part 2, it makes the most sense to look at each
square to determine if it's the center of an 'X-MAS' by:

1. The square is an `A` (required for this to be the center of an X-MAS)
2. The square diagonally up and left is an `M` and the square diagonally right
   and down is an `S`; *or* vice-versa
3. Same for the squares diagonally up/right and down/left.

```
$ ./day04.pl input 
Part 1 result: 2427
Part 1 result: 1900
```
