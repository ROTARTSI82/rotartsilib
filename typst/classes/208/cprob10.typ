#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 10")

#let dmat = math.mat.with(delim: "|")
#let txt(x) = $#x$

#problem
Given a matrix $A in RR^(3 times 3)$ with eigenspaces

$
  E_1(A) = span {bmat(1;2;3)}, " " E_2(A) = span {bmat(0;-1;1)}, " " E_(10)(A) = span {bmat(1;1;1)},
$

the matrix must be diagonalizable because it is a 3 by 3 matrix with 3 distinct real eigenvalues. We can write $A = P D P^(-1)$ where the columns of $P$ are eigenvectors and the entries in the diagonal matrix $D$ are the corresponding eigenvalues. Thus,
$
  A &= bmat(1,0,1;2,-1,1;3,1,1)bmat(1,0,0;0,2,0;0,0,10) bmat(1,0,1;2,-1,1;3,1,1)^(-1) \
  &= bmat(1,0,10;2,-2,10;3,2,10)bmat(1,0,1;2,-1,1;3,1,1)^(-1)
$

#let cmat = bdmat.with(augment: (vline: 3, stroke: (dash: "dotted")))
Computing the inverse using Gaussian elimination:
#figure(diagram(
  $
    cmat(1,0,1,1,0,0;2,-1,1,0,1,0;3,1,1,0,0,1) edge(->, "rr", imat(R_2 <- R_2 - 2R_1; R_3 <- R_3 - 3 R_1)) & & cmat(1,0,1,1,0,0;0,-1,-1,-2,1,0;0,1,-2,-3,0,1) edge(->, "rr", imat(R_3 <- R_3 + R_2;R_2<- #h(1mm) -R_2)) & & cmat(1,0,1,1,0,0;0,1,1,2,-1,0;0,0,-3,-5,1,1) \
    edge(->, R_3 <- #h(1mm) -1/3 R_3) & & cmat(1,0,1,1,0,0;0,1,1,2,-1,0;0,0,1,5/3,-1/3,-1/3) edge(->, "rr", imat(R_1 <- R_1 - R_3;R_2 <- R_2-R_3)) & & cmat(1,0,0,-2/3,1/3,1/3;0,1,0,1/3,-2/3,1/3;0,0,1,5/3,-1/3,-1/3)
  $
))
Factoring out the $1/3$ and evaluating $A$:

$
  A = 1/3 bmat(1,0,10;2,-2,10;3,2,10) bmat(-2,1,1;1,-2,1;5,-1,-1) = 1/3 bmat(48,-9,-9; 44,-4,-10;46,-11,-5) = bmat(16,-3,-3;44/3,-4/3,-10/3;46/3,-11/3,-5/3)
$

#newpage()
#problem

We can diagonalize $A = bmat(4,1;3,2) = P D P^(-1)$ by finding its eigensystem. Solving $det(A - lambda I_2) = 0$: 
$
  dmat(4-lambda,1;3,2-lambda) = (4-lambda)(2-lambda)-3=lambda^2- 6lambda +5 = (lambda-5)(lambda-1) = 0.
$

$lambda = 5$: Solving the system for $(A-5I_2)vec(x)=vec(0)$:

#figure(diagram(
$
  admat(-1,1,0;3,-3,0) edge(->, "rr", imat(R_2 <- R_2 + 3 R_1)) & & admat(-1,1,0;0,0,0)
$
))

The solution set is $x_1 = x_2$ and thus $E_5(A) = span {bmat(1;1)}$.

#[
#set par(first-line-indent: 0em)
$lambda = 1$: Solving the system for $(A-I_2) vec(x) = vec(0)$:
#figure(diagram(
$
  admat(3,1,0;3,1,0) edge(->, "rr", imat(R_2 <- R_2 - R_1)) & & admat(3,1,0;0,0,0)
$
))

The solution set is $-3x_1 = x_2$ and thus $E_1(A)= span{bmat(1;-3)}$.
]

Thus, we have $P= bmat(1,1;1,-3)$ and $D= bmat(5,0;0,1)$ and $A=P D P^(-1)$. We can directly evaluate the expression $A^1000 = P D^1000 P^(-1)$ by first calculating $P^(-1)$ using Gaussian elimination:

#let c2mat = bdmat.with(augment: (vline: 2, stroke: (dash: "dotted")))
#figure(diagram(
  $
    c2mat(1,1,1,0;1,-3,0,1) edge(->, "rr", imat(R_2 <- R_2 - R_1)) & & c2mat(1,1,1,0;0,-4,-1,1) edge(->, "rr", imat(R_2 <- -1/4 R_2)) & & c2mat(1,1,1,0;0,1,1/4, -1/4) edge(->, "rr", imat(R_1 <- R_1 - R_2)) & & c2mat(1,0,3/4,1/4;0,1,1/4,-1/4)
  $
))

Then we can factor out the $1/4$ and take the power of a diagonal matrix:
$
  A^1000 &= 1/4 bmat(1,1;1,-3)bmat(5^1000,0;0,1) bmat(3,1;1,-1) \
  &= 1/4 bmat(1,1;1,-3) bmat(3 dot 5^1000, 5^1000;1,-1) \
  &= 1/4 bmat(3 dot 5^1000+1, 5^1000 - 1;3 dot 5^1000 - 3,  5^1000 + 3)
$

Huh it's kind of funny that those are all integers.


#problem

It is impossible to find a matrix $A in RR^(3 times 3)$ such that $A$ is diagonalizable but $A - I_3$ is not. We can show that for all matrices $A$, $A-I_3$ is diagonalizable if $A$ is diagonalizable. 

By the definition of diagonalization, there exist both an invertible matrix $P in RR^(3 times 3)$ and a diagonal matrix $D in RR^(3 times 3)$ such that $A = P D P^(-1)$. Additionally, we have that $I_3 = P I_3 P^(-1)$ by the definitions of inverses and identities. Thus,
$
  A-I_3 &= P D P^(-1)-P I_3 P^(-1) \
   &= P(D - I_3) P^(-1)
$

Note that because $D$ and $I_3$ are both diagonal, $D-I_3$ must also be diagonal. Thus, we have diagonalized $A - I_3$, showing that a diagonalizable $A$ implies a diagonalizable $A - I_3$. #h(1fr) $square$

