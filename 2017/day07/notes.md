# Day 7: Recursive Circus

<https://adventofcode.com/2017/day/7>

The input for this problem defines a bunch of nodes of a tree (in some
random order). Each line of input gives a node name, the node's weight, and
then its children.

Part 1 is to find the name of the root node. That could be done trivially
without even building the tree; just find the node that is not listed as a
child of any node.

For part 2, there is a rule that the weight of a child node, including the
child's children, must be the same as all other children of the same node.
In the input there is one node with an incorrect weight; the object is to
find that node, correct its weight to follow that rule, and then return the
corrected weight.

At first I thought that I wanted to start with the root node and look for 
which child is the wrong weight and work my way down the tree. However, the
logic gets difficult for nodes with two children since you don't know which
branch to follow.

I think what I want to do is find a node that is unbalanced, but all of its
descendents are balanced. If I find such a node, then I just need to adjust
the weight of one of its direct children to correctly balance the node.

```
$ perl day7.pl < input.txt 
Part 1 result: hlqnsbe
Part 2 result: 1993
```

This is the correct answer, but upon review I think I have a mistake in my
logic. Say we've got the following tree (created test2.txt with the
appropriate input data):

```
      -- B (5)
      |
A (1) |- C (5)
      |        |- E (1)
      |- D (1)-|
               |- F (2)
```

A is unbalanced, because the total weight of D (4) is different than that of
B or C. D is also unbalanced, so one of E or F needs to change, but to
determine whether E needs to increase to 2, or F needs to decrease to 1, I
need to use the fact that the total weight of D must be 5. This scenario
seems valid based on the question (only one node needs to change weight to
fully balance the tree, and there is a unique correct answer), but my method
can't solve it.

I think that I can solve this by considering two cases: where the node that
was found earlier has exactly 2 children, and when it has 3 or more
children. (One or none cannot happen, because such nodes cannot be
unbalanced.) If it has more than 2 children, then my prior logic works fine.
If it has only two children, then there are two possible cases. The simplest
solution is to change the first child's weight, and check if the root node
is now "fully balanced" (including its descendents.) If it is, then the
change was correct; if it's not, then we need to change the other node
instead.

I'll remove the caching from calculations of total weight and whether a node
is fully balanced (either have to do that, or clear the caches when changing
a node's weight.)

I decided also to not do a special case for more than two children; instead,
it will just do trial and error for all children until finding the right
solution. The revised solution really isn't any longer than the original,
and handles both the puzzle input as well as the tree described above
correctly.
