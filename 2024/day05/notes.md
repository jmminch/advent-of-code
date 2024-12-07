# Day 5: Print Queue

<https://adventofcode.com/2024/day/5>

The simplest approach to this problem would be to loop through each page
list, and evaluate whether or not it follows each rule. That would require a
lot of extra scanning of the page lists, although my guess is that even with
the full input it wouldn't take prohibitively long.

One thing that isn't addressed in the problem description is whether or not
a page may be duplicated in the page list. If it can be, then you need to
be careful of how you check whether the list follows the rules.

As a first pass, I did it the simple way, turning each rule into a regex of
the disallowed ordering (so if the regex matches, then the page list is
disallowed.)

Part 2 is to sort the lists. That should be fairly easy with a custom
sorting subroutine for sort(). However, the approach that I took with part 1
doesn't really help here, and I kind of want to improve the efficiency
anyway, so I'm going to redo it.

Instead of turning the rules into regexes, instead for each page number I'm
going to store a list of pages that must come after it. So the list of
rules: `2|3 2|5 2|7` will become `$rules{2} = { 3=>1, 5=>1, 7=>1 }`.
I can evaluate part 1 by going through the list of pages and determining if
any page before the one I'm looking at is disallowed; and then it's easy to
create the sorting function of which page must be before the other.

This turns out to be something like 50x faster than my initial attempt and
really isn't any more complicated codewise.

```
$ time perl day05-2.pl input 
Part 1 result: 5509
Part 2 result: 4407

real	0m0.005s
user	0m0.005s
sys	0m0.000s
```
