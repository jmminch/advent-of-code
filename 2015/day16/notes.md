# Day 16: Aunt Sue

[This puzzle](https://adventofcode.com/2015/day/16) has a bunch of partial
entries for various properties of people; and you have to figure out which
one of them matches the one you're looking for.

```
children: 3
cats: 7
samoyeds: 2
pomeranians: 3
akitas: 0
vizslas: 0
goldfish: 5
trees: 3
cars: 2
perfumes: 1
```

To solve this one, just go through the lines one by one and make sure that
any information given for that particular matches the expected values; if it
is then you've found the target.

```
$ perl day16.pl < input.txt 
part 1 result: 103
```

For part 2, the condition just changes slightly (we're looking for `cats`
and `trees` greater than the specified number; and `pomeranians` and
`goldfish` smaller than the specified number.)  It makes the code ugly
hardcoding those, but it's no more difficult.

I did run into a bug at first because I didn't realize that I needed to
reset the match position with "pos() = 0" before starting to process the
line a second time to apply the part 2 conditions.

```
$ perl  day16.pl < input.txt 
part 1 result: 103
part 2 result: 405
```
