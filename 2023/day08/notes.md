# Day 8: Haunted Wasteland

<https://adventofcode.com/2023/day/8>

Looking at the input, the nodes all have three-letter labels.

I will transliterate the left-right string from LR to '01' and then split it
up into individual characters; that way each character will be an index into
the lists that make up the left/right connections for each node.

The nodes will be stored in a hash keyed by the node name.

```
$ perl day08.pl < input 
Part 1 result: 12361
```

Part 2 is a little weird but shouldn't be too hard; the main thing being
that it could take a lot of steps to reach the end.

After allowing the brute-force version of part 2 to run for a while, it
becomes obvious that it takes too long to come to a solution.

The various "ghosts" all move independently, and so there must eventually be
a loop for each one. However, it's complicated by the irregular directional
instructions.

The solution that I have come up with is:

- For each ghost, simulate until a loop is found. Every time a node ending
  with 'Z' is found, record the step #, node name, and instruction pointer.
  When we find a duplicate node/pointer pair, the loop has been found.
- After finding a loop, for each ghost, make a list of the step numbers
  when 'Z' nodes are reached and record the loop length. So if we have a
  step list `(10, 12, 14)` and the loop length of 10, then this ghost will
  hit 'Z' nodes on steps `(10, 12, 14, 20, 22, 24, ...)`
- Each ghost has a pointer into its list of the current step that it is on.
  We track the current maximum value of the current step for all ghosts.
  Repeatedly go through the ghosts and move through the step list until
  ending on one that is >= the current maximum.
- Eventually we'll hit a point where all ghosts are on the same step number,
  which is the solution.

Running it, it looks like the result is simpler than I anticipated: in every
case we loop back to a 'Z' node once every n steps where n is a multiple of
the length of the instructions (263 steps). The multiples are 47, 79, 61,
73, 71, and 59--all primes. So I expect the result to be
`263*47*79*61*73*71*59 = 18215611419223`; which is the correct answer.

I don't know that I really want to try to come up with a general solution
(since I don't really have a good test case for it either), so I'm just
going to bake my knowledge of how the solution is designed into my solver.

```
$ perl day08.pl < input 
Part 1 result: 12361
Part 2 result: 18215611419223
```
