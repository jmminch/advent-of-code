# Day 25: Full of Hot Air

[This](https://adventofcode.com/2022/day/25) is the last day for 2022!

The problem this time is to convert numbers to and from a format which is
base 5, the five digits representing values from -2 to 2.

Converting from this format to decimal is pretty easy; just go through each
place value multiply the value of the digit by the appropriate power of 5,
pretty much like any other base conversion.

I found it harder to figure out how to convert from decimal to this format,
but what I came up with was to take a number in decimal, and add 222...(b5)
to it, and then convert it to base 5 using normal digits. After I do that,
then I shift each digit down by 2 (so '4' becomes '2', '0' becomes '=',
etc.), which effectively subtracts 222...(b5) from the number, leaving the
original number in SNAFU digits.

```
$ perl day25.pl input.txt 
sum: 37503495108131
encoded: 20-1-0=-2=-2220=0011
```
