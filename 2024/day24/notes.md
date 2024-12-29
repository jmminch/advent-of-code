At a first guess, a general solution for part 2 seems really hard. Brute
force is out; back-of-the-envelope calculation is that there are something
like 1e16 possible combinations of four sets of gates to switch.

It's relatively straightforward to express how the output bits of the adder
should depend on the input bits, but there's probably an awful lot of
"valid" ways to implement an adder with AND, OR, and XOR gates. However,
my thought is that maybe the implementation here is a "simple" one made out
of a bunch of full adders, and then it should be tractable to figure out
which ones are wired up the wrong way.

The definition for z00 is what I'd expect with a simple implementation:
`y00 XOR x00 -> z00`. Looking at z01:

```
x00 AND y00 -> fgw
x01 XOR y01 -> bgb
fgw XOR bgb -> z01
```

fgw is the carry bit in; this is the right logic for the sum bit for z01.
Looking for how else x01 and y01 are used:

```
y01 AND x01 -> pjh
fgw AND bgb -> gww
pjh OR gww -> wwp
```

wwp is the carry bit out. So this is a normal full adder circuit made with
two XOR gates, two AND gates, and one OR gate.

A little more research and I concluded that the circuit is a simple ripple
carry adder. I decided to adjust my code to help me find where there were
problems, and then manually determined which wires needed to be swapped.
This took a while, but it worked. I updated a copy of the input (input-2)
with the updates each time I found a problem until I had fixed the entire
circuit.

It turned out that each swap was contained within the circuit for one adder.
If I had known that, maybe it would have made this easier.

The puzzle answer was cnk,mps,msq,qwf,vhm,z14,z27,z39.
