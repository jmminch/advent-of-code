# Day 9: Disk Fragmenter

<https://adventofcode.com/2024/day/9>

One thing that I notice while reading this problem is that I don't really
have to build the actual list of blocks; instead I can calculate it on the
fly.

The disk map defines the layout of used and free blocks on the disk. If I
create a list of the file numbers and their sizes, then if I step through
each block, we either "fill" the disk with data from the beginning of the
list, or data from the end of the list.

For part 2, rather than working block-by-block, I want to work on the file
level. Unfortunately I can't really use any of my part 1 code. Essentially
the idea is to work from the end of the file list and try to move it to the
first space with enough free space to accomodate it.

My initial implementation was kind of slow since I started searching for a
free space from the beginning of the disk. I improved that by recording the
location where I last found a large enough spot for a file of size n, and
then using that as the starting point for the search. That speeds things up
by a factor of 50 for the given input.

```
$ perl day09.pl input 
Part 1 result: 6154342787400
Part 2 result: 6183632723350
```
