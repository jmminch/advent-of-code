# Day 23: Safe Cracking

This is a continuation of day 12, adding a new instruction to the emulator
from that day.

tgl x toggles the instruction x away (pointing at instructions like jnz
does: positive means forward; negative means backward):

* For one-argument instructions, inc becomes dec, and all other one-argument
  instructions become inc.
* For two-argument instructions, jnz becomes cpy, and all other
  two-instructions become jnz.
* The arguments of a toggled instruction are not affected.
* If an attempt is made to toggle an instruction outside the program,
  nothing happens.
* If toggling produces an invalid instruction (like cpy 1 2) and an attempt
  is later made to execute that instruction, skip it instead.
* If tgl toggles itself (for example, if a is 0, tgl a would target itself
  and become inc a), the resulting instruction is not executed until the
  next time it is reached.

I'll start with day12.pl and add the appropriate support for this
instruction.

Too bad they didn't spell out 'invalid instruction', but the possibilities I
see as being invalid:

* second argument for cpy is an integer
* argument to inc or dec is an integer
* maybe also jnz (nonzero, zero)?  That would cause an infinite loop.

```
$ perl day23.pl 7 < input2.txt 
part 1 result: 14445
```

Part 2 says to use 12 instead of 7 as the initial state of a, but gives a
hint that the program will take too long without some optimization, and that
probably the problem is that multiplication of large numbers is being
implemented using just increment/decrement.

Usually the thing to do here is to analyze the program to optimize it (or
determine by hand what it's doing.)

This is something I'm not very good at, but by tracing though the code I
believe that:

* instructions 3-10 result in: a=a x b, c = 0, and d = 0
* instructions 11-16 result in: b--, c = 2 x b, d = 0

(I put some annotations in input-annotate.txt).

So I'll add a 'mul a b' instruction to do those multiplies. Since I want to
leave the instruction numbering the same, I'll replace the extra
instructions with "inc 999", which is invalid and so will be skipped.

My revised program (input2.txt) produces the same result for the initial
state of 7 as the original, which is a good sign. Trying with the part 2
state of 12:

```
$ perl day23.pl 12 < input2.txt 
part 1 result: 479011005
```

It works!
