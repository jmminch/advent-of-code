# Day 16: Dragon Checksum

<https://adventofcode.com/2016/day/16>

It's not obvious to me how to solve this problem without generating all the
data, although I suspect it's possible.

I tried two methods of stepping through the string two characters at a time;
using both `while(/../g)` and a loop doing `substr()` each time. The substr
version was quicker, albeit by only about 10%.

```
$ time perl day16.pl 
Part 1 result: 10101001010100001
Part 2 result: 10100001110101001

real	0m14.913s
user	0m13.680s
sys	0m1.162s
```
