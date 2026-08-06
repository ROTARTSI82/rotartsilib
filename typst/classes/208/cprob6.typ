#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 6")

#problem

Given
$ A = bmat(1,0,0; 0,1,0; 0,0,1/2), " " B = bmat(0,1,0; 0,0,2; 0,0,0), " and" C = bmat(0,3,0; 0,0,-2; 5,0,0), $
we can find $X in RR^(3 times 3)$ such that $(B+X)A=C$ by calculating $X=C A^(-1)-B$ by the properties of matrix multiplication/adition and the inverse. We know $A$ is bijective and thus invertible because it is an echelon form square matrix with pivots in every row/column. We can calculate $A^(-1)$ by Gaussian elimination:

#let cmat = bdmat.with(augment: (vline: 3, stroke: (dash: "dotted")))
#figure(diagram(
    $
    admat(A,I_3)=
      cmat(1,0,0,1,0,0;0,1,0,0,1,0;0,0,1/2,0,0,1)
      edge(->, "rr", idmat(R_3 <- 2 R_3))  & &
      cmat(1,0,0,1,0,0;0,1,0,0,1,0;0,0,1,0,0,2) = admat(I_3,A^(-1)).
    $
))

Then, we can compute $X$ by carrying out the matrix multiplication and addition:

$ X &= bmat(0,3,0;0,0,-2;5,0,0) bmat(1,0,0;0,1,0;0,0,2) - bmat(0,1,0;0,0,2;0,0,0) \ 
&= bmat(0,3,0;0,0,-4;5,0,0)-bmat(0,1,0;0,0,2;0,0,0) = bmat(0,2,0;0,0,-6;5,0,0). $

#v(1em)
#problem

$ A = bmat(0,-1;1,0) $ is an example of a non-diagonal $2 times 2$ matrix such that $A^4 = I_2$. One can verify this by doing the matrix multiplication.

$ A^4 = (A^2)^2 = bmat(-1,0;0,-1)^2 = I_2. $

Geometrically, this matrix takes $bold(hat(x))$ to $bold(hat(y))$ and it takes $bold(hat(y))$ to $-bold(hat(x))$, resulting in a $90^circ$ counterclockwise rotation. Since a $360^circ$ rotation is the identity and it takes four $90^circ$ rotations to reach $360^circ$, it follows that $A^4 = I_2$. Additionally, since $A^2 = - I_2$, one can interpret $A$ as being a representation of the imaginary unit $i$.

#newpage()
#problem
There are three linearly independent vectors that span the subspace $S subset RR^4$ given by
$ S = {bmat(x_1;x_2;x_3;x_4) in RR^4 : bmat(x_1 + x_2; x_4) in span(bmat(1;3))}. $

Expanding the definition of span, this means that $S$ is precisely the set of $RR^4$ vectors whose coordinates satisfy the following system of equations for some $alpha in RR$:

$ x_1 + x_2 &= alpha \ x_4&=3 alpha. $

However, since we have 4 variables and 2 equations, we are left with 2 free parameters. We can set $x_1 = beta$ and $x_3 = gamma$ to obtain a solution set $x_1 = beta$, $x_2 = alpha - beta$, $x_3 = gamma$, and $x_4 = 3 alpha$, and $S$ is precisely this solution set:

$ S = { alpha bmat(0;1;0;3) + beta bmat(1;-1;0;0) + gamma bmat(0;0;1;0) : alpha,beta,gamma in RR}. $

Thus, we have found three vectors that span $S$, and we can show that they are linearly independent by #theorem[3.6] (the echelon form having a pivot in every column):

#figure(diagram($
    bdmat(0,1,0;1,-1,0;0,0,1;3,0,0) edge(->, "rrr", idmat(R_2 <- R_2 -1/3 R_4; R_2 <- R_2 + R_1)) &  && bdmat(0,1,0;0,0,0;0,0,1;3,0,0) edge(->, "rr", idmat("swap"; "rows")) & & bdmat(3,0,0;0,1,0;0,0,1;0,0,0).
$))