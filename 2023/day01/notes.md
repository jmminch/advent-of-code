# Day 1: Trebuchet?!

<https://adventofcode.com/2023/day/1>

New year!

The first problem is to take a list of strings, which have at least one
digit; find the first and last digit in the strings and concatenate them to
form a two-digit number, and then calculate the sum of those numbers.

I'll use perl regexes to get the first and last digits. Since the two could
be the same digit (if the string only has one digit), I can't really use a
single regex to get both. So the first digit is `/^[^\d]*(\d)/`, and the
last `/(\d)[^\d]*$/`.

For part two, some of the digits are spelled with letters (like "one"). The
simple way to solve this is to to string replacement of the spelled-out
digits with numerical ones. However, there's a trick to it. If we have a
string like this: `eightwo`---how does that get handled? Is it `8wo` turning
into `88`? Or should it be `82`? The test data doesn't have a string of that
form. The input data has the following, though:

`seven2threeeightwomg`

That could legitimately be decoded to `72` or `78` depending on how the
instructions are interpreted.

Thinking about it, the simple approach of first replacing all instances of
"one" with '1', then all instances of "two" with '2', etc. doesn't work.
`eightwothree` (from the test data) would turn into `eigh23`, which is
wrong. So instead I will go through the string character-by-character from
the beginning, looking at whether there is a digit (numerical or spelled) at
that character. Then I'll reverse the string and do the same to find the
last digit. This corresponds to the approach that decodes the above as `72`.

```
$ perl day01.pl < input.txt 
Part 1 result: 53651
Part 2 result: 53894
```

Interesting that this problem is really significantly more difficult than
the early problems from years past.

