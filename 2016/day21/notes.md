# Day 21: Scrambled Letters and Hash

<https://adventofcode.com/2016/day/21>

Part 1 looks straightforward; none of the instructions look hard to
implement.

For part 2, we have to run the instructions backwards.

* "Swap position X and Y" -- same for reversed instruction
* "Swap letter X and Y" -- same for reversed instruction
* "Rotate L/R X steps" -- for reversed instruction, switch the direction
* "Reverse positions X to Y" -- same for reversed instruction
* "Move position X to Y" -- swap X and Y

The tricky one is "rotate based on position of letter". It seemed like the
instructions would result in multiple initial strings scrambling to the same
string with that instruction, which is true for an arbitrarily-sized
password string. Since the passwords are limited to 8 characters, though,
they all end up mapping to rotating to a unique position; then it's easy to
just build a table of how far to rotate when reversing the instructions.

| Starting location | Ending location | rotation |
| --- | --- | --- |
| 0   | 1   | 1   |
| 1   | 3   | 2   |
| 2   | 5   | 3   |
| 3   | 7   | 4   |
| 4   | 2   | 6   |
| 5   | 4   | 7   |
| 6   | 6   | 0   |
| 7   | 0   | 1   |

```
$ perl day21.pl input 
Part 1 result: gbhafcde
Part 2 result: bcfaegdh
```
