# Day 5: If You Give A Seed A Fertilizer

<https://adventofcode.com/2023/day/5>

For this problem, we need to map the seed number to the location number,
which involves working your way through various "maps" -- essentially
functions to convert from one category to another.

A couple assumptions to make:

- First, I assume that we can get from seed number to location by only going
  "forward" through the maps. Theoretically we could probably do the reverse
  (say, if instead of a seed-to-soil map we had a soil-to-seed map.)
  However, because of the way the maps are defined, the reverse of a map is
  likely not to be one-to-one, and so if you had a soil-to-seed map it would
  be possible for a single seed value to map to multiple soil values.

- Second, I assume that each item is only the source for a single map. It
  would be possible to have something like an input with a seed-to-soil and
  also seed-to-fertilizer map, and then you'd have to determine which of
  them you need to use to eventually get a location value. Looking at the
  example and actual input, it appears that's not the case for this problem,
  though.

For the first part I want to find the minimum "location" value for any of
the input "seed" values. So I will create a function that determines the
associated location value for a given seed value, and work my way through
the seeds.

The maps will be stored in a hash like:

```
$maps{<source>}->{dest} = <destination category>
$maps{<source>}->{map} = [ [ <dest #>, <source #>, <range length> ], ... ]
```

So we just repeatedly apply the maps until we end up with a location.

Parsing the input isn't too hard; it's probably going to be easiest to slurp
the entire input into a string and then use regexes to grab the sections
that I want. I'll have to look up how to use regexes on a multiple-line
string, since that's something I always forget how to handle.

```
$ perl  day05.pl < input.txt 
Part 1 result: 31599214
```

Part 2 is repeating part one, but where the "seed" values define ranges of
seeds rather than individual seed IDs.

Looks like the ranges are large (hundreds of millions,) which could make
simply iterating through them impractical, but I'm going to try doing it
that way first anyway.

I left it to run a while, and after ten minutes it still didn't have a
solution, so obviously the naive way isn't good enough.

What I may do to solve it is to have the "apply map" function take an input
range of values, and then return (possibly multiple) output ranges of
values. That way I can process large numbers of inputs at once. I could also
do some logic to coelesce multiple ranges into one if they are
adjacent/overlapping, although I suspect that doing so isn't actually
necessary. I'll tackle doing that tomorrow.

```
$ perl  day05.pl < input.txt 
Part 1 result: 31599214
Part 2 result: 20358599
```

It ran fast enough without making any attempt to coalesce adjoining ranges.
I'm not terribly happy with my implementation of the "apply map"
function--it's pretty ugly--but it does work.
