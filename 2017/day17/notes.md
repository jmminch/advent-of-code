# Day 17: Spinlock

<https://adventofcode.com/2017/day/17>

For this problem, we've got a process that takes a circular buffer, starting
containing just the value zero, and then inserts numbers by stepping a
pointer forward some number `n` steps and inserting the next value (starting
with 1) after it.

Part 1 is to determine what value is after 2017 in the buffer right after
number 2017 is added. Part 2 is to determine what value is after 0 right
after number 50,000,000 is added.

To simulate this (easiest way to handle part 1, as far as I can see), I will
just use a perl array, and use the splice function to insert into it. Each
time you just increment the pointer by a value n, taking it modulo the
current number of steps, and then insert the new value at the next position
(and move the pointer to that next position.) If the pointer ends up at the
end of the array, then the new value becomes the new end of the array.

Simulating part 2 is probably doable, but can be improved. The value
zero, with this approach, always stays in position 0 of the array, which
means that the "next" value after 0 only changes when the pointer lands on that
position. Other than that, we don't care at all about the contents of the
array, so we don't need to simulate it. While there's probably a simple
mathematical relationship to calculate the final number directly, I can just
track how the pointer moves across 50,000,000 steps, but save all the work
of keeping the array.

```
$ time perl day17.pl 
Part 1 result: 725
Part 2 result: 27361412

real	0m5.301s
user	0m5.291s
sys	0m0.004s
```

Out of curiosity, I switched to simulating the array for all 50,000,000
loops to see how long it would take.  At 8.5 hours, it was still running.
Presumably there's just too much overhead in inserting something into a huge
array using splice()---looking it up, it looks like perl arrays are
implemented as an array of pointers and so the splice will cause a memmove()
of all of the moved elements of the array.

Just for kicks, I wrote a 'C' version that actually simulates the entire
thing, using a linked list for storing the list. It does take a while
(mostly due to needing to move one-by-one through 329 elements of the linked
list each loop---I couldn't figure out a good way to avoid that) but still
finishes in a reasonable amount of time.

```
$ time ./day17 
Part 1 result: 725
Part 2 result: 27361412

real	2m8.253s
user	2m7.841s
sys	0m0.018s
```
