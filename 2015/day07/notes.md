# Day 7: Some Assembly Required

The problem here is to implement an emulator for a circuit made of a set of
logic gates. The circuit is specified to work with 16-bit integers. The
following instructions are possible; looks like 'x' can be either a decimal
value or a wire name.

1. x -> reg 
2. x AND x -> reg
3. x OR x -> reg
4. x LSHIFT x -> reg
5. x RSHIFT x -> reg
6. NOT x -> reg

At the end we want to know what value is on wire 'a'.

The trick here is that you can't just iterate through the list; instead you
need to propagate the values through the circuit. To do that, I process the
instructions of the form "(value) => (wire)" first, and put those wires on a
queue; then repeatedly pull wires off that queue and try to process the
rules that use the results from those wires. If the result can't be
processed (e.g. the next step requires a value that hasn't been calculated
yet), then skip it; when the other value is calculated it will end up on the
queue. Eventually we should get a result for wire 'a'.

```
$ perl  day7.pl < input.txt 
part 1 result: 46065
```

Instead of writing more code, part 2 just asks you to change the input for
wire b to the result of part 1. I just created input-pt2.txt with that
change.

```
$ perl day7.pl < input-pt2.txt 
part 1 result: 14134
```
