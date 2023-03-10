# Day 19: Medicine for Rudolph

I had to read [this problem](https://adventofcode.com/2015/day/19) a couple
times before I understood what was being asked. The idea is that we have a
string (the example is `HOH`), and then a list of potential replacements for
each character (like `H => HO`, `H => OH`, `O => HH`). The question is by
making a single substitution, how many unique strings can be generated.

So this should be pretty simple: step through the string character by
character, and make each possible substitution, and record the results in a
hash; then just pull out the number of hash keys.

Looking at the input data, it's a little different than I had assumed: the
input atoms may be two characters (like `Al`, `Ca`.)  So the approach I
think I will take is to make a list of each possible replacement for each
atom, and then search for matches in the source molecule and make
each replacement.

```
$ perl day19.pl < input.txt 
part 1 result: 535
```

For part 2, we start with 'e' and need to generate the target molecule using
the replacement rules. A breadth-first search may work, although the number
of possibilities is going grow really fast.

I gave that a shot; the number of possibilities does grow too fast for that
approach to be workable.

Since the rules always cause one atom to produce more than one, that means
that the first atom in the product (in my input, 'C') must be produced by
a sequence of actions on the first atom.  So maybe the thing to do is look
at the possible ways to generate the first atom, then move on to the next,
etc.

After giving it some time, I got thinking about whether I could go backwards
instead of forward. I instead wrote a "decompose" function that starts with
the target molecule, and applies the transformations backwards, starting
with trying the longest first (to eliminate as many atoms as possible as
quickly as possible). It still doesn't finish the search in a reasonable
time; however, it does find three potential solutions fairly quickly, each
with steps = 212. I decided to assume that the earliest ones it found are
most likely the shortest, and submitted that as my answer, which was
correct.

Still kind of unsatisfying, though.

```
$ perl day19-2.pl < input.txt 
found path, len = 212
found path, len = 212
CRnCaCaCaCaCaCaCaCaCaSiRnFYFArCaCaCaCaFArThSiThCaCaCaF
CRnCaCaCaCaCaCaPTiRnPRnCaFArFArCaCaCaFArAl
CRnCaCaCaCaCaCaCaSiRnFYFArPTiRnPRnCaFArFArCaCaFArThCaCaCaCaCaF
CRnCaCaCaCaCaCaCaCaSiRnCaFYFArCaPRnCaFArCaCaCaCaFArThCaCaCaCaCaF
CRnCaCaCaCaCaCaPBPRnPRnFArFArCaCaCaCaFArAl
CRnCaCaCaCaCaCaCaCaSiRnFYFArPBPRnPRnFArFArFArThSiAl
^C
```
