# Day 8: Two-Factor Authentication

<https://adventofcode.com/2016/day/8>

This problem gives you a grid of pixels (all starting off), and then a set
of instructions to turn pixels on. The basic operations are turning on a
rectangular area of pixels, and rotating rows or columns.

```
$ perl day8.pl < input.txt 
Part 1 result: 110
Part 2 result:
####   ## #  # ###  #  #  ##  ###  #    #   #  ## 
   #    # #  # #  # # #  #  # #  # #    #   #   # 
  #     # #### #  # ##   #    #  # #     # #    # 
 #      # #  # ###  # #  #    ###  #      #     # 
#    #  # #  # # #  # #  #  # #    #      #  #  # 
####  ##  #  # #  # #  #  ##  #    ####   #   ##  
```
