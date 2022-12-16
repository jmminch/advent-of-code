# Day 5: Doesn't He Have Intern-Elves For This?

Determine if strings are "naughty" or "nice" based on three rules:

1. It contains at least three vowels (aeiou only), like aei, xazegov, or
   aeiouaeiouaeiou.
2. It contains at least one letter that appears twice in a row, like xx,
   abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
3. It does not contain the strings ab, cd, pq, or xy, even if they are part
   of one of the other requirements.

I'll use regular expressions for each of these.

```
$ perl day5.pl < input.txt 
part 1 result: 236
```

Part 2 changes the rules, but regular expressions still work for all of
them.

1. It contains a pair of any two letters that appears at least twice in the
   string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not
   like aaa (aa, but it overlaps).

2. It contains at least one letter which repeats with exactly one letter
   between them, like xyx, abcdefeghi (efe), or even aaa.

```
$ perl day5.pl < input.txt 
part 1 result: 236
part 2 result: 51
```
