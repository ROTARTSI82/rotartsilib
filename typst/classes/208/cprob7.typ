#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 7")

#problem

For all matrices $A$ that are row equivalent to the following matrix $B$

$ A = bmat(vec(u)_1, vec(u)_2, vec(u)_3, vec(u)_4, vec(u)_5, vec(u)_6) ~ bmat(1,3,0,-1,1,1;0,0,1,2,0,1;0,0,0,1,0,2;0,0,0,0,0,0) = B, $

we have that yes, $U = {vec(u)_1, -vec(u)_3 + vec(u)_4 + vec(u)_5, vec(u)_6}$ is a a basis for $"col"(A)$. For convenience, let us define $vec(u)_C = -vec(u)_3 + vec(u)_4 + vec(u)_5$.

To show that $U$ is a basis, first let us consider if the analogous set on $B$ is a basis for $"col"(B)$. Let $vec(b)_i$ be the $i$-th column of $B$, 1-indexed from the left. Let $vec(b)_C = -vec(b)_3 + vec(b)_4 + vec(b)_5 = bdmat(0,1,1,0)^"T"$. Then, we have

#grid(h(1em), $ vec(b)_1 &= vec(b)_1 \ vec(b)_2 &= 3 vec(b)_1 \ vec(b)_3 &= 2 vec(b)_C - vec(b)_6 + vec(b)_1 $, $ vec(b)_4 &= 3 vec(b)_C - vec(b)_6 \ vec(b)_5 &= vec(b)_1 \ vec(b)_6 &= vec(b)_6. $, h(1em), columns: (0.5fr, 1fr, 1fr, 0.5fr))

Thus, we know that $"col"(B) = span {vec(b)_1, vec(b)_C, vec(b)_6}$. By #theorem[4.11], any linear dependence among the columns of $B$ also exists among the columns of $A$ (this theorem is a result of elementary row operations not changing the solution set). This means that the above equations also hold on $vec(u)_i$, and $"col"(A) = span U$.

Now, to show that $U$ is a basis, we only need to show that it is linearly independent. However, since elementary row operations act on columns independently, we are free to remove and take linear combinations of columns "on both sides" and still preserve the "row-equivalent matrices" equality relation. Thus, $A~B$ implies that $admat(vec(u)_1, vec(u)_C, vec(u)_6, vec(0)) ~ admat(vec(b)_1, vec(b)_C, vec(b)_6, vec(0))$, and since elementary row operations preserve the solution set of a system, these two systems have the same solutions. Then, by the definition of linear independence, $U$ is linearly independent if and only if ${vec(b)_1, vec(b)_C, vec(b)_6}$ is linearly independent, which we can show by row reduction and #theorem[3.6] (pivot in every column):

#figure(diagram($
  bdmat(1,0,1;0,1,1;0,1,2;0,0,0) edge(->,"rrr", idmat(R_3 <- R_3 - R_2)) & & &  bdmat(1,0,1;0,1,1;0,0,1;0,0,0).
$))

Thus, $U$ is a basis because $span U = "col"(A)$ and $U$ is linearly independent. #h(1fr) $square$

#newpage()
#problem

There does not exist any injective linear transformation $T : RR^2 to RR^3$ such that $"range"(T) = span(bdmat(1,1,1)^"T")$. We show that for all linear transformations $T:RR^2 to RR^3$, if $"range"(T) = span(bdmat(1,1,1)^"T")$, then $T$ is not injective. By the definition of rank and column space, $ "rank"(T) = dim "col"(T) = dim "range"(T) = 1, $
because ${bdmat(1,1,1)^"T"}$ is a basis for  $"range"(T)$ because it spans the space and a single nonzero vector is always linearly independent. By the rank-nullity theorem on $T$,

$ "rank"(T) + "nullity"(T) = dim RR^2 = 2, $

so we have that $"rank"(T) = 1$ and $"nullity"(T) = 1.$ By the definition of nullity and dimension, this means that there exists a basis ${vec(n)}$ for $ker T$, and $vec(n) != vec(0)$ by the definition of linear independence and basis. Thus, $T$ is not injective: we have that $T(vec(x) + vec(n)) = T(vec(x))$ by the linearity of $T$ and the fact that $vec(n) in ker T$, but $vec(x) + vec(n) != vec(x)$, contradicting injectivity. #h(1fr) $square$

#problem

$ A = bmat(1,0,-1;0,1,-1) $ is an example of such a matrix $A in RR^(2 times 3)$ such that $"col"(A) = RR^2$ and $"null"(A) = span(bdmat(1;1;1))$.

We can see that the columns of $A$ span $RR^2$, as $A vec(x) in RR^2$ for all $vec(x) in RR^3$, and for any $vec(y) in RR^2$, we have $y_1,y_2 in RR$ such that $ vec(y) = bmat(y_1;y_2) = A bmat(y_1;y_2;0). $

We can calculate the null space of $A$ by using back substitution to solve the system $A vec(x) = vec(0)$:

$
  amat(1,0,-1, 0;0,1,-1,0)                  
$

This is already a matrix in echelon form, so we can directly backsubstitute. Let $vec(x) = bdmat(x_1, x_2, x_3)^"T"$. Then $x_1 = x_2 = x_3$, and so the solution set is spanned by $bdmat(1,1,1)^"T"$. #h(1fr) $square$
