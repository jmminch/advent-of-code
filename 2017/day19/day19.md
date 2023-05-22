# Day 19: A Series of Tubes

<https://adventofcode.com/2017/day/19>

This problem gives us a diagram of wires that looks something like this:

```
     |          
     |  +--+    
     A  |  C    
 F---|----E|--+ 
     |  |  |  D 
     +B-+  +--+ 
```

The object is to follow path, starting at the top going down, only turning
when required, and record the letters in the order you cross them.

The main trick to recognize here is despite the different characters used
for the wires to make it look "nice," they really don't matter. We just need
to keep finding the next valid location, preferring to go in the same
direction as before if possible, or turning 90 degrees if not.

Part 2 is to count the number of steps taken, which should be trivial to
track.

```
$ perl day19.pl < input.txt 
Part 1 result: MOABEUCWQS
Part 2 result: 18193
```

While I said that part 2 should be trivial, the result for part 2 is wrong.
Part 1 is correct, though, so I'm at least mostly following the right path.
I get the correct result for the test data (diagram above.)

Turns out I didn't normalize my direction variable in the range of 0-3,
which is what my code expected. That fixed the problem.

```
$ perl day19.pl < input.txt 
Part 1 result: MOABEUCWQS
Part 2 result: 18058
```
