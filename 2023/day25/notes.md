# Day 25: Snowverload

<https://adventofcode.com/2023/day/25>

This seems like the kind of problem where there should be some sort of
clever mathematical solution, but I haven't been able to figure it out.

Let's say I just try to brute-force it. There are 1269 nodes in the input,
and we have to choose 3 of them, for a total of `1269*1268*1267=2038719564`
possibilities. That may be possible, but I'd need to come up with a really
efficient way of checking each possibility, which will be tough.

Actually, the number is worse than that; there's actually 1566 nodes (I
missed that not all nodes have their own line), for a total of 3833035560.

I could not come up with any reasonable way to do this, so I finally looked
up how others solved the problem, which pointed me to "Karger's algorithm."
Wikipedia: <https://en.wikipedia.org/wiki/Karger%27s_algorithm>. Reading
through the description, the general idea makes sense. Essentially you
randomly choose two nodes to combine and do so, but maintain the connections
to all the remaining nodes. When the graph has shrunk to two nodes, the
connections between them are the ones to cut to partition the graph into two
sets of nodes.

The result is probabilisitic; it may (probably will) take multiple runs to
find a cut of three nodes that solves the problem.

My implementation keeps track of the size of each node (number of nodes
merged into this one), and then the number of edges between nodes (I don't
actually need to record which edges they are.) Because of the nature of the
solution, the runtime varies wildly depending on whether the algorithm picks
the right edges or not.

```
jmminch@hex  ~/git/advent/2023/day25
$ time perl day25.pl input.txt 
Part 1 result: 612945

real	0m17.844s
user	0m17.830s
sys	0m0.008s
jmminch@hex  ~/git/advent/2023/day25
$ time perl day25.pl input.txt 
Part 1 result: 612945

real	0m0.205s
user	0m0.201s
sys	0m0.004s
jmminch@hex  ~/git/advent/2023/day25
$ time perl day25.pl input.txt 
Part 1 result: 612945

real	1m23.304s
user	1m23.292s
sys	0m0.004s
```
