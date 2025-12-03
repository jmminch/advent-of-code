# Day 11: Plutonian Pebbles

<https://adventofcode.com/2024/day/11>

The main thing that I notice with this problem is that we could evaluate
how each of the stones evolves independently; none of the rules affect
multiple stones. (So if we have two stones `A B`, and `A -> C D` and
`B -> E F`, then `A B -> C D E F`.)

So I think a recursive solution may work here. I could have a function that
determines how many stones will be generated after `n` blinks; it would
apply the rules and then recursively call itself for each generated stone
for `n - 1` blinks.

Part 2 simply increases the number of blinks; since the total number grows
quickly a solution that tries to create the full list will struggle.
However, since I was just counting the possibilities without creating the
list, the change was trivial.

I did add in using the Memoize module since my assumption is that we are
likely to end up hitting the same combinations of value/steps multiple
times.

```
$ time perl day11.pl input 
Part 1 result: 187738
Part 2 result: 223767210249237

real	0m0.168s
user	0m0.164s
sys	0m0.004s
```

That turned out to be good call; without that it takes a very long time (I
eventually stopped the run after a minute.)

I decided to try implementing it in C to see what the results were; it
actually wasn't much of an improvement. I suspect that the problem is that
my method to split the number into two halves is kind of slow, although I
don't know how to really make it more efficient.
