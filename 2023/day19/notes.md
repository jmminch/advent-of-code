# Day 19: Aplenty

<https://adventofcode.com/2023/day/19>

To represent the parts, I'll just use a hash with keys x, m, a, and s. The
workflows will be stored in a hash (keyed by workflow name), and will be a
list of the individual steps.

It looks like all of the conditionals are strictly `>` or `<`.

For part two, obviously brute force is out, since there are 4000^4
possibilities. This part of the problem is kind of reminiscent of part two
for day 5.

What I will do is start with a structure that defines ranges of values for
the parts instead of individual values. After each step of a workflow, I
will split off two structures; one with the ranges that the rule matched and
one that it did not.

So it should look like:

```
in{s<1351:px,x>2662:A,qqz}

start:
{x=[0-4000], m=[0-4000], a=[0-4000], s=[0-4000]}

s<1351:px
{x=[0-4000], m=[0-4000], a=[0-4000], s=[0-1350]} => px
{x=[0-4000], m=[0-4000], a=[0-4000], s=[1351-4000]}

x>2662:A
{x=[0-4000], m=[0-4000], a=[0-4000], s=[0-1350]} => px
{x=[2663-4000], m=[0-4000], a=[0-4000], s=[1351-4000]} => A
{x=[0-2662], m=[0-4000], a=[0-4000], s=[1351-4000]}

qqz
{x=[0-4000], m=[0-4000], a=[0-4000], s=[0-1350]} => px
{x=[2663-4000], m=[0-4000], a=[0-4000], s=[1351-4000]} => A
{x=[0-2662], m=[0-4000], a=[0-4000], s=[1351-4000]} => qqz
```

I'll need to cull out cases where the ranges reach 0, as I suspect that
could cause an infinite loop. After repeatedly applying the workflows to
these structures, eventually they should all reach 'A' or 'R' and I can
count the number of possibilites for those that reach 'A'.

It actually worked on the first try, I was surprised.

```
$ perl day19.pl < input 
Part 1 result: 397061
Part 2 result: 125657431183201
```
