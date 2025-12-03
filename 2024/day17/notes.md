# Day 17: Chronospatial Computer

<https://adventofcode.com/2024/day/17>

I had been wondering when we would get a VM problem this year; usually there
are a couple.

Part 1 is just to implement a simulator for the described architecture,
which is fairly easy. Part 2, however, requires analysis of the provided
program. Here is the program, annotated with what it does:

```
2,4  bst 4 => B = A % 8
1,5  bxl 5 => B = B ^ 5  (flip bits 0 and 2)
7,5  cdv 5 => C = A >> B
1,6  bxl 6 => B = B ^ 6  (flip bits 1 and 2)
0,3  adv 3 => A = A >> 3
4,1  bxc 1 => B = B ^ C
5,5  out 5 => output B
3,0  jnz 0 => jump to 0 if A is nonzero
```

Each output digit depends on the bottom bits of A -- because of the "cdv 5",
we could shift A by as much as 7 bits, so each digit of output depends on
the bottom 10 bits of A. (At first I thought that it only depended on the
bottom 6, in which case computing it manually seemed reasonable, but with
1024 possibilities that's tougher.)

What I did was build a table of the possible values of the low 10 bits of
A that produce each digit. Starting at the bottom, I try each of those
values that produces 2. Then, for the second digit, I need a value for bits
3-12 that result in 4, *and* the low 7 bits of the value match the high 7
bits of the value found for the first digit.  I keep repeating that process
for each digit until I have all the values for A that result in creating the
desired output.

There are several, so I then pick the smallest one as my answer.

After getting this working, I realized that I could be somewhat more
efficient by working from the last digit backwards instead of from the first
digit. The reason is that I'm looking for the smallest value of 'A', so if I
tried possibilities, starting from the last digit (corresponding to the MSB
of A,) and try the possibilities in ascending order, then the first result I
find should be the smallest one.

```
$ perl day17.pl input 
Part 1 result: 1,5,0,3,7,3,0,3,1
Part 2 result: 105981155568026
```
