# Day 16: Ticket Translation

Getting into some trickier problems now. My solution for [this
one](https://adventofcode.com/2020/day/16) is 169 lines.

The idea is that you have a list of tickets where you know the values of the
fields, but you don't know which field is which; you also know what the
valid ranges of values are for each field.

The first part is just to go through each ticket and find which ones contain
numbers that can't possibly be valid (contain numbers that aren't valid for
any field) and eliminate them.

The way that the problem is presented, they just want you to check the
values individually. That doesn't seem like it's enough to ensure validity
of the ticket; consider the following:

```
field a: 1-2
field b: 3-4
field c: 5-6
ticket: 3,4,5
```

This ticket can't possibly be valid; but since all of those numbers fall
within the possible ranges of one of the fields, the naive approach will
consider it valid. Since solving the problem this way gives the correct
result for the input, they must have ensured that no tickets of that sort
are in the input data.

The second part is trickier; it asks you to find the positions corresponding
to each field in the ticket data. I did that by doing the following:

1. Build a list of potential fields that could exist at each position.
2. For any position that has only a single possible field, the position of
   that field is known. Eliminate that field as a possibility from any other
   positions (which may reduce other positions to a single possibility).
3. If there are any positions left with multiple possibilities, then try
   each possibility in order and repeat steps 2 & 3 until either a
   contradiction or a solution is found.

It turns out, with the input data, that steps 1 and 2 are sufficient to get
a result; after eliminating fields based on there only being a single
possibility, no positions with multiple possibilities remain; and after
trying a few things I think I've convinced myself that step 3 isn't actually
required ... step 2 will always be successful. Because of that, I eliminated
that portion of my solution from day16.pl, although I kept the code around
in day16-extra.pl.

```
$ perl day16.pl < input.txt 
part 1 result: 22057
part 2 result: 1093427331937
```
