# Day 17: Set and Forget

<https://adventofcode.com/2019/day/17>

This is where I quit in 2019. As a problem, this one is fine, but it's made
artificially more difficult (or just annoying) by using an Intcode program
to deliver the map and verify the results. I think this was an example of
the author getting a little too infatuated with the toy that he built; the
Intcode steps in this problem really don't add anything positive to it as a
participant, and probably took the author most of the time that it took to
create this problem.

In any case, I'm going to split the program into parts: one to generate the
map using the provided Intcode; one to actually solve the problems; and
finally one to run the part 2 solution back through the Intcode program to
generate the submission result.

So to generate the map from the Intcode data, I use:

```
$ perl genMap.pl input > map
```

Part 1 is very simple. Part 2 is the more interesting one.

First I need to generate the list of instructions required for the robot to
follow a path that touches all scaffolding tiles. There are many different
possible paths; but from looking at it there's one "obvious" path that
involves always moving straight as far as possible, ignoring intersections
when they occur. So I'm going to generate the path that does the following:

1. If there is scaffolding in front of the robot, move forward as far as
   possible.
2. Otherwise, turn left or right based based on which way there is
   scaffolding
3. If there is no scaffolding left or right, then path is complete

Rule (3) looks like it's valid for the given input. Theoretically we could
be given input with multiple dead ends (in which case I'd have to turn twice
and return back the way I came); but I shouldn't need to worry about that.

Next, I need to break down the path into pieces. I'm starting with the
assumption that I won't need to break the "straight line" segments up,
although that may be required.

I'm thinking that algorithms to generate a dictionary for compression
algorithms could be useful here, but after a little googling I couldn't find
anything that seemed like it would fit. So here's what I'm going to try.

Since the entire path to travel must be made up of movement functions,
function 'A' must start at the beginning of the path. I can make a set of
choices for 'A': it can be any number of instructions from the path up to 20
characters.

After making a choice for 'A', then I need to figure out how to encode the
data after A. That could be either repeating A (if what I selected for A
matches what comes next), or starting function 'B'. If starting function
'B', then again I can choose any set of instructions up to the 20 character
limit.

This repeats until I've defined A, B, and C; at which point my only choices
for encoding more instructions are repeating one of those movement
functions.

Eventually, by making the choice of what to do each step, I will either
reach the point where the entire path is encoded, or I can't create a valid
encoding for the path. That could be either because the next instructions
don't match what was chosed for A, B, or C; or because adding a step would
go beyond the 20-character limit for the main movement routine.

I think it makes sense to do a DFS; I will check the longest possible
movement functions first, since those will be most likely to cause a
contradiction quickly and get pruned off.

It's possible for the algorithm to run and not find a solution (if some of
my assumptions earlier turn out to not be justified); if so I'll need to be
more elaborate.

The algorithm as described worked, so no need to make things more
complicated. Although I had intended not to, I ended up baking the Intcode
interpreter into the main solution script, so it can take the original input
code and generate the answers directly. I kept the separate genMap.pl
script, though, for visualization purposes.

```
$ perl day17.pl input 
Part 1 result: 5740
Part 2 results:
  main movement: A,B,B,A,C,A,C,A,C,B
  movement function A: R,6,R,6,R,8,L,10,L,4
  movement function B: R,6,L,10,R,8
  movement function C: L,4,L,12,R,6,L,10
Part 2 result: 1022165
```
