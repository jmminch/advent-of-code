# Day 3: Mull It Over

<https://adventofcode.com/2024/day/3>

At least for the first part, this looks like a simple job for a regex.
The input is several very long lines, so I need to iterate through each line
and then look at each regex match on the line.

For the second part, we also need to match either do() or don't() in the
input. This is also pretty simple; I just need to use $& (which I always
have to look up) to tell which string I matched.

```
$ perl day03.pl < input 
Part 1 result: 166630675
Part 2 result: 93465710
```

While it doesn't matter much, I later realized that the code can be
simplified by getting rid of anything between a `don't()` and a `do()`;
then the exact same counting logic can be used for part 1 and part 2.
There's a couple little tricks to doing that: I need to treat the whole
input as a single line, and use the `/s` modifier to the substitution regex
so that the replacements can cross over a new line; also, for correctness, I
can't just remove the entire substring, as otherwise something like this
would give the wrong answer:

```
mul(do() blahblah don't()1,2)
```

It turns out that the input data doesn't have anything like that. In any
case, that version is in day03-2.pl.
