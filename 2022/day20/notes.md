# Day 20: Grove Positioning System

[Today's problem](https://adventofcode.com/2022/day/20) is to take a list of
integers, and "mix" the list by moving each element a number of spaces equal
to the value of the entry.

It sounds straightforward, but the trick is that you need to move the
elements in the order that they appear in the original list; and as you
change the list the positions of those elements will change as well.

I can use a perl list, and then have a separate array of references to the
elements in their original order. The problem there is that I'll need to
scan the array each time to find the current offset of each element,
although that might not be prohibitive.

There's a bit of a wrinkle in the movement of the elements, which isn't
very clear in the instructions: if you try to move an element past the first
element of the array, then it should end up at the end.  That means
that if you have `2, -1, 3`, and try to move the -1, you should end up with
`2, 3, -1`, not `-1, 2, 3`. 

It makes sense if you think of the two ends of the list as being connected,
so there's only one "space" between the beginning and end.

```
$ perl day20.pl < input.txt 
part 1 result: 10763
```

Part 2 is to multiply the numbers by a big number, 811589153, before using
them; and also to run the mixing algorithm ten times. Fortunately I'm
already using modular arithmetic so the large multiplication shouldn't cause
trouble.

My solution for part 2 works fine for the test input, but not for the real
input, so I think there must be some corner case I'm not handling right. The
possibilities I can think of would be:

- Move the first entry backwards
- Move an entry backwards in front of the first entry
- Move the last entry forwards
- Move an entry forwards behind the last entry.

Creating a test case for each of those, though, they all seem to be ok.

After beating my head on it for awhile, I wrote a second version of the
program in C, which worked correctly. The main insight I had was to keep a
list of the values, and then a second list of references, and it is the
references list that I permute rather than the values list.

As a bonus, the C version runs far faster than the Perl version, probably
because I'm just using a flat array rather than a perl array which has a more
complex structure. I do a memmove to move array elements around, but since
the I only need 2 bytes per reference, the memmove isn't too bad.

```
$ time ./day20 < input.txt 
Part 1 result: 10763
Part 2 result: 4979911042808

real	0m0.036s
user	0m0.036s
sys	0m0.000s
```

Compare to the (non-working) perl version:
```
$ time perl day20.pl < input.txt 
part 1 result: 10763
part 2 result: -273505544561

real	2m1.734s
user	2m1.724s
sys	0m0.008s
```
