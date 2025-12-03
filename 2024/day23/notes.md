# Day 23: LAN Party

<https://adventofcode.com/2024/day/23>

I messed around with a brute-force solution for part 2 for a while, but it
became obvious that it would take way too long to run. I couldn't come up
with anything better, so I did some googling and found that this is referred
to as the "clique problem." [Wikipedia
entry.](https://en.wikipedia.org/wiki/Clique_problem)

There are a few algorithms described to find the "maximum clique" which is
what this puzzle is asking for. The first and simplest is the [Bron-Kerbosch
algorithm](https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm).

I basically just implemented it as is described in the wikipedia article.
