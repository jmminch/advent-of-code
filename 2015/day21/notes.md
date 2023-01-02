# Day 21: RPG Simulator 20XX

[Today's puzzle](https://adventofcode.com/2015/day/21) involves a CRPG-style
combat simulation; the object is to figure out the cheapest set of equipment
you can buy and still win the battle.

I created a simCombat function that runs the combat rules and determines
which character will win. It could be made much quicker by determining how
many rounds it would take to defeat the player/boss rather than simulating
it round-by-round, but I'll only do that if part 2 requires handling some
absurd number of simulation rounds or something.

Since the number of combinations isn't very high, I just try them all and
find the cheapest one that results in a win.

```
$ perl day21.pl < input.txt 
part 1 result: 91
```

Part 2 is just to do exactly the same thing, but find the highest value
equipment that does not win the fight. Making that adjustment is trivial.

```
$ perl day21.pl < input.txt 
part 1 result: 91
part 2 result: 158
```
