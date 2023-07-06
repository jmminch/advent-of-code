# Day 4: High-Entropy Passphrases

<https://adventofcode.com/2017/day/4>

String manipulation time. The input is a set of "passphrases", lines
containing multiple words.

The first part is to determine how many of them have no duplicated words.

The second part is to determine how many of them have no words that are
anagrams of another word in the passphrase.

For the first one, need to compare each word with all others; if any are
identical then don't increment the part1 counter.

The same logic goes for part 2, but the comparison is for anagrams instead.
To determine if two words are anagrams, I'll sort the characters in the
words, and then compare them.

With that algorithm, it would be more efficient to first search for matches in
the strings (part 1) and then sort the characters in each word and search for
matches again (part 2). Quicker to implement is probably to check each pair
together for matching and then if they're anagrams, but it's less efficient
since I'd need to generate the sorted strings over and over.

```
$ perl day4.pl < input.txt 
Part 1 result: 337
Part 2 result: 231
```
