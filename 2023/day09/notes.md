# Day 9: Mirage Maintenance

<https://adventofcode.com/2023/day/9>

Part one is kind of interesting in that we're given step-by-step
instructions on how to solve it.

I believe that there should be a polynomial for each set of numbers that
could be used to calculate an arbitrary value in the series, but the
described method is easier for me to do (since I don't know exactly how to
find that polynomial.)

One thing to note is that once you've built the set of lists described, the
next entry in each list is simply the sum of the the last number in the list
and all lower lists. Using this lends itself to a pretty simple recursive
solution to finding the next value in a list:

```
nextVal(list) = nextVal(differences of the values in list) +
            (last element of list)
```

```
$ perl day09.pl < input 
Part 1 result: 1743490457
```

I was expecting part 2 to be something like "what is the 50 millionth value
in each sequence," but instead it's just asking for the previous value in
the sequence. A very similar recursive solution for the previous value in
the list should work:

```
prevVal(list) = (first element) - prevVal(differences of the values in list)
```

```
$ perl day09.pl < input 
Part 1 result: 1743490457
Part 2 result: 1053
```
