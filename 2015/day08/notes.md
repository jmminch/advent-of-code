# Day 8: Matchsticks

The problem is to take a list of double-quoted string literals, which may
contain escape sequences, and determine the length of the code for the
string literals (so including the quote and backslash characters) minus the
length of the strings that they represent.

The easy way is to cheat ... just eval the string and assign it to a
variable; let Perl handle the conversions. This will work as long as there
aren't any escape sequences present that perl will interpret but that we
shouldn't consider for this problem. I made sure to add code to check and
bail if the input contains such sequences ... it doesn't.

```
$ perl day08.pl < input.txt 
part 1 result: 1350
```

Part 2 is to take the double-quoted string literals and create an escaped
double-quoted version of them. (Thus "a" -> "\"a\"".) Should be as simple as
doing a regex substitution and then pasting double quotes on both sides.

```
$ perl day08.pl < input.txt 
part 1 result: 1350
part 2 result: 2085
```

This is one of those days where choice of language makes a big difference.
