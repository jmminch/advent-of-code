# Day 22: Wizard Simulator 20XX

[This problem](https://adventofcode.com/2015/day/22) has some similarities
to the day before; it's another RPG combat simulation, but in this case
you have to choose which spells to cast from a list to defeat the boss with
a minimum amount of mana used. Rather than trying all combinations, using a
pathfinding-type algorithm is probably better here.

The state of the combat includes:

* player hp
* player mana
* boss hp
* shield turns remaining
* poison turns remaining
* recharge turns remaining
* mana spent

I want to be able to determine quickly if we've ever reached a state
identical in the first 6 or not -- if we do, and we've already reached that
state with a lower 'mana spent' count, then we don't need to search any
further along that line.

I want a function that can take the current state and then determine what
the state at the start of the next turn is; which means both the player's
turn and the boss's turn. Getting the order right is important. After
choosing an action, the following happen, in order:

1. Apply the direct effects of the chosen action. (damage, healing) (boss
   may die)
2. Start timers for action effects
3. (boss turn starts) Apply effects. (boss may die)
4. Boss attacks (player may die)
5. (player turn starts) Apply effects. (boss may die)

```
$ perl day22.pl 
part 1 result: 953
```

For part 2, the only difference is that at the start of each turn, the
player loses 1 hp. It's a simple change in the code, but expands the
required search significantly, which meant that my initial implementation
wasn't efficient enough.

To solve that, I added a cache indexed by the state (everything but mana
spent), and then associating that with the mana spent. If I hit an identical
state where the mana use is equal or higher than one I've already seen, then
it can be discarded.

```
$ perl day22.pl 
part 1 result: 953
part 2 result: 4536
```

It runs quick, but my answer is too high; looks like the problem is that my
code that is supposed to keep the queue of states in order of increasing
mana use isn't working properly.

After fixing the problem with the queue ordering, though, I get the same
answer, so that wasn't the problem.

Reading through the requirements again, I found I was applying the hard mode
HP loss at the wrong time (after effects were applied rather than before). I
fixed that and get a different answer, but it's still incorrect. (This is
the point at which it really would be nice to have known test data to run it
against.)

```
$ perl day22.pl 
part 1 result: 953
part 2 result: 1309
```

I found the problem, after a lot of debugging ... and it turned out to be a
simple syntax error. (Using $newState{manause} instead of the correct
$newState->{manause}). I've tried using "use strict 'vars'" in my scripts
before to try to catch this class of error, but it didn't work quite the way
I expected. I guess I need to look into it more.

```
$ perl day22.pl 
part 1 result: 953
part 2 result: 1289
```
