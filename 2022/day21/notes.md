# Day 21: Monkey Math

I've had a little trouble with day 19 (and not much time to work on it), so
I've fallen behind a bit. I decided to just go ahead and try out [today's
problem](https://adventofcode.com/2022/day/21) and see if I can knock that
one out.

Today the goal is to find the result of an algebraic expression; it can
contain variables which can be based on other expressions, etc.

There's a (not-so-gentle) hint that a good way to do this is to build a
tree, since you're trying to find the value of the variable named "root".

I'm not sure I'm going to do that, though. I think I'll store the definition
for each variable in a table, and then just have a function that resolves
the expressions, calling itself recursively if the expression is based on
other variables.

```
$ perl  day21.pl < input.txt 
part 1 result: 49288254556480
```

For part 2, the object is to find a number for the variable 'humn' that
causes the two variables depended on by 'root' to be the same.

Solving it symbolically seems difficult. Given how big the result number is,
I imagine that just trying all numbers won't work. But it seems like a
binary search might do the trick.

A value of 0 for humn gives a result for the first variable bigger than the
second, and using 49288254556480 (the part 1 result, since at a guess the
right answer is probably of the same order) gives a result that's smaller.
So I'll just try doing a binary search until I find a number that makes
those two equal.

```
$ perl day21.pl < input.txt 
part 1 result: 49288254556480
part 2 result: 3558714869436
```
