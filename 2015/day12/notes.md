# Day 12: JSAbacusFramework.io

The input for [today](https://adventofcode.com/2015/day/12) is a JSON
document. While perl has a JSON module, the first question is just to find
the sum of all the numbers in the document. Since they specify that the
strings don't contain numbers, I don't have to look at the structure of the
document at all -- just find any numbers in the strings and add them.

```
$ perl day12.pl < input.txt 
part 1 result: 119433
```

Part 2 requires looking at the structure of the document and ignoring any
object with a property value of "red". So this will require parsing the
JSON.

The JSON module decodes a json string to a perl object; then I can write a
recursive function to find the sum for the object by looking at the sum of
its children; returning '0' for any object that has a property 'red'.

```
$ perl day12.pl < input.txt 
part 1 result: 119433
part 2 result: 68466
```
