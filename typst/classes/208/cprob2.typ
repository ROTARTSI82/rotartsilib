#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 2")

#problem

This is impossible: for all linearly dependent vectors $vec(u), vec(v) in RR^3$, the vectors $vec(u)$ and $vec(u) + vec(v)$ must also be linearly dependent. 

By the definition of linear dependence, there exists $alpha, beta in RR$ such that either $alpha != 0$ or $beta != 0$, and $alpha vec(u) + beta vec(v) = vec(0)$. We will show that $vec(u)$ and $vec(u) + vec(v)$ must be linearly dependent because there exists $gamma, lambda in RR$ such that either $gamma != 0$ or $lambda != 0$, and $gamma vec(u) + lambda (vec(u) + vec(v)) = vec(0)$. Consider two cases:

/*+ $alpha = 0$: This implies that $beta != 0$ and thus that $vec(v) = vec(0)$, so we need to show that $cal(S) = {vec(u), vec(u)}$ is linearly dependent. We can note that $1 dot vec(u) + (-1) dot vec(u) = vec(0)$ is a non-trivial solution, so $cal(S)$ is linearly dependent.*/
+ $beta = 0$: This implies that $alpha != 0$ and thus that $vec(u) = vec(0)$, so we need to show that $cal(S) = {vec(0), vec(v)}$ is linearly dependent. By #theorem[2.13], however, $cal(S)$ is linearly dependent because $vec(0) in cal(S)$.
+ $beta != 0$: Let $lambda = beta$ and $gamma = alpha - beta$. Then $lambda != 0$, and
  $ gamma vec(u) + lambda (vec(u) + vec(v)) &= (alpha - beta) vec(u) +beta (vec(u) + vec(v)) \
  &= alpha vec(u) + beta vec(v) \
  &= vec(0)  &square
   $




/*By #theorem[2.15], the set $cal(S) = {vec(a), vec(b)}$ is linearly dependent if and only if there exists a vector \ $vec(c) in cal(S)$ such that $vec(c) in span(cal(S) \\ {vec(c)})$. Because our set has only two elements, without loss of generality we may assume that $vec(c) = vec(a)$. Thus, the theorem reduces to the statement that \ $vec(a) in span {vec(b)}$, which by the definition of span implies that there exists $alpha in RR$ such that $vec(a) = alpha vec(b)$. We have shown that any linearly dependent set of vectors $cal(S) = {vec(a), vec(b)}$, we can write $cal(S) = {alpha vec(b), vec(b)}$ for some $alpha in RR$.

 $vec(u) + vec(v)$ can be rewritten as $(alpha + 1)vec(u)$, and we must only show that $(alpha +1) vec(u)$ and $vec(u)$ are linearly dependent. However, we have $1 dot [(alpha + 1) vec(u)] + (-alpha - 1)dot vec(u) = vec(0)$, so by the definition of linear depdence, our vectors $vec(u)$ and $vec(u) + vec(v)$ are linearly dependent since there exists a non-trivial linear combination for $vec(0)$. #h(1fr) $square$*/

#problem

It is impossible to find a matrix equivalent to $bdmat(1,0,0,-1; 0,1,0,1; 0,0,1,0)$ such that the first, second, and fourth columns are linearly independent. 

From the definition of elementary row operation, we can see that every operation acts on each column indepdently, so applying operations to a matrix and reading a column is the same as applying the same operations to the column by itself. We do not care about the third column of our matrix, so we are free to change its value and reorder the columns. Thus, our problem is equivalent to finding a matrix $B ~ admat(vec(c)_1, vec(c)_2, vec(c)_4, vec(0))$ such that the first three columns of $B$ are linearly independent, where $vec(c)_n$ is the $n$th column of our original matrix. 

By the same argument that row operations act on columns independently, we know that all matrices $B$ equivalent to the desired matrix must have $vec(0)$ as their rightmost column, in other words that every $B$ can be written as $B = admat(vec(v)_1, vec(v)_2, vec(v)_3, vec(0))$ for some vectors $vec(v)_1, vec(v)_2, vec(v)_3 in RR^3$. By #theorem[2.17], we know that ${vec(v)_1, vec(v)_2, vec(v)_3}$ is linearly dependent if there exists a non-trivial solution to the system described by $B$. From the in-class theorem, elementary row operations do not change the solution set of a linear system, so $B$ must have the same solutions as $admat(vec(c)_1, vec(c)_2, vec(c)_4, vec(0))$. However, that system does have a nontrivial solution given by $vec(c)_1 - vec(c)_2 + vec(c)_4 = vec(0)$, implying that for all equivalent matrices $B$, the set of vectors ${vec(v)_1, vec(v)_2, vec(v)_3}$ will have the same non-trivial combination for $vec(0)$ and thus will always be linearly dependent. #h(1fr) $square$

#newpage()

#problem

#h(1em)

#figure(diagram($
  bdmat(1,0,1,-1; 0,1,1,1; 0,0,0,0) edge("rrr", imat(R_3 arrow.l R_3 + R_1;)
  ,"->") &&& bdmat(1,0,1,-1;0,1,1,1;1,0,1,-1)
$))

The vector $bdmat(1;0;1)$ is in the span of the columns of the matrix because

$
  bdmat(1,0,1,-1;0,1,1,1;1,0,1,-1) bdmat(1;0;0;0) = bdmat(1;0;1). #h(8em) square
$
