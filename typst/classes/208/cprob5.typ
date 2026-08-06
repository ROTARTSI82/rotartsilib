#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 5")

#let def(x) = [*Definition #x*]

#problem

It is impossible to find $A in RR^(2 times 3)$ and $B in RR^(3 times 2)$ such that $B A = I_3$. By #theorem[3.2], the functions $T_A : RR^3 to RR^2$ and $T_B : RR^2 to RR^3$ defined by $T_A (vec(x)) = A vec(x)$ and $T_B (vec(x)) = B vec(x)$ are linear transformations. By #theorem[3.16], $[T_B circ T_A](vec(x)) = B A vec(x)$. Thus, the condition that $B A = I_3$ is the same as $T_B circ T_A = "Id"_(RR^3)$. However, the identity on $RR^3$ is surjective by #theorem[3.7] (pivot in every row of the identity matrix), but we can show that $T_B circ T_A$ can never be surjective, and so $T_B circ T_A$ can never be $"Id"_(RR^3)$ and $B A $ can never be equal to $I_3$.

By the same logic of problem 3 on conceptual problems 4, $T_B$ is not surjective by #theorem[3.7] (the dimension of the codomain is greather than the dimension of the domain), and the left-composition of a non-surjective function with any other function always gives you a non-surjective function. 

#box([/ Proposition: #[Given a function $T_B : Y to Z$ that is *not* surjective, for all functions $T_A : X to Y$, the function $T_B circ T_A : X to Z$ is also not surjective.

Proof: By the definition of surjectivity, $T_B$ not being surjective means that
$ (exists vec(z) in Z)(forall vec(y) in Y)(T_B (vec(y))!=vec(z)). $

However, since $(forall vec(x) in X)(T_A (vec(x)) in Y)$, this also immediately implies that
$ (exists vec(z) in Z)(forall vec(x) in X)([T_B circ T_A](vec(x)) != vec(z)), $
meaning $T_B circ T_A$ is not surjective. #h(1fr) $square$

]], stroke: 0.5pt + black, outset: (y: 1em), inset: (x: 1em))
#v(1em)

Thus, because $T_B$ is not surjective, $T_B circ T_A$ can also never be surjective, and since $"Id"_(RR^3)$ is surjective, $T_B circ T_A != "Id"_(RR^3)$ and $B A != I_3$. #h(1fr) $square$

#problem
By version 3 of the unifying theorem (#theorem[3.27]), our matrix is invertible if and only if the matrix's corresponding linear transformation is bijective. By #theorem[3.7] and #theorem[3.6], this happens when the echelon form has a pivot in every row and in every column:

#figure(diagram($
  bdmat(1,0,3;-2,x,1;4,-1,2) edge(->, "rr", imat(R_2 <- R_2 + 2 R_1;R_3 <- R_3 - 4 R_1)) & & bdmat(1,0,3;0,x,7;0,-1,-10) edge(->, "rr", imat(R_2 <- R_2 + x R_3)) & & bdmat(1,0,3;0,0,7-10x;0,-1,-10) \
  & edge(->, "r", imat(R_2 <-> R_3)) & bdmat(1,0,3;0,-1,10;0,0,7-10x) & & 
$))

Thus, we see that our matrix is invertible for $boxed(x != display(7/10))$. If $x = 7/10$, the last row and last column would be missing a pivot as the last row would be all $0$s, and so our matrix would not be invertible.



#newpage()
#problem

It is impossible to find an invertible $T_1 : RR^3 to RR^3$ and a non-invertible $T_2 : RR^3 to RR^3$ such that $T_2 circ T_1 : RR^3 to RR^3$ is invertible. Recall that the book defines invertible as being synonymous with being bijective. For all invertible $T_1$ and non-invertible $T_2$, we can prove directly that $T_2 circ T_1$ is not invertible.

Because $T_2$ is a map from $RR^3$ to $RR^3$, it is bijective if and only if it is surjective by #theorem[3.9]. Thus, $T_2$ being non-invertible means it is not surjective. Thus, our claim again reduces to this proposition:

#box([/ Proposition: #[Given a function $T_2 : Y to Z$ that is *not* surjective, for all functions $T_1 : X to Y$, the function $T_2 circ T_1 : X to Z$ is also not surjective.

Proof: By the definition of surjectivity, $T_2$ not being surjective means that
$ (exists vec(z) in Z)(forall vec(y) in Y)(T_2 (vec(y))!=vec(z)). $

However, since $(forall vec(x) in X)(T_1 (vec(x)) in Y)$, this also immediately implies that
$ (exists vec(z) in Z)(forall vec(x) in X)([T_2 circ T_1](vec(x)) != vec(z)), $
meaning $T_2 circ T_1$ is not surjective. #h(1fr) $square$

]], stroke: 0.5pt + black, outset: (y: 1em), inset: (x: 1em))

#v(1em)
Thus, because $T_2 circ T_1$ is not surjective, it is not bijective and thus not invertible.
#h(1fr)$square $