# Day 8: I Heard You Like Registers

<https://adventofcode.com/2017/day/8>

This problem is to take a list of instructions like `b inc 5 if a > 1`; the
instructions are how to modify registers (not specified how many there are
or their names), with "inc" or "dec" operations, if a conditional is true.
(Possible conditions are ">", "<", ">=", "<=", "==", "!=".

While this is easy anyway, I'm going to abuse `eval` to make perl do most
the work. The input format is very close to valid perl already; just need to
replace the register names with perl scalars and the "inc" and "dec" with
"+=" and "-=", respectively. The registers will go into a hash, so `b`
becomes `$regs{b}`.

```
$ perl day8.pl < input.txt 
Part 1 result: 6012
Part 2 result: 6369
```
