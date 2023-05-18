# Day 16: Permutation Promenade

<https://adventofcode.com/2017/day/16>

In this problem, we have a list of 16 elements (letters a-p), and a list of
instructions for modifying the list. The instructions are "spin" (move some
number of elements from the end of the list to the front), "exchange" (swap
two elements by position), and "partner" (swap two elements by letter).

Part 1 is to determine the order of elements after performing the
instructions once; part 2 is to repeat it one billion times.

Implementing the instructions should be fairly straightforward; although
repeating one billion times could take a while (the full set of instructions
is pretty long.) There may be a repeating pattern which I could look for,
although the number of permutations is much larger than 1 billion so it's
quite possible there isn't. It could also make sense to try to optimize the
input instructions, but doing so isn't intuitively easy---at first I thought
I could just figure out how each element in the array moves during the first
loop and then apply that over and over, but the "partner" instruction makes
that not work.

Implementing it the naive way applying the instructions over and over, it
takes this system about 0.15 ms per iteration, which would take over a day
to finish a billion iterations. So obviously I'll need to figure out how to
optimize this. My first idea is to see if there's a loop that happens
quickly; so I'll look at whether we return to 'abcdefghijklmnop' within a
relatively small number of iterations.

It turns out that with the input given, there's a loop every 60 iterations.
So all I need to do is run it (1e9 % 60) times, which is 40 times. To make
it work with other inputs, I'll have the code calculate the number of
iterations required.

```
$ time ./day16 < input.txt 
Part 1 result: ociedpjbmfnkhlga
Loops after 60 iterations.
Part 2 result: gnflbkojhicpmead

real	0m0.018s
user	0m0.017s
sys	0m0.000s
```

I wrote this in C rather than perl because I figured that I would need to
run a very large number of iterations for part 2 and a C implementation
would be faster; turns out that was a mistake, since running the required
number here (just 100 iterations, the way I implemented it) would have
easily been fast enough in perl as well, and the C implementation is longer
than I would have needed in perl.
