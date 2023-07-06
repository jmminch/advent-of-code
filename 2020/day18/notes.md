# Day 18: Operation Order

The [problem](https://adventofcode.com/2020/day/18) this time is to write a
program to evaluate arithmetic expressions, but with
slightly-different-than-usual rules: for part 1, parentheses are used as
normal, but both addition and multiplication have the same precedence and
are evaluated from left-to-right.

For part 2, addition has higher precedence than multiplication (so opposite
standard rules).

There's a couple ways to approach this. I think the easiest way is probably
to look repeatedly for parenthesized expressions and replace them with their
numerical equivalent; to evaluate an expression with no parentheses I just
need to look repeatedly for the first operation on two numbers and replace
it with the equivalent.

One thing I discovered while debugging this one was that the perl `@+` array
contains the offset of the character *after* the end of the match (which
really isn't entirely clear in the perlvar manpage -- it says "$+[0] is the
offset into the string of the end of the entire match;" I assumed that meant
the offset of the last character in the match.)

The other approach I considered was to build up a tree representing the
expression, which probably would have been interesting from an algorithmic
point of view, but would have been more difficult than just using string
manipulation in perl.

```
$ perl day18.pl < input.txt 
part 1 result: 6923486965641
part 2 result: 70722650566361
```
