# Grappling-Hook-Example
How to grapple hook (in Godot 3.3) using Hooke's law. If you make something
with this, it'd be nice to let me know or credit me! (Calvin Wong)

![alt text](demo.png "Screenshot :)")

The equation:
F<sub>s</sub> = k<sub>s</sub> * (distance(p<sub>a</sub>, p<sub>b</sub>) - L)

This gives the force F<sub>s</sub> as a scalar (a single number), not a vector,
where distance(p<sub>a</sub>, p<sub>b</sub>) is the distance between the two ends
of the rope/spring, L is the rest length of the rope/spring, and k<sub>s</sub> is
just a customizable constant for how stiff the rope/spring is.

I also included some nice lighting, and messed with the default toon shader.
