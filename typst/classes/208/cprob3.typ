#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 3")

#problem


Yes, $T$ is one-to-one. By #theorem[3.9] (unifying theorem version 2), a linear map $T: RR^n to RR^n$ is injective if and only if it is surjective. By linearity, we have that for all $alpha,beta,gamma,lambda in RR$,

$
  T(alpha bmat(1;2;3;4) + beta bmat(0;2;100;-1) + gamma bmat(1;1;1;1) + lambda bmat(1;-3;0;29) ) = bmat(alpha;beta;gamma;lambda).
$

Clearly, $T$ is surjective and thus injective (i.e. bijective). #h(1fr) $square$

#problem

The identity transformation $T(vec(x)) = bdmat(1,0,0;0,1,0;0,0,1) vec(x)$ is an example of such a transformation. The set of vectors is linearly dependent because there exists a non-trivial solution to reach $vec(0)$:

$
  -1 dot T(bmat(1;0;1)) + 1 dot T(bmat(1;1;0)) + 1 dot T(bmat(0;-1;1)) = vec(0).
$

The identity is obviously surjective and linear (#theorem[3.7]). #h(1fr) $square$

#newpage()
#problem

This is impossible. First, let us show that the original vectors are linearly independent:

#figure(diagram($
 admat(1,0,0,0;0,2,0,0;1,1,1,0) edge("rr", R_2 arrow.l 1/2R_2, ->) 
  & &
  admat(1,0,0,0;0,1,0,0;1,1,1,0)
  edge("rr", idmat(R_3 arrow.l R_3 -R_1;R_3 arrow.l R_3 - R_2), ->) & &
  admat(1,0,0,0;0,1,0,0;0,0,1,0).
$))

#let map = $T_cal(S)$
Clearly, the trivial solution is the only solution, so our set of vectors is linearly independent by #theorem[2.17]. Since $T$ is to be a surjective map from $RR^n$ to $RR^n$, it must also be injective by #theorem[3.9]. However, we can prove that in general, all injective linear maps $T : RR^n to RR^p$ (with $p >= n$) take linearly independent sets to linearly independent sets, making a map with the desired properties impossible. 

/ Proposition 0: #[ Given a set of linearly independent vectors ${vec(v)_1,dots,vec(v)_m}$ and an injective linear map $T$, the set of vectors ${T(vec(v)_1), dots,T(vec(v)_m)}$ is also linearly independent.

Proof: Assume for contradiction that ${T(vec(v)_1),dots,T(vec(v)_m)}$ is linearly dependent. By the definition of linear dependence, this means that there exist some reals $x_i$ such that $sum x_i T(vec(v)_i) = vec(0)$ and $exists i in NN,x_i != 0.$ By linearity, however, we can rewrite this as $T(sum x_i vec(v)_i) = T(vec(0))$, and by the injectivity of $T$, we know that $sum x_i vec(v)_i = vec(0)$. However, this contradicts our setup as it implies that ${vec(v)_1,dots,vec(v)_m}$ is linearly dependent too! Thus, our original assumption was false, and ${T(vec(v)_1), dots, T(vec(v)_m)}$ is linearly independent. #h(1fr) $square$
]
$ square $
Actually that was just a direct proof of the contrapositive oops.

#v(4em)

#align(center, [== _Silly Alternate Proof for Problem 3 for fun_])

Let $cal(S) = {vec(v)_1, dots, vec(v)_m}$ be a set of vectors $vec(v)_i in RR^n$ and $map : RR^m to RR^n$ (with $m = |cal(S)|$) be the _corresponding linear map_ defined by $map(vec(x)) = A_cal(S) vec(x)$ where $A_cal(S) = bdmat(vec(v)_1, dots, vec(v)_m)$.

/ Proposition 1: #[A finite set of vectors $cal(S) subset RR^n$ is linearly indepdendent if and only if its _corresponding map_ $map : RR^m to RR^n$ is injective.

Proof: By #theorem[2.17], the system $A_cal(S) vec(x) = vec(0)$ has only the trivial solution $vec(x) = vec(0)$ if and only if $cal(S)$ is linearly independent. However, since $map(vec(x)) = A_cal(S) vec(x)$, having only the trivial solution is equivalent to $ker map = {vec(0)}$, which by #theorem[3.5] is equivalent to the statement that $map$ is injective. #h(1fr) $square$
]

Let the set $cal(S)' subset RR^p$ be the result of applying the linear map $T : RR^n to RR^p$ elementwise such that $cal(S)' = {T(vec(v)_1), dots, T(vec(v)_m)}$. Let its _corresponding linear map_  be $T_cal(S)' : RR^m to RR^p$ defined in the same way. Then, $T_cal(S)' = T circ map$ because by #theorem[3.8], $T$ can be written as $T(vec(x)) = A vec(x)$ for some \ $A in RR^(p times n)$, and we can show that by #theorem[3.16],

$
  [T circ T_cal(S)] (vec(x)) &= A bmat(vec(v)_1,dots,vec(v)_m) vec(x) \
   &= bmat(A vec(v)_1, dots, A vec(v)_m) vec(x) \
   &= bmat(T(vec(v)_1), dots, T(vec(v)_m)) vec(x) \
   [T circ T_cal(S)](vec(x)) &= T_cal(S)'(vec(x)).
$

  Our original problem was to find a surjective (and thus also injective) $T : RR^n to RR^n$ such that we have a linearly _dependent_ $cal(S)'$ for the given linearly independent $cal(S)$. However, we can prove that such a map $T$ is impossible: in the given setup, both $T$ and $T_cal(S)$ are injective, but we can show that the composition of two injective maps is injective, so $T_cal(S)'$ must be injective and $cal(S)'$ must be linearly _independent_ by *Proposition 1*.

/ Proposition 2: #[The composition of injective linear maps is injective (and linear).

Proof: We already know linearity from #theorem[3.16], so we just need injectivity. \ Let $T:RR^n to RR^p$ and $T_cal(S) : RR^m to RR^n$ be injective maps, and let $T_cal(S)' : RR^m to RR^p$ be given by  $T_cal(S)' = T circ T_cal(S)$. We want to show that $forall vec(x), vec(y) in RR^m$, $T_cal(S)'(vec(x)) = T_cal(S)'(vec(y)) implies vec(x) = vec(y)$. 

$T(T_cal(S)(vec(x))) = T(T_cal(S)(vec(y)))$ implies $T_cal(S)(vec(x)) = T_cal(S)(vec(y))$ by the injectivity of $T$, which immediately implies that $vec(x) = vec(y)$ by the injectivity of $T_cal(S)$.#h(1fr)   $square$
]

$ square $

