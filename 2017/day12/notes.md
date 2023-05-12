# Day 12: Digital Plumber

<https://adventofcode.com/2017/day/12>

The task here is to take a list of nodes that can be connected to each
other, although there are multiple independent groups that are connected to
each other. The idea for part 1 is to find how many nodes are in the group
containing node 0, and for part 2 how many groups there are.

The lines of the input define which nodes each node is connected to. Because
all we care about is which nodes are in a group together, not the details of
the connections, the only information that we need from each line is that
every node that appears in a line together needs to be in the same group.

As an approach, if we have the following:

```
1 <-> 2, 3
4 <-> 5
3 <-> 1,4
```

With the first line, we can make a group starting with 1, and then add 2 and
3 to it. The second line starts a new group with 4, and adds 5 to it. Then
when looking at the third line, we know that anything in this line should be
added to the first group. 1 is already known to be in that group, but then
since 4 is currently in a different group, we need to combine the groups.

I implemented a simple version of this: essentially the first time we see a
number, we create a new group for it, and then we go through each line and
combine all the groups containing the nodes on that line into the first
node's group. As implemented it's kind of slow, because I just do a linear
search through all the groups to find a particular node.

```
$ perl day12.pl < input.txt 
Part 1 result: 141
Part 2 result: 171
```
