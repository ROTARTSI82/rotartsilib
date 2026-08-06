#import "/typst/misc/template.typ": *

#show: hw.with(title: "MATH 208 A: Conceptual Problems 1")

#problem
There does not exist a linear system of 2 equations in 3 variables with exactly one solution. If such a system did exist, it would have to be consistent (otherwise it would have 0 solutions), and by the definition of a leading variable, the number of leading variables must be less than or equal to the number of equations (2). However, in order to have exactly one solution, the number of leading variables must equal the total number of variables (3) so that there are no free variables and one is able to put the system into a triangular form. Thus, it is impossible to have exactly one solution in such a system, as in a consistent system we are always left with at least one free variable, leading to infinitely many solutions. $square$ // #footnote[#theorem[1.3], that linear systems have 0, 1, or infinite solutions, is implicitly applied for this problem.]

#problem
$x_1+x_2-x_3=0$ is an example of such a linear equation. We can verify this by plugging in our test cases:
$
bmat(0, 0, 0)^T  &arrow 0 + 0 - 0 = 0 " " checkmark \
bmat(1, 0, 1)^T &arrow 1+0-1=0 " " checkmark \
bmat(1, -1, 0)^T &arrow 1+(-1)-0=0 " " checkmark  \
bmat(0, 3, -3)^T &arrow 0+3-(-3) != 0 " " checkmark
$

A single linear equation with nonzero coefficients is automatically a consistent system in echelon form, and it has one leading variable and two free variables. Thus, the solution set is a plane, and since three non-collinear points define a unique plane, we were able to find a linear equation with the desired solution points. /* by computing the normal vector with $bmat(1;0;1) times bmat(1;-1;0)= bmat(1;1;-1)$.*/ The fourth point that must not be a solution does not lie on the plane, so our linear system has all the desired properties. $square$

/ Bonus: Because we must always have two free parameters to form a plane containing the 3 desired solution points, we cannot add any leading variables (because doing so will necessarily remove one of the two free variables) when we add new equations for systems with 2 or 3 equations. Thus, although we can find linear systems with more equations that satisfy the desired properties, all equations must be essentially the same equation, all being scalar multiples of $x_1 + x_2 - x_3 = 0$ with at least one nonzero instance.

#pagebreak()
#problem
We can apply #theorem("1.6"), that all matrices have a unique reduced row echelon form (which can be found by Gauss-Jordan elimination). Since the reduced row echelon form is invariant under equivalency, this implies that two matrices are equivalent (can be transformed into each other via elementary operations) if and only if they have the same reduced row echelon form. After putting our initial matrix into reduced row echelon form using Gauss-Jordan elimination, however, it is already trivial to transform the reduced echelon form matrix into the target matrix.

$
amat(
    -1, 0, 1, 0;
    0, 1, 0, 2;
    0, 4, -1, 1
  )
$
$ R_3 arrow.l R_3 -4R_2 $
$
amat(
    -1, 0, 1, 0;
    0, 1, 0, 2;
    0, 0, -1, -7
  )
$
$ R_1 arrow.l R_1 + R_3 $
$
amat(
    -1, 0, 0, -7;
    0, 1, 0, 2;
    0, 0, -1, -7
  )
$
$ R_1 arrow.l -R_1 $
$ R_3 arrow.l -R_3 $
$
amat(
    1, 0, 0, 7;
    0, 1, 0, 2;
    0, 0, 1, 7
)
$
$ R_3 arrow.l R_3 + 2R_2 $
$
amat(
    1, 0, 0, 7;
    0, 1, 0, 2;
    0, 2, 1, 11
)
$
$ square $

#pagebreak()
#problem

#figure(diagram($
  T M edge("d", d f, ->) edge(pi, ->) & M edge("d", f, ->, label-side: #left) \
  T N edge(pi, ->) & N
$), caption: [The projection map as a natural transformation $pi : T arrow bold(1_"Diff")$.])

#figure(diagram($
  "Source" edge("rrr", text("Channel"), ->) & & & "Destination" 
$))


$ 
integral f(x) d x = boxed([a l d / 2]^(5/3) ) .
$

Lorem ipsum #fbox[abc def]. askdjf
