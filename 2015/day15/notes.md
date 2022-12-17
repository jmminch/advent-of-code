# Day 15: Science for Hungry People

[This puzzle](https://adventofcode.com/2015/day/15) is to make a combination
of ingredients, total number 100, and maximize a function of all the
properties, each of which has a coefficient for each ingredient.

My first impression is that I should probably be able to use some matrix
algebra to find the correct solution here, although I'm not sure I really
remember enough to do that.

Each ingredient has 5 coefficients, call them (x0 .. x4). So ingredient a
has coefficients (a0..a4), etc. If the total amount of a is called A, then
we get:

```
100 = a + b + c...
score = (A\*a0+B\*b0+C\*c0+...) * (A\*a1+B\*b1+C\*c1+...) * ...
```

We want to maximize `score`. I don't see an obvious mathematical way to get
there, so brute force it is. To generate all possibilities for a sum of 100
for A, B..., I loop through trying all possiblities from 0-100 for A; and
then find all possibilities for (100 - A) for the remaining items.

```
$ perl  day15.pl < input.txt 
part 1 result: 13882464
```

Part 2 asks to find the best recipe that results in a calorie count (last
coefficient) of 500. Since I already know that it's quick enough to try all
combinations, I just stick with that, but return a score of 0 for any recipe
with the wrong calorie count.

```
$ perl  day15.pl < input.txt 
part 1 result: 13882464
part 2 result: 11171160
```
