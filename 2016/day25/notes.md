# Day 25: Clock Signal

Back to the emulator from day 23; this time adding an output instruction.
The object is to initialize a with a positive integer that will result in an
endless alternating stream of zeroes and ones.

Chances are that I'll need to do a similar analysis as in day 23 part 2 to
optimize the code before it can run at a reasonable speed, but I'll
implement it as given at first.

The other trick is figuring out whether an input really will produce an
endless alternating stream. I can run the code and bail out when I get an
incorrect value, but if I get correct values for a while how do I know that
it's endless?

One option might be to track the state (at the time of the output
instruction) and see if we have a repetition in the state. However, that's
not necessarily enough, since the code could be designed so that the state
doesn't ever end up repeating.

There are no toggle commands in the input, which would make tracking the
state easier since I only have to track the instruction pointer and 4
registers.

Trying it out, I get to input=196 quickly, at which point it stops.
Checking what's being generated, that input generates 20k+ correct outputs,
where all the rest generated no more than a few. So the next thing I tried
with that input is to display the states of the registers -- and it is,
indeed, repeating. Since the register states are repeating, that should be
my answer (and it is).
