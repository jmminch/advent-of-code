# Day 7: Camel Cards

<https://adventofcode.com/2023/day/7>

Part one involves putting the poker hands in order. All of the hands in this
game depend just on the number of cards of the same rank, so to order those
I just need to count up how many of each character appear; and then hands of
the same rank are compared by comparing the cards starting from the first in
the order given, so that can be done with a simple alphabetical comparison
if I do a transliteration of the hands to letters a-m, like
`tr/2-9TJQKA/a-m/`.

For part 2, we now have jokers. Jokers are the weakest card, and so I'm
going to use a card representation of `a-n` instead with `a` being the
joker.

I believe that to determine the best hand using jokers, you just need to add
the number of jokers to the type of card that you have the most of. I
implemented that, but I get the wrong answer for the actual input. (Correct
answer for the test input, though). So it seems like I've got a problem
somewhere in my ranking logic.

```
$ perl day07.pl < input 
Part 1 result: 248217452
Part 2 result: 246000630
```

A little experimentation and I realized that I wasn't correctly handling the
5-joker case. Fixing that gives the correct answer.

```
$ perl day07.pl < input 
Part 1 result: 248217452
Part 2 result: 245576185
```
