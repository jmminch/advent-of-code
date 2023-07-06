# Day 7: Internet Protocol Version 7

<https://adventofcode.com/2016/day/7>

For this problem, we have a list of input strings, which are lowercase
letters with some of them surrounded by square brackets. Although it's not
explicit, at least based on the example strings there is one substring in
each string enclosed in a set of square brackets.

Looking at the input data, there actually may be several strings enclosed in
square brackets, so I'll need to handle many of those.

For part one, I need to find how many strings contain a letter pattern ABBA
(where the A and B are any two *different* characters) outside of any square
brackets, but do not contain an ABBA pattern inside of square brackets.

To solve that, I can break the string into pieces, separating out
square-bracketed and non-square-bracketed strings, and check each one for
ABBA patterns (or lack of them.) To look for ABBA patterns, an easy way
would be to look for a regexes like `/(.)(.)\1\2/`, and then check that
`$1 ne $2`.

For part two, I need to find which strings have an ABA pattern in
non-square-bracketed strings, and also contain a corresponding BAB pattern
in square-bracketed strings. I can use a similar regex to find ABA patterns
in the non-square-bracketed strings, and then just search for the
corresponding BAB pattern using the index() function.

One problem I ran into (which they warned about in the problem description)
is if you have a string like "zazbz", both "zaz" and "zbz" need to be
considered ABA patterns. If I just do a global match looking for
`(.)(.)\1`, that will only match the first "zaz". To solve that, I had to
use a lookahead like: `/(?=((.)(.)\2))/`.

```
$ perl  day7.pl < input.txt 
Part 1 result: 110
Part 2 result: 363
```

After fixing that, part 1 is correct, but part 2 is too high, so I'm
apparently passing some of the strings for part 2 that I shouldn't be.
I did some more code inspection, and found a couple silly bugs (I was
looking for ABA strings within the full string instead of the non-bracketed
substrings); fixing those solved my problem.

```
$ perl day7.pl < input.txt 
Part 1 result: 110
Part 2 result: 242
```
