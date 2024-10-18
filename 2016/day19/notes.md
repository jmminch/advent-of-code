# Day 19: An Elephant Named Joseph

<https://adventofcode.com/2016/day/19>

The first part looks like it would be easiest to simulate using a
doubly-linked list (ring.) That makes it trivial to keep track of the next
elf in the ring, and removing elves when their presents are stolen.
It's worth mentioning that there's not actually any need to track the number
of presents each elf has -- all that really matters is if the elf is
eliminated or not.

On the other hand, part 2 is trickier, since you'd need to find the elf that
is as far away as possible from the one you're analyzing -- so simply using
a linked list means walking it every turn, which would be too prohibitive.

I could store the list of elves as an array and use memmove to remove elves,
although that results in a lot of copying big blocks around.

I wonder if a tree-based structure could work, where each node of the tree
stores the number of elves within that subtree.

Trying the memmove approach -- using perl lists and splice -- takes way too
long. I think it would probably finish in reasonable time if I rewrote in C,
but I'm going to try the tree idea instead.

```
$ time perl day19.pl 
Part 1 result: 1834471
Part 2 result: 1420064

real	9m3.834s
user	9m3.780s
sys	0m0.032s
```

Each node of the tree will contain the elf id, count of elves in this
subtree (including this one), and then pointers to the parent, left, and
right nodes; where "left" is a subtree containing elf IDs greater than this
one and "right" contains elf IDs smaller than this one.

```
$ time perl day19.pl 
Part 1 result: 1834471
Part 2 result: 1420064

real	0m57.165s
user	0m56.235s
sys	0m0.928s
```

Still not speedy, but a lot better than before. Did a direct translation of
this algorithm to C:

```
$ time ./day19 
Part 1 result: 1834471
Part 2 result: 1420064

real	0m1.050s
user	0m0.906s
sys	0m0.144s
```
