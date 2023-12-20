# Day 20: Pulse Propagation

<https://adventofcode.com/2023/day/20>

Given the description and names of some of these "modules" I kind of wonder
if these could be reduced to a physical circuit with various logic gates,
but there is probably a lot of nuance there.

Since pulses are handled in the order that they're sent, I'll have a queue
of pulses to process. Handling a pulse will increment the counter for
low/high pulses (to solve part 1) and then update the module state and send
more pulses appropriately.

Because conjunction modules need to know the source of an incoming pulse,
the elements on the pulse queue will look like `[target, source, pulse
type]`.

As usual, I'll represent the circuit as a hash with the keys being the names
of the modules. Each module will be a hash with a `type` field containing
the prefix for the type (if any) and an `output` field with a list of
connected outputs; flip-flop modules will have a `state` field with the
current state; conjunction modules will have a `inputs` field with a hash of
all connected inputs and their states.

While working through the implementation, it occurs to me that theoretically
you might be able to build something like:

```
a -> b, b
&b -> a
```

So `b` would have two distinct inputs from `a`, which would probably have to
be handled uniquely. It doesn't look at first glance like that happens in
the input, so for now I won't; however, maybe the thing to do would be for
the signal structure to carry information about which output it was from and
not simply which module.

Part 2 is to figure out how long it takes to deliver a low pulse to a
particular module. This sounds kind of reminiscent of prior years where
we had to simulate a simple virtual machine, but solving the second part of
the problem required some clever manipulation. That might be required here
too -- I imagine that these circuits could probably build some sort of adder
that takes a very long time to cycle.

But to start out, I'll just play it straight and try to simulate it to
completion.

After several minutes, the simulation is still running, so I'll need to be
more clever. First, I'll print out the state after each button press so I
can look at how the different elements evolve over time.

`&ll` is connected to `rx`, so we'll get a low pulse to `rx` when all inputs
to &ll are high. Watching the state of `&ll`, there are 4 inputs, all of
which stay low for a significant amount of time.

`&ll`s inputs are four other conjunction modules, `&kl`, `&vm`, `&kv`,
`&vb`. All of those have 1 input each which is consistently high.

`&kl` comes from `&ff`, another conjunction module. `&ff` has 8 inputs. So
we'll end up getting a high input to `&ll` when all inputs to `&ff` are
high, resulting in a low pulse to `&kl`.

It looks like `&ff` may be a counter. Its inputs are 8 different flip-flops.
Of them, `&zz` toggles every putton press. `&rs` toggles once every 4 button
presses. `&sq` toggles once every 8 button presses.

Looking closer, though, looks like it's not as simple as I originally
thought. `&vd` flips every 256 presses 15 times, but then flips again after
just 77 presses; and repeats that pattern. `&mb` flips every 512 presses 7
times, then flips after 333 presses. `&ld` flips every 1024 presses 3 times,
then after 845 presses. It turns out that 3917 is a magic number here... all
three of these, at least, do a flip on button press 3917, regardless of
where it is in the pattern. It's still an open question whether that is
consistent, though, or if there it's just the start of a larger pattern for
those.

Looking at all the inputs to ff, it looks like they all normally flip-flop
at an interval that's a power of 2, but once every 3917 button presses we
invert all of them and continue from there. The inputs aren't every single
power of 2: instead they are 1, 4, 8, 64, 256, 512, 1024, and 2048.

So if I was going to try simulating this to figure out on which button press
ff would emit a low pulse, I could have a counter that increments, and check
if the appropriate bits are set; inverting the counter every 3917 steps. If
I did my attempt right (day20-ff.pl), then I'd expect all of those inputs to
be on after button press 7656.

After following this path for a while, I don't think this is going to get me
to a solution. Doing some experimentation, it looks like a lot of these
inputs actually flip multiple times per button press, and so looking at the
state after each button press probably isn't helpful since it could end up
sending the pulse I'm looking for at any point.

Taking another approach, now, looking at `&ll`. It looks like `&vb` turns on
for a moment every 3793 steps. `&vm` turns on once every 4051 steps. `&kv`
turns on once every 4013 steps, and `&kl` turns on once every 3917 steps
(so there's that once-every-3917 steps pattern I saw before). The LCM of
those is 241,528,184,647,003, and that is indeed the answer.

This is one of those problems that you can get the right answer, but mostly
just because the problem was built to lead you (eventually) to what was
going on.
