# Day 18: Like a Rogue

<https://adventofcode.com/2016/day/18>

This is really a one-dimensional cellular automata. The two states are '.'
and '^'; the line is fixed in width and anything outside that width is
treated like '.'.

I can encode the 'rules' as a hash indexed by the state of the three tiles
surrounding the index of the tile that I'm generating. I'll add a '.' to the
beginning and end of the input string so I don't need special cases for the
edges.

```
$ time perl day18.pl input 
Part 1 result: 2005
Part 2 result: 20008491

real	0m4.300s
user	0m4.300s
sys	0m0.000s
```

My gut was that implementing the evaluation function as a list of characters
rather than storing it as a string that I appended to would be quicker, but
that was wrong. Rewriting so that I appended each character to an output
string in the `step()` function resulted in a fairly significant
improvement:

```
$ time perl day18.pl input 
Part 1 result: 2005
Part 2 result: 20008491

real	0m2.963s
user	0m2.963s
sys	0m0.000s
```

I decided to try to optimize this one in C. I used bit vectors instead of
strings for the line state, which can be processed fairly efficiently.
I tried inlining some of the functions, which didn't have any performance
impact, so I guess that the compiler did a pretty good job deciding where to
inline.

```
$ time ./day18 < input 
Part 1 result: 2005
Part 2 result: 20008491

real	0m0.073s
user	0m0.069s
sys	0m0.004s
```
