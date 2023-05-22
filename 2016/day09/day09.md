# Day 9: Explosives in Cyberspace

<https://adventofcode.com/2016/day/9>

This problem has to do with a string of RLE-type data. A marker like `(AxB)`
means to repeat the next `A` characters `B` times.

For part 1, the question is what the decoded size of the string is, assuming
that the repeated data is not recursively expanded. For part 2, the question
is the same, but with recursive expansion---so something like `(6x2)(1x3)A`
would expand to `AAAAAA`. The notes for part 2 include a hint that the
expanded form is probably going to be too large to actually generate.

The relationship of the two problems is interesting in that that obvious way
to solve part one---by decoding the string and getting the length---is
actually harder than just calculating the length without actually generating
the decoded string. That becomes obvious when you start working on part 2.
