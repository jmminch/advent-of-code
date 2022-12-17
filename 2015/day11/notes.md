# Day 11: Corporate Policy

The puzzle this time is to take a starting 8-letter password, and
"increment" it until it is valid according to a few rules. To increment the
password, you treat it like a number, with the letters digits in base 26.

So two obvious ways to implement the increment -- either increase the last
letter by one, and then handle the cascade effect if the letters roll over;
or convert the string to a number, and then repeatedly increment it,
converting each step back to a string to perform the checks.

The checks are the following:

1. Passwords must include one increasing straight of at least three letters,
   like abc, bcd, cde, and so on, up to xyz. They cannot skip letters; abd
   doesn't count.
2. Passwords may not contain the letters i, o, or l, as these letters can be
   mistaken for other characters and are therefore confusing.
3. Passwords must contain at least two different, non-overlapping pairs of
   letters, like aa, bb, or zz.

It seems easiest to convert the string to a list of numbers (0-25), and then
handle the increment and checks there. While regexes are usually the choice
for this type of puzzle, rules 1 and 3 aren't terribly easy to check that
way anyway.

The original password provided is 'hxbxwxba'.

```
$ perl day11.pl 
part 1 result: hxbxxyzz
```

Part 2 is to find the next valid password after that.

```
$ perl day11.pl hxbxxyzz
part 1 result: hxcaabcc
```
