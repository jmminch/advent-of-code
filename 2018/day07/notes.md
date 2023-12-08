# Day 7: The Sum of Its Parts

<https://adventofcode.com/2018/day/7>

I would like to represent the graph of requirements

Given the example graph:

```
  -->A--->B--
 /    \      \
C      -->D----->E
 \           /
  ---->F-----
```

We would start with 'C' ready to process, 'A' waiting on 'C', etc. When any
step completes, then remove that step from things that are waiting on it,
and anything that is waiting on nothing gets moved to the 'ready to process'
queue.

Part one is a special case of part two, where there is only one worker. So I
can just implement the part two logic and run it with one worker to get the
part one answer.

```
$ perl day07.pl < input 
Part 1 result: MNOUBYITKXZFHQRJDASGCPEVWL
Part 2 result: 893
```
