# Day 14: One-Time Pad

<https://adventofcode.com/2016/day/14>

In this problem, you need to find numbers `n` that have the property:

* `MD5(salt + n)`, in hex, contains a string of 3 repeated digits
* In the next 1000 values for n, `MD5(salt + n)` contains the same digit
  repeated 5 times.

I'll use the Digest::MD5 module, as in day 5.

The second part is to run the resulting hash back through the MD5 algorithms
an extra 2016 times, which will make it take much longer.

The main thing that I see for optimization is to cache the result of
calculating the hashes, so that once I've figured out the next 1000 hashes
to process one value of n, I don't need to repeat those.

I spent a while debugging my code for this; it turned out that I missed part
of the instructions: "Only consider the first such triplet in a hash." I was
looking at all triplets in the hash, so more indexes were being validated
than should have been.

```
$ time perl day14.pl 
Part 1 result: 15168
Part 2 result: 20864

real	0m9.940s
user	0m9.890s
sys	0m0.016s
```
