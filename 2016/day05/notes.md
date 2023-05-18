# Day 5: How About a Nice Game of Chess?

[This problem](https://adventofcode.com/2016/day/5) relies on searching
for an MD5 hash based on a "door ID" that starts with five hexadecimal
zeroes. For the most part, it's pretty simple as long as you use a library
function to calculate the MD5 hash. Fortunately perl has the useful
Digest::MD5 module.

Looking for how to use it, I looked back at my old AoC entries, finding that
I used it in 2015 day 4. That problem is actually very similar to this one,
although for that one we're only looking for the first hash starting with 5
zeroes, rather than 8 of them to find an 8-character password.

Part 2 changes how the hashes are interpreted; the sixth character of the
hash is the position within the password (0-7), and the seventh is the
password character at that position. Hashes that have an invalid character
in position 6 (8-f) or a repeated position should be ignored.

While I was thinking that this might turn out to be slow, it doesn't really
take that long.

```
$ time perl day05.pl 
Part 1 result: 801b56a7
Part 2 result: 424a0197

real	0m7.336s
user	0m7.332s
sys	0m0.004s
```
