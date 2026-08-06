#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 9")

#let dmat = math.mat.with(delim: "|")
#let ddmat = compose(math.display, dmat)
#let txt(x) = $#x$

#problem

The "averaging" linear transformation is given by $T(vec(x)) = display(1/3) bdmat(1,1,1;1,1,1;1,1,1) vec(x) = 1/3 A vec(x)$. We can instead calculate the eigensystem for the "sum up coords" linear transformation $A$ and add the factor of $1/3$ later since scaling is bijective. Calculating eigenvalues by cofactor expansion down the first column:

$ ddmat(1-lambda,1,1;1,1-lambda,1;1,1,1-lambda) &= (1-lambda) ddmat(1-lambda,1;1,1-lambda) - ddmat(1,1;1,1-lambda) + ddmat(1,1;1-lambda,1) \ &= (1-lambda)^3 - (1-lambda)-(1-lambda)+1+1-(1-lambda) \ &= 1-3lambda+3lambda^2-lambda^3-3(1-lambda)+2 \ &= 3lambda^2 -lambda^3 = lambda^2 (3-lambda) = 0 $


$lambda = 3$ eigenspace ($lambda = 1$ for "average" transformation): Solving $(A - 3 I) vec(x) = vec(0)$

#figure(diagram(
  $ 
    admat(-2,1,1,0;1,-2,1,0;1,1,-2,0) edge(->, "rr", imat(R_2 <-R_2 + 1/2 R_1;R_3 <-R_3 + 1/2 R_1)) & & admat(-2,1,1,0;0,-3/2,3/2,0;0,3/2,-3/2,0) edge(->, "rr", imat(R_3 <-R_3+R_2;R_2<-2/3 R_2))& & admat(-2,1,1,0;0,-1,1,0;0,0,0,0)
  $
))

The solution set is $x_1=x_2=x_3$. This means that for all $vec(v) in span {bmat(1;1;1)}$, the averaging linear transformation does nothing: $T(vec(v)) = vec(v)$. This makes sense: if all the entries are the same already, averaging does nothing.

$lambda = 0$ (for both "sum up" and "average") eigenspace: Find $"null"(A)$:

#figure(diagram(
  $
    admat(1,1,1,0;1,1,1,0;1,1,1,0) edge(->, "rr", imat(R_2 <- R_2 - R_1; R_3 <- R_3 - R_1)) & & admat(1,1,1,0;0,0,0,0;0,0,0,0)
  $
))

The solution set is $x_1 + x_2 + x_3 = 0$, so for all $vec(v) in span {bmat(-1;1;0),bmat(-1;0;1)}$ we have that $T(vec(v)) = vec(0)$. This corresponds to the case of the average of the three coordinates being $0$, and this is a 2-dimensional space: after choosing the value of one coordinate, the other two must sum up to its negative.


#problem
It is impossible to find such a vector $vec(v) in RR^3$ and matrix $A in RR^(3 times 3)$. If $vec(v) != vec(0)$ and $A vec(v)=vec(v)$, then\ $A-I_3$ is not invertible. We can rewrite $A vec(v) = vec(v)$ as $A vec(v) = I_3 vec(v)$ which implies $(A-I_3) vec(v) = vec(0)$. Then, $A-I_3$ is not invertible because $vec(v) in ker(A-I_3)$ and $vec(v) != vec(0)$, but by the unifying theorem, $A-I_3$ is invertible if and only if $ker(A-I_3) = {vec(0)}$. #h(1fr) $square$

#newpage()
#problem
$A = bdmat(4,1;3,2)$ has eigenvalues $lambda = 5$ and $lambda = 1$ with the eigenspaces $E_5(A) = span{bmat(1;1)}$ and $E_1(A) = span{bmat(1;-3)}$. We can find the eigenvalues and eigenspaces of $A^(-4)$ by applying the following propositions:

#let iff = math.arrow.l.r.double.long
Let $M$ be an invertible square matrix. If $M$ has eigenvector $vec(u)$ with eigenvalue $lambda$ (and $lambda != 0$ by the invertibility of $M$), then
+ #[$M^(-1)$ has eigenvector $vec(u)$ with eigenvalue $lambda^(-1)$. $ M vec(u)=lambda vec(u) implies M^(-1) vec(u)=lambda^(-1) vec(u). $
Proof: we left-multiply by $M^(-1)$ and apply linearity:
$ M^(-1) M vec(u) &= M^(-1) lambda vec(u) \
 vec(u) &= lambda M^(-1) vec(u) \ lambda^(-1) vec(u) &= M^(-1) vec(u). $
]

+ #[$M^2$ has eigenvector $vec(u)$ with eigenvalue $lambda^2$. $ M vec(u) = lambda vec(u) implies M^2 vec(u) = lambda^2 vec(u). $
Proof: we just left-multiply by $M$ and apply linearity: $ M M vec(u) &= M lambda vec(u) \ M^2 vec(u) &= lambda M vec(u) = lambda^2 vec(u). $]

We know $A$ is invertible, and inverses and powers of invertible matrices are invertible. Thus, we can write $A^(-4) = ((A^(-1))^2)^2$ and see that $lambda = 5^(-4)$ and $lambda= 1$ must be eigenvalues of $A^(-4)$ with eigenspaces $E_(5^(-4))(A^(-4)) supset.eq span {bmat(1;1)}$ and $E_1(A^(-4)) supset.eq span{bmat(1;-3)}$. However, we can show that ${bmat(1;-3),bmat(1;1)}$ is a basis for $RR^2$, so we must not be missing any eigenvalues/eigenvectors of $A^(-4)$, and in fact $E_(5^(-4))(A^(-4)) = span {bmat(1;1)}$ and $E_1(A^(-4)) = span{bmat(1;-3)}$:

#figure(diagram(
  $
    bdmat(1,1;-3,1) edge(->, "rr", imat(R_2<-R_2 +3R_1)) & & bdmat(1,1;0,4)
  $
))
We have a pivot in every row and column, so the vectors are linearly independent and span $RR^2$ by the unifying theorem. There must not be any additional eigenvalues because it is impossible to have more than 2 linearly independent vectors in $RR^2$ and #theorem[6.10] stipulates that eigenvectors for distinct eigenvalues must be linearly independent. The eigenspaces also cannot be any bigger, because if a second linearly independent eigenvector did exist in either eigenspace, then that space would include all of $RR^2$, meaning that the two eigenspaces would overlap on some nonzero vector. This is a contradiction as a single vector cannot have two distinct eigenvalues.


Ok, only after writing this cursed argument did I realize I could've just diagonalized, sorry.