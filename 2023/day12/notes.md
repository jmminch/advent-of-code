# Day 12: Hot Springs

<https://adventofcode.com/2023/day/12>

To solve this problem, I'll work through each string left to right, trying
to replace each '?' with either a '.' or '#' until finding a contradiction
or reaching the end of the string.

Most simplistically, I could just try the combinations until reaching the
end of the string and then checking whether the result matches the group
sizes given. It looks like the number of unknowns in a line don't go past
about 10 or so, which is only around 1,000 combinations; so we could try
them all.

To get fancier and more interesting, I could determine if the partial line
that I've built matches the group sizes and bail out early if it does not.
To do that, I would determine the group sizes for the partial group built;
something like:

`#.##.## => 1,2,2+`

The final group is unclosed, and so this could match any group size line
that starts `1,2` and then has a number 2 or larger for the third group.

```
$ time perl day12.pl < input 
Part 1 result: 7163

real	0m11.978s
user	0m11.957s
sys	0m0.004s
```

My first attempt (without any attempt at optimization) runs, but it's rather
slower than I expected. Part 2 expands the size of the strings and so will
take way longer to run, so I will need to improve its efficiency.

By implementing the optimization described above where I check partial
solutions to prune off incorrect solutions early, I do speed up the code
significantly.

```
$ time perl day12.pl < input 
Part 1 result: 7163

real	0m0.942s
user	0m0.936s
sys	0m0.004s
```

Applying the changes for part 2, it does work, but even with that
optimization it takes over a minute to complete for the test input, and
the real input is going to take much more time.

I had another thought for a different way to implement the solution that
would probably be even faster. Instead of working through list
character-by-character, I could work through it group-by-group. If the first
group in the list has size 3, then I can try all potential locations for
placing that first group, which will be constrained by the already-known
cells.

So for the example: `???.### 1,1,3`, I would do:

- Since the first known "#" is at offset 4, try to place the first length-1
  group at locations between offsets 0-4. Location 3 is eliminated
  immediately because it's known to be ".", and location 4 is eliminated
  because the group must be followed by a "." and location 5 is known to be
  "#".
- Try location 0, resulting in `#.?.###`.
- Now place the second length-1 group, starting at the point where we
  finished (offset 2). Again the first known # is at offset 4, so consider
  possible locations between offsets 2-4, of which 3 and 4 are still
  immediately eliminated. So the only possibility is location 2, resulting
  in `#.#.###`.
- Now place the length-3 group, starting at offset 4; offset 4 is also the
  last possible location because that is again the first known "#". So try
  that (all cells are known anyway already).
- Since all groups were placed successfully, count this arrangement.
- Back up. Since the second and third groups only had one possible location,
  go all the way back to the group 1 possibilities.
- Try location 1, resulting in `.#..###`
- Now try to place the second length-1 group. Offsets 3 and 4 are the
  possibilities, but they're immediately eliminated. Since no locations
  work, back up again.
- Try location 2 for group 1, resulting in `..#.###`
- Try to place group 2; this time only trying offset 4 which gets
  eliminated. Back up again, and since all possibilities for group 1 are
  exhausted, we're done.

This algorithm speeds things up by about a factor of 10. However, on the
input for part 2 it still takes way too long.

Translating the program to C:

```
$ time ./day12-2 < test 
Part 1 result: 21
Part 2 result: 525152

real	0m0.043s
user	0m0.042s
sys	0m0.001s
```

A speedup of 30-40x, which is less than I'd hoped but still way better than
when I started.  Compiling with -O2 gets it up to about 100x.

Since on the real input it's still taking a long time, I took a look at what
is causing delays. Line 5 is a good example: `?.????????#??? 1,2,2`. After
expansion, there are over 2 billion possibilities.

That shows me immediately that if nothing else, I need to switch my C
version to use 64-bit integers. After line 9, we end up overflowing the
32-bit int counter.

It's progressing, but still not fast enough to be reasonable. There are 1000
lines in the input, and after several minutes it's only processed a couple
dozen.
