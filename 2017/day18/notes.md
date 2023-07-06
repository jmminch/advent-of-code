# Day 18: Duet

<https://adventofcode.com/2017/day/18>

This problem is to emulate a particular virtual machine; the only tricky
instructions (or at least abnormal) are the "snd" instruction, which plays a
sound of a particular frequency, and the "rcv" instruction, which "recovers"
the last-played frequency. So for "snd" we need to store whatever value it's
given, and then "rcv" reads it. The result for part 1 should be whatever the
first "rcv" instruction reads.

Part 2 changes how the snd and rcv instructions work, and require running
two copies of the program at once: "snd" sends a value to the other program,
and "rcv" receives the next value from the other program. I'll do that by
running one program until it does a "rcv" without any input, at which point
we switch to the other program until it does, etc. The object of part 2 is
to run until there is a deadlock (both programs waiting to receive another
value).

To determine if there is a deadlock, I just need to check if no instructions
were run before getting to a "rcv" instruction. Since the only way to start
one program is if the other one was waiting to receive a value, if no
progress is made on this program, then it must be deadlocked.

```
$ perl day18.pl < input.txt 
Part 1 result: 9423
Part 2 result: 7620
```
