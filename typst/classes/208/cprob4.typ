#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 3")

#v(2.5em)
#problem

There does not exist any linear transformation $T : RR^2 to RR^3$ such that $ T(bdmat(1;1))=bdmat(1;0;2)," " T(bmat(0;2))=bmat(-2;2;0), " and " T(bmat(1;3))=bmat(-1;2;1). $ By linearity, all linear transformations $T$ must obey the equation
$
  T(bmat(1;1)) + T(bmat(0;2)) = T(bmat(1;3)).
$

However, the equations on $T$ would imply that
$
  bmat(1;0;2) + bmat(-2;2;0) = bmat(-1;2;2) = bmat(-1;2;1),
$

which is a contradiction. Thus, no such linear transformation $T$ can exist. #h(1fr) $square$

#align(bottom)[
#problem

There does not exist any surjective linear transformation $T: RR^4 to RR^4$ such that
$ T(bmat(1;3;0;1)) = bmat(1;1;1;1) " and " T(bmat(0;0;100;-3)) = bmat(-1;-1;-1;-1). $
 By #theorem[3.9], $T$ is surjective if and only if it is injective. However, we can show that any $T$ satisfying those equations is necessarily not injective, meaning that no such $T$ is surjective. 
 
 We show that $T$ is not injective, i.e. that $(exists vec(x), vec(y) in RR^4)(T(vec(x)) = T(vec(y)) wedge vec(x) != vec(y))$, with the explicit example \ $ vec(x) = bmat(1;3;100;-2) " and " vec(y) = bmat(0;0;0;0). $

 By the linearity of $T$, we can evaluate $T(bmat(1;3;0;1) + bmat(0;0;100;-3)) = vec(0) = T(bmat(0;0;0;0))$, but $bmat(1;3;100;-2) != bmat(0;0;0;0).$ #h(1fr) $square$
#v(4em)
]
#newpage()
#problem

There do not exist any $T_1 : RR^7 to RR^5$ and $T_2: RR^5 to RR^6$ such that $T_2 circ T_1 : RR^7 to RR^6$ is surjective. By #theorem[3.7], $T_2$ is not surjective since the dimension of the codomain is greater than the dimension of the domain. However, left-composing with a function that is not surjective always gives you a function that is also not surjective, so once we prove this we have our desired result.

/ Proposition: #[Given a function $T_2 : Y to Z$ that is *not* surjective, for all functions $T_1 : X to Y$, the function $T_2 circ T_1 : X to Z$ is also not surjective.

Proof: By the definition of surjectivity, $T_2$ not being surjective means that
$ (exists vec(z) in Z)(forall vec(y) in Y)(T_2(vec(y))!=vec(z)). $

However, since $(forall vec(x) in X)(T_1 (vec(x)) in Y)$, this also immediately implies that
$ (exists vec(z) in Z)(forall vec(x) in X)([T_2 circ T_1](vec(x)) != vec(z)), $
meaning $T_2 circ T_1$ is not surjective. #h(1fr) $square$

]
Thus, because $T_2$ is not surjective, $T_2 circ T_1$ can also never be surjective. #h(1fr) $square$