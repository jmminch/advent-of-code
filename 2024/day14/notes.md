# Day 14: Restroom Redoubt

<https://adventofcode.com/2024/day/14>

Part 1 looks surprisingly simple: just calculate the position at time
`t=100`, based on initial position and velocity, with positions modulo the
width or height.

For part 2, unless I'm going to try to go for some fancy algorithm to try to
figure out whether the output "looks like a tree," I'm probably going to
need to just display the frames one-by-one and look at them.

If it's really "very rarely," that might be impractical; I'll have to see if
I can spot it quickly.

After looking at the first 100 positions, I don't see a tree yet, but there
were interesting configurations at t=28s and t=55s. Going further, there's a
similar configurationt to t=28s at t=131s and a similar config to t=55s at
t=156s---the period corresponds to the width and height of the board (which
makes sense since that's the modulo divisor.)

So let's figure out when those will happen at the same time. I think there's
a clever way to solve that problem, but I just counted up starting at 28 by
steps of 103 until finding a value for which (t-55) % 101 is also zero.

```
$ perl day14.pl input 
Part 1 result: 233709840
Part 2 result: 6620
```

The picture at t=6620:

```
#                                  #               ###############################                    
                                                   #                             #                    
                                                   #                             #                    
                                                   #                             #                    
                                     # #           #                             #                    
                                                   #              #              #   #                
#                                                  #             ###             #                    
                    #                              #            #####            #                    
                                                   #           #######           # #    #             
                    #                     #        #          #########          #          #         
                            #                      #            #####            #                    
                                                   #           #######           #        #           
                                                   #          #########          #     # #            
                                                   #         ###########         #             #      
              #                                    #        #############        #                 #  
        #      #                                   #          #########          #                    
          #                        #        #      #         ###########         #                    
                                                   #        #############        #                  # 
                  ##                         #     #       ###############       #      #             
            #      #   #                        #  #      #################      #      #             
                                                   #        #############        #                    
                                                   #       ###############       #                    
                                                   #      #################      # #                  
                                                 # #     ###################     #                    
                                   ##     #        #    #####################    #                    
                                                   #             ###             #                    
   #       #                                       #             ###             #                    
                                                   #             ###             #                    
                                                   #                             #                    
                                                   #                             #                    
                                                   #                             #                    
                                                 # #                             #                    
                                           #       ###############################
```
