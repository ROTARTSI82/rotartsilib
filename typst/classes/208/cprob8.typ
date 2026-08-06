#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 8")

#let dmat = math.mat.with(delim: "|")
#let txt(x) = $#x$

#problem
There does not exist any matrix $A in RR^(2 times 2)$ such that $"row"(A) = span(bmat(1;2))$ and $"null"(A) = span(bmat(3;1))$.

By the definition of span and row space, $"row"(A) = span(bmat(1;2))$ means that every row of $A$ can be written as a linear combination of $bmat(1;2)$, i.e. that $A = bmat(alpha, 2alpha;beta,2beta)$ for some $alpha, beta in RR$. However, we can calculate the null space by solving $A vec(x) = vec(0)$, decomposing $vec(x) = bdmat(x_1,x_2)^"T"$ and seeing that
$ alpha x_1 + 2 alpha x_2 &= 0 \ beta x_1 + 2 beta x_2 &= 0. $

These two equations are clearly just scalar multiples of each other, and we have that $vec(x) in "null"(A)$ if and only if $bdmat(1,2)^"T" dot vec(x) = 0$. From this, we see that $bdmat(3,1)^"T"$ is not in the nullspace of $A$ because \ $bdmat(3,1)^"T" dot bdmat(1,2)^"T" =5!=0$. Thus we have shown that $"row"(A) = span(bdmat(1,2)^"T")$ implies that\ $"null"(A) != span(bdmat(3,1)^"T")$, so such a matrix $A$ is impossible. #h(1fr) $square$


In general, the row space is the orthogonal component to the null space, and the space spanned by $bmat(1;2)$ is not orthogonal to the space spanned by $bmat(3;1)$ so no such matrix exists. 
#newpage()
#problem
To compute this determinant, we can apply #theorem[5.12]:
$ 
  &#h(2em) det(bmat(1,3,2;0,1,1;-2,0,4)^3 bmat(-5,0,3;-1,1,1;0,2,1)^(-8)) 
  = dmat(1,3,2;0,1,1;-2,0,4)^3 dmat(-5,0,3;-1,1,1;0,2,1)^(-8)
$

We can compute the two determinants by applying #theorem[5.13] (row operations) and #theorem[5.9] (determinant of a triangular matrix):

#figure(diagram(
  $
    bdmat(1,3,2;0,1,1;-2,0,4) edge(->, "rrr", idmat(R_3 <- R_3 + 2R_1)) edge(->, "rrr", txt("nop on det"), label-side: #right) & & & bdmat(1,3,2;0,1,1;0,6,8) edge(->, "rrr", R_3 <- R_3 -6R_2) edge(->, "rrr", txt("nop on det"), label-side: #right) & & & bdmat(1,3,2;0,1,1;0,0,2)
  $
))

$ dmat(1,3,2;0,1,1;-2,0,4) = dmat(1,3,2;0,1,1;0,0,2)= 2 $

#figure(diagram(
  $
    bdmat(-5,0,3;-1,1,1;0,2,1) edge(->, "rrr", idmat(R_2 <- R_2 - 1/5 R_1)) edge(->, "rrr", txt("nop on det"), label-side: #right) & & & bdmat(-5,0,3;0,1,2/5;0,2,1) edge(->, "rrr", R_3 <- R_3 -2R_2) edge(->, "rrr", txt("nop on det"), label-side: #right) & & & bdmat(-5,0,3;0,1,2/5;0,0,1/5)
  $
))

$ dmat(-5,0,3;-1,1,1;0,2,1) = dmat(-5,0,3;0,1,2/5;0,0,1/5) = -1 $

$ therefore det(bmat(1,3,2;0,1,1;-2,0,4)^3 bmat(-5,0,3;-1,1,1;0,2,1)^(-8))  = boxed(8) $

#problem
There does not exist any matrix $A in RR^(3 times 3)$ such that $det(A) != 0$ and the entries of each row of $A$ sum to 0.

All matrices $A in RR^(3 times 3)$ can be written as $A = bdmat(vec(a)_1, vec(a)_2, vec(a)_3)$ using columns $vec(a)_i in RR^3$. Then, the condition that each row sums to zero implies that $vec(a)_1 + vec(a)_2 + vec(a)_3 = vec(0)$ and that $vec(a)_1 = -vec(a)_2 -vec(a)_3$. This means that the columns of $A$ are linearly dependent, which by the unifying theorem implies that $A$ is not invertible. Thus, by #theorem[5.6], $det(A)=0$ because $A$ is not invertible. #h(1fr) $square$
