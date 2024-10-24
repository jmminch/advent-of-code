# Day 23: Coprocessor Conflagration

<https://adventofcode.com/2017/day/23>

This problem is another virtual machine problem; the instruction set is
similar but not identical to that in day 18, so a similar approach should
work.

For part 1, the question is how many times we execute the `mul` instruction.

For part 2, register `a` is initially set to 1, and the question is what
instruction is left in register `h` when the program terminates. They give
the hint that simulating the program to completion will probably take too
long. Usually the best approach for this sort of problem is to inspect the
input code and determine what it is doing; and then modify the code to
either be more efficient, or sometimes introduce a new instruction to make
what's being done more efficient.

Doing some analysis (See file input-annotated), the first 8 lines are setup
based on the initial value of register `a`; if `a==1` then we use much
bigger values for `b` and `c`. I think it's trying to find factors; a
notable segment is lines 12-20 which increments `e` in steps of one,
starting at 2 end ending at `b`, and checks whether `b == d*e`; if it does
then it sets f to 0. So we're trying to figure out if b is evenly divisble
by d; that could be done trivially with a modulo operation.

So I'll replace this segment with:

```
12 set g b
13 mod g d
14 jnz g 3
15 set f 0
16 jnz 1 5
17 sub a 0
18 sub a 0
19 sub a 0
20 sub a 0
```

`sub a 0` is just a noop, so that I don't have to modify any other jmp
instructions.

That's not enough to make this run quickly enough, though, so I'll need to
adjust it some more.

Lines 10-24 are looping on d, incrementing it until d==b. So we have:

```
f = 1
for d (2..b)
    for e (2..b)
        if(e*d == b)
            f = 0
```

This is trying to figure out if b is prime or not. If it is, then f is 1;
else f is 0.

So let's add a new opcode, `pri`, which determines if a value is prime or
not. So that it's similar to other opcodes, I'll take the value in a
register in the first parameter, and then change the register to 1 if it's
prime, 0 otherwise. So lines 9-24 can become:

```
 9 pri f b
10 sub a 0
11 sub a 0
12 sub a 0
13 sub a 0
14 sub a 0
15 sub a 0
16 sub a 0
17 sub a 0
18 sub a 0
19 sub a 0
20 sub a 0
21 sub a 0
22 sub a 0
23 sub a 0
24 sub a 0
```

This results in the correct answer, very quickly.

```
$ time perl day23.pl < input3.txt 
Part 1 result: 
Part 2 result: 903

real	0m0.043s
user	0m0.034s
sys	0m0.009s
```
