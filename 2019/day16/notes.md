# Day 16: Flawed Frequency Transmission

<https://adventofcode.com/2019/day/16>

In December the last few years, I often go back to older problems that I
didn't solve. In 2019 it looks like I quit on day 16, so I'm trying that
now.

It looks like the process described in this problem is simple, but for part
2 we need to apply it to 6.5 million digits, which could take a while.

Digit 0 of the output of the algorithm would be the last digit of:

```
i[0] - i[2] + i[4] - i[6] ...
```

Digit 1 is:

```
i[1] + i[2] - i[5] - i[6] + i[9] + i[10] ...
```


Digit 2:

```
i[2] + i[3] + i[4] - i[8] - i[9] - i[10] ...
```

It seems like there's probably a pattern in how the digits evolve, but
keeping just the last digit makes things more difficult.

I thought of defining the problem recursively, but if I'm using memoization
like in previous problems, I would end up just storing the entire set of
entries in the cache anyway, so I don't think that helps.

Since I can't see how to solve this nicely, I'm going to implement it as
written first and see how far I get.

```
$ time perl day16.pl input 
Part 1 result: 30369587

real	0m0.953s
user	0m0.953s
sys	0m0.000s
```

953 milliseconds for the input. I think that part 2 will take 10,000x as
long, so something like 3 hours if I just let it run.

Looking at the examples for part 2, the first starts `0303673`, so that is
the offset of the start of the output. Digit 303,673 would be the last digit
of:

```
sum(digits 303673..607345) - sum(digits 911019..1214692) + ...
```

The sums are big, but because the input data is repeated over and over, most
of the terms should cancel each other out. 

After some experimentation, I found an interesting property -- at some
point, the digits of the resulting transform repeat; and the repeated digits
are the same regardless of how many times I repeated the input string.
Intuitively, this does make some sense.

That means, even if I can't figure out how to solve this explicitly, I don't
need to generate the entire string for each step. I just need to generate
enough to figure out the beginning and the repeating string, and then I can
move to the next step.

While the idea seems sound, after trying it, it looks like the size of the
loop grows significantly with each step, causing the algorithm to take too
long.

I decided to cave in and look at the subreddit for a hint. In there it was
pointed out that for any offset that is greater than half the size of the
input string, the output digit is the sum of all digits starting at that
offset, to the end of the string. The inputs are designed so that the offset
we'll be looking at is past that point.

Trying to work it out past that point, we can write:

```
O1[L] = I1[L]
O1[N] = sum(I[N]...I[L]) = I[N] + O1[N+1]
O2[N] = sum(O1[N]...O1[L] = O1[N] + O2[N+1]
...
```

The recursive form of this blew up (out of stack space), so I rewrote the
logic in C and have it simply fully generate all the digits starting at the
offset of interest until the end. In the end, this only takes 129
milliseconds:

```
$ time ./day16 < input 
Part 2 result: 27683551

real	0m0.129s
user	0m0.117s
sys	0m0.012s
```
