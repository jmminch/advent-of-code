# Day 10: The Stars Align

<https://adventofcode.com/2018/day/10>

For this problem, simulating the motion of the stars is trivial; the problem
is how to figure out what the ending condition should be. I need to quit
simulating when the points align to form letters, but it's not trivial to
determine that programmatically.

However, I would expect that when the points are aligned, that is either at
or near to the time when the points are closest together. I'll start with
trying to find at what time the bounding box is smallest and see if the
result looks like letters.

It works fine for the test data, so trying it for the actual input:

```
$ perl  day10.pl < input 
#####   #    #  ######  ######   ####   ######  ######  #    #
#    #  #    #  #            #  #    #  #            #  #    #
#    #  #    #  #            #  #       #            #   #  # 
#    #  #    #  #           #   #       #           #    #  # 
#####   ######  #####      #    #       #####      #      ##  
#       #    #  #         #     #       #         #       ##  
#       #    #  #        #      #       #        #       #  # 
#       #    #  #       #       #       #       #        #  # 
#       #    #  #       #       #    #  #       #       #    #
#       #    #  #       ######   ####   ######  ######  #    #

Time: 10634 sec
```
