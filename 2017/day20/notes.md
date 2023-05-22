# Day 20: Particle Swarm

<https://adventofcode.com/2017/day/20>

Hey, it's a physics simulation! We're given a set of particles with starting
position, velocity, and (constant) acceleration vectors, and asked two
questions:

1. Which particle will be closest (Manhattan distance) to the origin as
   t --\> infinity?
2. If we remove all particles that collide while being simulated, how many
   will remain?

Since this is constant acceleration, the particles will follow parabolic (or
linear) paths. As t gets very large, the t^2 term will dominate, and so the
particle that stays closest to the origin will have the smallest
acceleration.

There could be multiple particles with acceleration of the same magnitude.
For those, if I figure out the time when they are moving in their final
directions (so t=-v/a), and then find which of them is closest to the origin
after that time, that particle should stay the closest forever.

For part 2, I'll use the same method to determine my maximum time to
simulate. I can make one pass through the particle list to update
position/velocity, a second one to record all positions in a hash and note
which positions are common (indicating a collision), and then a last pass to
remove any particles from the list that collided.

```
$ perl day20.pl < input.txt 
Part 1 result: 243
Part 2 result: 648
```
