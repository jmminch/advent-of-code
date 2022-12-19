# Day 20: Infinite Elves and Infinite Houses

For [today's problem](https://adventofcode.com/2015/day/20), we have an
infinite number of elves delivering presents. Elf #1 delivers 10 presents
at a time to every house. Elf #2 delivers 20 presents at a time to the
second house and every other one thereafter. Elf #3 delivers 30 presents to
the third house and every third one, etc.

Therefore, each elf delivers presents to each house number that is a
multiple of the elf number. Or, looking at it the other way, house N will
get deliveries from *every elf whose number is a factor of N.*

The question has to do with how many presents get delivered to a house.
Since the elves deliver presents in multiples of 10, the number of presents
delivered to a house N will be 10 times the sum of all the factors of N.

We are asked the lowest house number that will receive at least 29,000,000
presents.

I looked up an algorithm to find the sum of all the factors of N. To do
that, find the prime factors of the number. If you have
`N = A^x * B^y * C^z...`, then the sum of all the factors of N will be
`S = (A^0+A^1+...+A^x) * (B^0+B^1+...+B^x) * ....`

So I can implement that algorithm and look for the lowest number with a
factor sum of at least 2.9 million.

The other option is to try to look for the lowest combination of prime
factors for which S is at least 2.9 million, which would probably be more
efficient, although solving that may take more number theory than I know.
I looked into the pattern with the factors and don't see a good way to solve
it like that, so I'm just going to search through the numbers until I find
one with a sum that large.

It's slow, but it works:

```
$ time perl day20-1.pl 
part 1 result: 665280

real	19m52.105s
user	19m51.717s
sys	0m0.244s
```

Part 2 is kind of different; instead of delivering presents to all the
houses each elf only delivers presents to the first 50 houses in the list. I
think the best way to solve this is to just go through the elves one by one
and increment counters for each of the houses they deliver to.

```
$ time perl day20-2.pl 
part 2 result: 705600 29002446

real	0m5.754s
user	0m5.657s
sys	0m0.096s
```

The first time I ran this, it was taking a long time (had a bug with
which index in the houses array I was using). Before I figured that out, I
wrote a C version of the same algorithm, so I'm leaving both here; the C
version is much faster.

```
$ time ./day20-2 
part 2 result: 705600

real	0m0.024s
user	0m0.019s
sys	0m0.005s
```
