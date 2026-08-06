#import "template.typ": *



Let $omega$ be a $k$-form, and let $vec(v)_i in V$ be vectors.

$ "Alt"(omega)(vec(v)_1,dots,vec(v)_n) = 1/k! sum_(sigma in S_k) "sgn"(sigma)omega(vec(v)_(sigma(1)),dots,vec(v)_(sigma(n))). $

This turns any tensor into an alternating one, and iff $omega$ is already alternating, $"Alt"(omega) = omega$.

We can define the wedge product of a $k$-form $omega$ and an $l$-form $eta$ to be

$ omega wedge eta = (k+l)!/(k!l!) "Alt"(omega otimes eta). $

The factor in front is just a convention so we end up with a determinant. We can calculate that this gives correct results for stuff, for example with $d x wedge d y$ (where $d x$ and $d y$ are the basis covectors):

#let dx = $d x$
#let dy = $d y$
#let dz = $d z$

$
  [d x wedge d y](vec(u), vec(v)) = 2 [1/2 d x(vec(u)) d y(vec(v)) - 1/2 d y(vec(u)) d x(vec(v))]. 
$

$
  [dx wedge dy &wedge dz](vec(u), vec(v), vec(w))
  
  \ = 6/2[
  &+ 1/6 dx(vec(u)) [dy(vec(v)) dz(vec(w)) - dz(vec(v)) dy(vec(w))] \ &+  1/6 dx(vec(v)) [dy(vec(w)) dz(vec(u)) - dz(vec(w)) dy(vec(u))] \ &+ 1/6 dx(vec(w)) [dy(vec(u)) dz(vec(v))- dz(vec(u)) dy(vec(v))] \
  &- 1/6 dx(vec(w)) [dy(vec(v)) dz(vec(u))-dz(vec(v)) dy(vec(u))] \ &-  1/6dx(vec(u)) [dy(vec(w)) dz(vec(v)) - dz(vec(w))dy(vec(v))] \ &-  1/6 dx(vec(v)) [dy(vec(u)) dz(vec(w))- dz(vec(u)) dy(vec(w))]]
  \ = det&(vec(u),vec(v),vec(w)).
$

This is kinda like expansion by minors? not really.