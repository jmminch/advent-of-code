# Day 6: Trash Compactor

<https://adventofcode.com/2025/day/6>

At least for the first part, this seems to be a problem that is mostly
about parsing the input into a usable form.

At first I thought I needed to search for the full column of spaces to
locate each problem, but I realized that instead I just need to look for
numbers/strings separated by any number of spaces.

Part 2, however, would be difficult without locating the seperation line for
each problem, so I'm going to need to do that. It's probably easiest to
first identify all the seperation lines, then go back and extract the
numbers.
