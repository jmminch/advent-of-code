# Day 7: Camel Cards

<https://adventofcode.com/2023/day/7>

Part one involves putting the poker hands in order. All of the hands in this
game depend just on the number of cards of the same rank, so to order those
I just need to count up how many of each character appear; and then hands of
the same rank are compared by comparing the cards starting from the first in
the order given, so that can be done with a simple alphabetical comparison
if I do a transliteration of the hands to letters a-m, like
`tr/2-9TJQKA/a-m/`.


