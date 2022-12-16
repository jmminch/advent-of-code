# Day 12: Leonardo's Monorail

This problem is to emulate a simple computer. Usually with these sorts of
problems you end up revisiting it in later days.

In this case, there are 4 registers (a-d) that are initialized to 0 and can
hold any integer, and there are 4 instructions that it understands:

1. cpy x y copies x (either an integer or the value of a register) into
   register y.
2. inc x increases the value of register x by one.
3. dec x decreases the value of register x by one.
4. jnz x y jumps to an instruction y away (positive means forward; negative
   means backward), but only if x is not zero.

Part 1 is to determine the value in register a when the program
completes.

My general approach is to have a hash that stores the register values, an
instruction pointer, and then an array of the instructions. A "get" function
that takes a parameter and looks up the value (either direct or indirect if
a register was specified) is usually helpful.

```
$ perl day12.pl < input.txt 
part 1 result: 318077
```

For part 2, just need to repeat with register c initialized to 1.

```
$ perl day12.pl < input.txt 
part 1 result: 318077
part 2 result: 9227731
```
