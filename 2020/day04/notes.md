# Day 4: Passport Processing

[This problem](https://adventofcode.com/2020/day/4) is another one where the
object is to determine which records obey a set of rules. The main thing at
the beginning is that I want to find the records which are separated by
blank lines, which I know perl can do easily but I always have to look up.

I believe that by setting `$/` to `\n\n` I'll get the behavior I'm looking
for.

Other than that, the trick is just to figure out how to parse the records
into fields to make processing them simple. I opted to first generate a hash
from key to value and do my processing on that.

```
$ perl day4.pl < input.txt 
part 1 result: 208
part 2 result: 167
```

I solved this the first time around in 2020, so I went back to look at how I
did things differently. That time I split the records up manually myself
rather than using the `$/` built-in, so at least I've improved on my
knowledge of how to get the advantages I need to out of perl.
