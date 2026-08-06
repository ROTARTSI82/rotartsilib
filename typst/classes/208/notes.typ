#import "/typst/misc/template.typ" : *
#set enum(indent: 1em)
#set list(indent: 1em)

#let chaptno = state("chaptno", "null")

#let chapter(num, title, body) = {
  newpage()
  chaptno.update(_ => num)
  [== #num #title
  #grid(columns: (0.5em, auto), box(), body)
  ]
}
#let section(sub, title, body) = context [
  === #(chaptno.get()).#sub #title
  #grid(columns: (0.5em, auto), box(), body)
]

#set page(
  paper: "us-letter",
  margin: (x: 4em)
)

#let null = $ "null" $
#let range = $ "range" $
#let bcal = compose(math.bold, math.cal)
#let rep(sym, up: $m$) = $sym_1,dots,sym_up$
#let vecs = compose(rep, vec)
#let row = $ "row" $
#let col = $ "col" $
#let rank = $ "rank" $
#show link: underline

= Math 208 Notes
#today() \
Grant Yang #h(1em) #link("https://students.washington.edu/granty29") 


#outline()

#chapter[1][Systems of Linear Equations][
#section[1][Lines and Linear Equations][
  #def[1.1][System of Linear Equations]
  #def[Triangular Form][
    1. Every variable is the leading variable of exactly one equation.
    2. \# of equations = \# of variables
    3. There is exactly 1 solution]
  #def[1.2][Echelon form, Echelon system
    1. Every variable is the leading variable in _at most one_ equation.]

  #deftheorem[1.3][Every system of linear equations either has no solutions, exactly one solution, or infinitely many solutions.]
]

#section[2][Matrices][
  #deftheorem[Class][*Elementary row operations* do not change the solution set.
      + Swap two rows
      + Multiply by a nonzero constant
      + Add a scalar multiple of one row to another]

  #def[1.4][A matrix is in *echelon form* if 
    1. Every leading term is strictly to the left of the leading term in the row below.
    2. All zero rows are at the bottom of the matrix.]

  #def[1.5][A matrix is in *reduced row echelon form* if
    1. It is in echelon form
    2. All *pivot positions* (entries that are leading) contain a 1.
    3. There is only 1 nonzero entry in each *pivot column*.]

  #deftheorem[1.6][All matrices have a unique reduced row echelon form under equivalency.]
]

 
  #deftheorem[1A][A consistent system in echelon form has infinitely many solutions if and only if there is at least one free variable.]

  #deftheorem[1B][Given a consistent system in echelon form, the number of leading variables is at most the number of equations.]

  #deftheorem[1C][Elementary row operations preserve the solution set of a linear system.]

  #deftheorem[1D][Let $A$ and $B$ be matrices and $A_i$ and $B_i$ be obtained by deleting the $i$th column of $A$ and $B$ respectively. Then any sequence of row operations that takes $A$ to $B$ also takes $A_i$ to $B_i$.]
]

#chapter[2][Euclidean Space][
#section[1][Vectors][
#def[2.1][Vectors are elements of $RR^n$, a n-tuple of real numbers.]
#def[2.2][Addition and scalar multiplication are defined on vectors.]

#deftheorem[2.3][
Definition of Vector Space
  1. $vec(u) + vec(v) = vec(v) + vec(u)$
  2. $alpha (vec(u) + vec(v)) = alpha vec(u) + alpha vec(v)$
  3. $(alpha + beta)vec(u) = alpha vec(u) + beta vec(u)$
  4. $( vec(u) +  vec(v)) +  vec(w) =  vec(u) + ( vec(v) +  vec(w))$
  5. $ alpha( beta  vec(u)) = ( alpha  beta) vec(u)$
  6. $ vec(u) + (- vec(u)) =  vec(0)$
  7. $ vec(u) +  vec(0) =  vec(0) +  vec(u) =  vec(u)$
  8. $1 vec(u) =  vec(u)$
]

#def[2.4][A *linear combination* of vectors $vec(u)_1, vec(u)_2, dots$ is a weighted sum $sum x_i vec(u)_i$ where $x_i in RR$.]
]

#section[2][Span][
#def[2.5][The *span* of a collection of vectors $vec(u)_i in RR^n$ is defined as
$ &span {vec(u)_1,dots,vec(u)_m} = \ &#h(4em) {x_1 vec(u)_1 + dots + x_m vec(u)_m : x_1, dots, x_m in RR} subset.eq RR^n $]

#deftheorem[2.6][Let $vec(w), vec(u)_i in RR^n$. We have that $vec(w) in span {vec(u)_1,dots,vec(u)_m}$ if and only if the system $ amat(vec(u)_1, dots, vec(u)_m, vec(w)) $ has at least one solution.]

#deftheorem[2.7][Let $cal(S) subset RR^n$ be a finite set of vectors and $vec(w) in RR^n$. Then $span({vec(w)} union cal(S)) = span cal(S)$ if and only if $vec(w) in span cal(S)$.]

#deftheorem[2.8][Let $A = bdmat(vec(u)_1, dots, vec(u)_m) ~ B $ where $~$ is equivalence by elementary operations and $B$ is a matrix in echelon form. Then $span {vec(u)_1, dots, vec(u)_m} = RR^n$ if and only if $B$ has a pivot position in every row.]

#deftheorem[2.9][Let $cal(S) = {vec(u)_1, dots, vec(u)_m}$ where $vec(u)_i in RR^n$. If $m < n$, then $span cal(S) != RR^n$. If $n >= n$, $cal(S)$ may or may not span $RR^n$.]

#def[2.10][Matrix multiplication: $A vec(x) = sum x_i vec(a)_i$ for $A = bdmat(vec(a)_1,dots,vec(a)_m)$ and $vec(x) = bdmat(x_1,dots,x_m)^T$.]

#deftheorem[2.11][Let $vec(b), vec(a)_i in RR^n$. The following statements are equivalent:
  + $vec(b) in span {vec(a)_1,dots,vec(a)_m}$
  + The equation $sum x_i vec(a)_i = vec(b)$ has at least one solution.
  + The linear system $admat(vec(a)_1, dots, vec(a)_m, vec(b))$ has at least one solution.
  + The equation $A vec(x) = vec(b)$ has at least one solution, \ where $A = bdmat(vec(a)_1,dots,vec(a)_m)$ and $vec(x) = bdmat(x_1, dots, x_m)^T$.]

#def[2.12][
  Let $vec(u)_i in RR^n$ and $x_i in RR$. The set ${vec(u)_1,dots,vec(u)_m}$ is *linearly independent* if and only if the equation $sum x_i vec(u)_i = vec(0) $ has exactly one solution (the trivial solution given by $forall i, x_i = 0$). If any nontrivial solution exists, then the set is *linearly dependent*.
]
]

#section[3][Linear Independence][
#deftheorem[2.13][
  If $cal(S) subset RR^n$ is a finite set of vectors and $vec(0) in cal(S)$, then $cal(S)$ is linearly dependent.
]

#deftheorem[2.14][If $cal(S) subset RR^n$ is a finite set of vectors and $|cal(S)| > n$, then $cal(S)$ is linearly dependent.]

#deftheorem[2.15][Let $cal(S) subset RR^n$ be a finite set of vectors. $cal(S)$ is linearly
dependent if and only if $ (exists vec(u) in cal(S))[vec(u) in span(cal(S)\\ {vec(u)}) ]. $]

#deftheorem[2.16][
  Let $cal(S) = {vec(u)_i} subset RR^n$ be a finite set of vectors and $A = bdmat(vec(u)_1, dots, vec(u)_m) ~ B$ where $B$ is a matrix in echelon form. Then a) $span cal(S) = RR^n$ if and only if $B$ has a pivot position in every row, and b) $cal(S)$ is linearly independent if and only if $B$ has a pivot position in every column.
]

#deftheorem[2.17][
  For all $A = bdmat(vec(a)_1, dots, vec(a)_m)$ with $vec(a)_i in RR^n$, the set ${vec(a)_1, dots, vec(a)_m}$ is linearly independent if and only if the homogenous linear system $A vec(x) = vec(0)$ has only the trivial solution $vec(x) = vec(0) in RR^m$.
]

#deftheorem[2.18][
  For all matrices $A :RR^m arrow RR^n$ and vectors $vec(x), vec(y) in RR^m$,
  + $A(vec(x)+vec(y)) = A vec(x) + A vec(y)$.
  + $A(vec(x) - vec(y)) = A vec(x) - A vec(y)$.
]

#deftheorem[2.19][
  Given a fixed $vec(x)_p$, a *particular solution* to the system $A vec(x) = vec(b)$, a *general solution* can be written as $vec(x)_g = vec(x)_p + vec(x)_h$ where $vec(x)_h$ is a solution to the homogenous equation $A vec(x) = vec(0)$.
]

#deftheorem[2.20][
  Let $vec(a)_i in RR^n$. The following statements are equivalent:
  + The set ${vec(a)_1, dots, vec(a)_m}$ is linearly independent.
  + For all $vec(b) in RR^n$, the equation $sum x_i vec(a)_i = vec(b)$ with $x_i in RR$ has at most one solution.
  + For all $vec(b) in RR^n$, the system $admat(vec(a)_1, dots, vec(a)_m, vec(b))$ has at most one solution.
  + Let $A = bdmat(vec(a)_1, dots, vec(a)_m)$. For all $vec(b) in RR^n$, the equation $A vec(x) = vec(b)$ has at most one solution in $vec(x) in RR^m$.
]

#deftheorem[2.21 - Unifying 1][
  Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. The following statements are equivalent:
  + $span cal(S) = RR^n$.
  + $cal(S)$ is linearly independent. 
  + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
]
]]

#chapter[3][Matrices][

#section[1][Linear Transformations][

#def[3.1][
  A function $T : RR^m arrow RR^n$ is a *linear transformation* when for all $vec(u), vec(v) in RR^m$ and $r in RR$,
  + $T(vec(u)+ vec(v)) = T(vec(u)) + T(vec(v))$
  + $T(r vec(u)) = r T(vec(u))$
]

#deftheorem[3.2][
  Let $A$ be a $n times m$ matrix ($n$ rows and $m$ columns), and let $T(vec(x)) = A vec(x)$. Then $T : RR^m arrow RR^n$ is a linear transformation.
]

#deftheorem[3.3][
  Let $A = bdmat(vec(a)_1, dots, vec(a)_m)$ be a $n times m$ matrix, and let $T : RR^m arrow RR^n$ be the associated linear transformation. Then
  + A vector $vec(w) in RR^n$ is in the range of $T$ if and only if $A vec(x) = vec(w)$ is a consistent linear system.
  + $serif("range")(T) = span {vec(a)_1,dots,vec(a)_m}.$
]

#def[3.4][
  Let $T : RR^m to RR^n$ be a linear transformation.
  + $T$ is *one-to-one* or *injective* if for all $vec(w) in RR^n$, there exists _at most_ one $vec(u) in RR^m$ such that $T(vec(u)) = vec(w)$.
    - *Alternative*: $T$ is injective if $(forall vec(u),vec(v) in RR^m)[T(vec(u)) = T(vec(v)) implies vec(u) = vec(v)]$.
  + $T$ is *onto* or *surjective* if $(forall vec(w) in RR^n)(exists vec(u) in RR^m)[T(vec(u)) = vec(w)]$.
]

#deftheorem[3.5][
  A linear transformation $T$ is injective if and only if $ker T = {vec(0)}$ (the only solution to $T(vec(x)) = vec(0)$ is the trivial one).
]

#deftheorem[3.6][
  Let $A in RR^(n times m)$ and let $T : RR^m to RR^n$ be the corresponding transformation. 
  + $T$ is injective if and only if the columns of $A$ are linearly independent.
  + If $A ~ B$ and $B$ is a matrix in echelon form, $T$ is injective if and only if $B$ has a pivot in every column.
  + If $n < m$, then $T$ is not injective.
]

#deftheorem[3.7][
  Let $A in RR^(n times m)$ and let $T : RR^m to RR^n$ be the corresponding transformation. 
  + $T$ is surjective if and only if the columns span the codomain $RR^n$.
  + If $A ~ B$ and $B$ is a matrix in echelon form, $T$ is surjective if and only if $B$ has a pivot in every row.
  + If $n > m$, then $T$ is not surjective.
]

#deftheorem[3.8][
  A function $T : RR^m to RR^n$ is a linear transformation
  if and only if it can be written as $T(vec(x)) = A vec(x)$ for some $A in RR^(n times m)$.
]

#deftheorem[3.9 - Unifying 2][
  Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
  + $span cal(S) = RR^n$.
  + $cal(S)$ is linearly independent. 
  + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
  + $T$ is surjective.
  + $T$ is injective.
]

]

#section[2][Matrix Algebra][

  #def[3.10][Addition and scalar multiplication are defined on matrices.]
  #deftheorem[3.11][ For all matrices in $RR^(n times m)$,
    + $A + B = B + A$
    + $s(A + B) = s A + s B$
    + $(s + t)A = s A + t A$
    + $(A + B) + C = A + (B + C)$
    + $(s t)A=s(t A)$
    + $A + 0_(n times m) = A$
  ]

  #def[3.12][Matrix multiplication works such that for $A in RR^(n times k)$ and $B = [vec(b)_1, dots, vec(b)_m] in RR^(k times m)$, $A B = [A vec(b)_1, dots, A vec(b)_m] in RR^(n times m)$. $A B$ exists iff \# columns of A = \# columns of B.]

  #deftheorem[3.13][
    Properties of Matrix Multiplication
      + $A (B C) = (A B) C$
      + $A(B + C) = A B + A C$
      + $(A + B) C = A C + B C$
      + $s(A B) = (s A)B = A (s B)$
      + $A I = A$
      + $I A = A$
  ]

  #deftheorem[3.14][
    + It is possible that $A B != B A$.
    + $A B = 0 arrow.r.double.not A = 0 or B = 0$
    + $A C = B C arrow.r.double.not A = B or C = 0$
  ]

  #deftheorem[3.15][
    + $(A + B)^T = A^T + B^T$
    + $(s A)^T = s A^T$
    + $(A C)^T = C^T A^T$
  ]

  #deftheorem[3.16][Let $S(vec(x)) = B vec(x)$ and $T(vec(y)) = A vec(y)$ be linear transforms. Then $W(vec(x)) = T(S(vec(x))) = A B vec(x).$]

#let vdots = math.dots.v

  #deftheorem[3.17][If $A in RR^(n times n)$ is a diagonal matrix, then $forall k in RR$ (but rn we only define on $k in NN$) we have $ A^k = bmat(a_(11)^k, 0, dots, 0; 0, a_(22)^k, dots, 0; vdots, vdots, dots.down, vdots; 0, 0, dots, a_(n n)^k) $]


  #deftheorem[3.18][
    Let $A in RR^(n times n)$ be upper (lower) triangular. Then $forall k$, $A^k$ is also upper (lower) triangular.
  ]

  #def[3.19][If we perform a single elementary row operation on an identity matrix $I_n$, then the result is called an *elementary matrix*.]

  
]

#section[3][Inverses][

  #def[3.20][A transformation $T: RR^m to RR^n$ is *invertible* if it is bijective. The *inverse* $T^(-1) : RR^n to RR^m$ is given by $T^(-1)(vec(y)) = vec(x) " iff " T(vec(x)) = vec(y)$. ]

  #deftheorem[3.21][For all linear transformations $T : RR^m to RR^n$,
   + $m = n$ is a necessary (but not sufficient) condition for $T$ being invertible.
   + If $T$ is invertible, $T^(-1)$ is also a linear transformation.
  ]

  #def[3.22][A matrix $A in RR^(n times n)$ is invertible if there exists $B in RR^(n times n)$ such that $A B = I_n$.]

  #deftheorem[3.23][Suppose $A in RR^(n times n)$ is invertible with $A B = I_n$. Then $B A = A B = I_n$ and $B in RR^(n times n)$ is unique.]

  #def[3.24][If $A in RR^(n times n)$ is invertible, $A^(-1) in RR^(n times n)$ is the *inverse* of $A$, the unique matrix such that $A A^(-1) = A^(-1) A = I_n$.]

  #deftheorem[3.25][Let $A,B in RR^(n times n)$ be invertible, and let $C, D in RR^(n times m)$.
    + $A^(-1)$ is invertible, with $(A^(-1))^(-1) = A.$
    + $A B$ is invertible, with $(A B)^(-1) = B^(-1) A^(-1)$.
    + $A C = A D implies C = D$.
    + $A C = bold(0)_(n times m) implies C = bold(0)_(n times m)$.
  ]

  #deftheorem[3.26][Let $A in RR^(n times n)$. The following statements are equivalent:
    + $A$ is invertible
    + $A vec(x) = vec(b)$ has exactly one solution for all $vec(b)$ with $vec(x) = A^(-1) vec(b)$.
    + $A vec(x) = vec(0)$ has only the trivial solution $vec(x) = vec(0)$.
  ]

  #deftheorem[3.27 - Unifying 3][
    Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
  + $span cal(S) = RR^n$.
  + $cal(S)$ is linearly independent. 
  + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
  + $T$ is surjective.
  + $T$ is injective.
  + $A$ is invertible.
  ]
]

  #deftheorem[3A][Given $T: RR^m to RR^n$, we have $ sum c_i T(vec(v)_i) = T(sum c_i vec(v)_i)$]
  #deftheorem[3B][Given $T: RR^m to RR^n$ and a linearly dependent set ${rep(vec(v), up: i)}$, the set ${T(vec(v)_1),dots,T(vec(v)_i)}$ is also lienarly dependent.]
  #deftheorem[3C][Given injective $T: RR^m to RR^n$ and a linearly independent set ${rep(vec(v), up: i)}$, the set ${T(vec(v)_1),dots,T(vec(v)_i)}$ is also lienarly independent.]

  #def[3D][A linear transformation $T : RR^m to RR^n$ is surjective if $T(RR^m) = RR^n$ (image equal to codomain).]

]


#chapter[4][Subspaces][
  #section[1][Intro][
    #def[4.1][$S subset.eq RR^n$ is a *subspace* if
    + $vec(0) in S$
    + $forall (vec(u), vec(v) in S), vec(u) + vec(v) in S$
    + $forall (r in RR, vec(u) in S), r vec(u) in S$
    ]

    #deftheorem[4.2][Let $S subset.eq RR^n$ be $S = span {vec(u)_1, dots, vec(u)_m}$ for a finite family of $vec(u)_i$s. Then $S$ is a subspace of $RR^n$. ]

    #deftheorem[4.3][For all $A in RR^(n times m)$, $null A$ is a subspace of $RR^m$, where $null A$ is the solution set to $A vec(x) = vec(0)$.]

    #def[4.4][The *null space* $null(A) subset.eq RR^m$ is the solution set to $A vec(x) = vec(0)$ for $A in RR^(n times m)$. ]

    #deftheorem[4.5][Let $T : RR^m to RR^n$ be a linear transformation. Then $ker(T)$ is a subspace of $RR^m$ and $range(T)$ is a subspace of $RR^n$.]

    #deftheorem[4.6][Let $T : RR^m to RR^n$ be a linear transformation. $T$ is injective if and only if $ker(T) = {vec(0)}$.]

    #deftheorem[4.7 - Unifying 4][Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
      + $span cal(S) = RR^n$.
      + $cal(S)$ is linearly independent. 
      + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
      + $T$ is surjective.
      + $T$ is injective.
      + $A$ is invertible.
      + $ker(T) = {vec(0)}$.]
  ]

  #section[2][Basis and Dimension][
    #def[4.8][The set $bcal(B) = {vec(u)_1, dots, vec(u)_m} subset.eq S$ is a basis for a subspace $S$ if
      + $span bcal(B) = S$.
      + $bcal(B)$ is linearly independent
    ]
    #deftheorem[4.9][Let $bcal(B) = {vecs(u)}$ be a basis for $S$. For all $vec(s) in S$, there exists a _unique_ set of scalars $rep(s)$ such that $vec(s) = s_1 vec(u)_1 + dots + s_m vec(u)_m$.]

    #deftheorem[4.10][Let $A,B in RR^(n times m)$. If $A ~ B$, then $row(A) = row(B)$.]

    #deftheorem[4.11][Let $U = [vecs(u)]$ and $V = [vecs(v)]$, and $U ~ V$. Then any linear dependence that exists in $U$ also exists in $V$.]

    #deftheorem[4.12][If $S$ is a subspace of $RR^n$, then every basis of $S$ has the same number of vectors.]

    #def[4.13][The *dimension* of $S$ is the number of vectors in any basis for $S$.]

    #deftheorem[4.14][Let $cal(U) = {vecs(u)}$ be a set of vectors in a subspace $S != 0$ of $RR^n$.
      + If $cal(U)$ is linearly independent, then either $cal(U)$ is a basis for $S$ or additional vectors can be added to $cal(U)$ to form a basis for $S$.
      + If $span cal(U) = S$, then $cal(U)$ is either a basis, or vectors can be removed from $cal(U)$ to form a basis.
    ]

    #deftheorem[4.15][Let $cal(U) = {vecs(u)} subset.eq S$ and $|U| = m = dim S$. If $cal(U)$ is linearly independent, or if $span U = S$, then $cal(U)$ is a basis for $S$.]

    #deftheorem[4.16][Suppose $S_1, S_2 subset.eq RR^n$ are subspaces and $S_1 subset.eq S_2$. Then $dim(S_1) <= dim(S_2)$, and $dim(S_1) = dim(S_2)$ if and only if $S_1 = S_2$.]

    #deftheorem[4.17][Let $S$ be a subspace with $dim(S) = k$, and let $cal(U) = {vecs(u)} subset.eq S$.
    + If $m < k$, then $span cal(U) != S$.
    + If $m > k$, then $cal(U)$ is not linearly independent.
    ]

    #deftheorem[4.18 - Unifying 5][Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
      + $span cal(S) = RR^n$.
      + $cal(S)$ is linearly independent. 
      + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
      + $T$ is surjective.
      + $T$ is injective.
      + $A$ is invertible.
      + $ker(T) = {vec(0)}$.
      + $cal(S)$ is a basis for $RR^n$.]
  ]

  #section[3][Row and Column Spaces][
    #def[4.19][Let $A in RR^(n times m)$.
      + The *row space* $row(A)$ is the subspace of $RR^m$ spanned by the row vectors of $A$.
      + The *column space* $col(A)$ is the subspace of $RR^n$ spanned by the column vectors of $A$.
    ]

    #deftheorem[4.20][Let $A in RR^(n times m)$ and let $B ~ A$ be an echelon form of $A$.
      + The nonzero rows of $B$ form a basis for $row(A)$.
      + The columns of $A$ corresponding to pivot columns in $B$ form a basis for $col(A)$.]

    #deftheorem[4.21][For all $A in RR^(n times m)$, $rank(A) = dim row(A) = dim col(A)$.]

    #def[4.22][The *rank* $rank(A)$ of a matrix is the dimension of the row and column spaces.]

    #deftheorem[4.23 - Rank Nullity][
      For all $A in RR^(n times m)$, the *nullity* is defined as $ "nullity"(A) = dim null(A)$, and 
      $ rank A + "nullity" A = dim RR^m = m $
    ]

    #deftheorem[4.24][Let $A in RR^(n times m)$ and $vec(b) in RR^n$.
    + The system $A vec(x) = vec(b)$ is consistent if and only if $vec(b) in col(A)$.
    + The system $A vec(x) = vec(b)$ has a unique solution if and only if $vec(b) in col(A)$ and the columns of $A$ are linearly independent.]

    #deftheorem[4.25 - Unifying 6][Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
      + $span cal(S) = RR^n$.
      + $cal(S)$ is linearly independent. 
      + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
      + $T$ is surjective.
      + $T$ is injective.
      + $A$ is invertible.
      + $ker(T) = {vec(0)}$.
      + $cal(S)$ is a basis for $RR^n$.
      + $col(A) = RR^n$.
      + $row(A) = RR^n$.
      + $rank(A) = n$.]
  ]

  #section[4][Change of Basis][
    #deftheorem[4.26][Let $bcal(S)$ be the standard basis and let $bcal(B) = {rep(vec(u), up: n)}$ be any basis for $RR^n$. If $U = [rep(vec(u), up: n)]$, then for all $vec(x) in RR^n$,
      + $[vec(x)]_bcal(S) = U [vec(x)]_bcal(B)$
      + $[vec(x)]_bcal(B) = U^(-1) [vec(x)]_bcal(S)$]

    #deftheorem[4.27][Let $bcal(B)_1 = rep(vec(u), up: n)$ and $bcal(B)_2 = rep(vec(v), up:n)$ be bases for $RR^n$. If $U = [rep(vec(u), up:n)]$ and $V = [rep(vec(v), up:n)]$, then for all $vec(x) in RR^n$,
      + $[vec(x)]_bcal(B)_2 = V^(-1) U [vec(x)]_bcal(B)_1$
      + $[vec(x)]_bcal(B)_1 = U^(-1) V [vec(x)]_bcal(B)_2$]

    #deftheorem[4.28][Let $S$ be a subspace of $RR^n$ and let $bcal(B)_1 = {vecs(u)}$ and $bcal(B)_2 = {vecs(v)}$ be bases for $S$. If $ C = [[vec(u)_1]_bcal(B)_2, dots, [vec(u)_m]_bcal(B)_2] $ then for all $vec(x) in RR^n$, $[vec(x)]_bcal(B)_2 = C [vec(v)]_bcal(B)_1$.]
  ]

]

#chapter[5][Determinants][
  #section[1][The Determinant Function][
    #def[5.1][The determinant of $A in RR^(1 times 1)$ is $det A = a_(11)$ where $A = bdmat(a_(11))$.]
    #def[5.2][The determinant of $A in RR^(2 times 2)$ is $det(A) = a_(11)a_(22)-a_(12)a_(21)$ where $A = bdmat(a_(11),a_(12);a_(21),a_(22))$.]
    #def[5.3][The determinant of $A in RR^(3 times 3)$ is $det(A) = a_(11)a_(22)a_(33)+a_(12)a_(23)a_(31) + a_(13)a_(21)a_(32)-a_(11)a_(23)a_(32)-a_(12)a_(21)a_(33)-a_(13)a_(22)a_(31)$ where $A = bdmat(a_(11),a_(12),a_(13);a_(21),a_(22),a_(23);a_(31),a_(32),a_(33))$.]

    #deftheorem[Rule of Sarrus][For $A in RR^(3 times 3)$, and for $A in RR^(2 times 2)$.]

    #def[5.4][Let $M_(i j)$ be the minor matrix from excluding row $i$ and column $j$. Let the cofactor $C_(i j)$ be defined by $C_(i j) = (-1)^(i + j) det(M_(i j))$. Then for $A in RR^(n times n)$ with $n > 1$, we have $det A = sum_(i=1)^n a_(1i) C_(1i)$.]

    #deftheorem[5.5][For $n >= 1$, we have $det(I_n) = 1$.]
    #deftheorem[5.6][For all $A in RR^(n times n)$, $A$ is invertible if and only if $det(A) != 0$.]

     #deftheorem[5.7 - Unifying 7][Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
      + $span cal(S) = RR^n$.
      + $cal(S)$ is linearly independent. 
      + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
      + $T$ is surjective.
      + $T$ is injective.
      + $A$ is invertible.
      + $ker(T) = {vec(0)}$.
      + $cal(S)$ is a basis for $RR^n$.
      + $col(A) = RR^n$.
      + $row(A) = RR^n$.
      + $rank(A) = n$.
      + $det(A) != 0$.
      ]

      #deftheorem[5.8][*Cofactor/Laplace Expansion, Expansion by Minors:* For all $A in RR^(n times n)$ and $0 < j <= n$,
        + Expand across row $j$: $det(A) = sum_(i=1)^n a_(j i)C_(j i)$
        + Expand down column $j$: $det(A) = sum_(i=1)^n a_(i j)C_(i j)$
      ]

      #deftheorem[5.9][If $A in RR^(n times n)$ is triangular, then $det(A)$ is the product of terms along the diagonal.]

      #deftheorem[5.10][For all square matrices $A$, $det(A^"T") = det(A)$.]

      #deftheorem[5.11][Let $A$ be a square matrix.
        + If $A$ has a row or column of zeros, then $det(A) = 0$.
        + If $A$ has two identical rows or columns, then $det(A) = 0.$
      ]

      #deftheorem[5.12][For all $A,B in RR^(n times n)$, we have $det(A B) = det(A) det(B)$.]

  ]

  #section[2][Properties of Determinants][
    #deftheorem[5.13][
      (Also true for columns instead of rows): For all $A in RR^(n times n)$,
      + If $B$ is produced by swapping two rows of $A$, $det(A) = -det(B)$.
      + If $B$ is produced by multiplying a row of $A$ by $c$, then $det(A) = c^(-1) dot det(B)$.
      + If $B$ is produced by adding a multiple of one row onto another, then $det(A) = det(B)$.
    ]

    #deftheorem[5.14][For all $E, B in RR^(n times n)$, if $E$ is an elementary matrix, then $det(E B) = det(E) det(B)$.]
    #deftheorem[5.15][For all invertible $A in RR^(n times n)$, we have $det(A^(-1)) = det(A)^(-1)$.]

    #deftheorem[5.16][
      Let $P$ be a partitioned $n times n$ matrix with square block submatrices $A$ and $D$ such that 
      $ P = bmat(A, B; bold(0), D) " or " P = bmat(A, bold(0); C, D). $
      Then $det(P) = det(A) det(D)$.
    ]
  ]

  #section[X][Bonus Content][
    #deftheorem[Leibniz][ $ det(A) = sum_(sigma in S_n) 
    "sgn" sigma product_(i=1)^n a_(sigma(i)i) $]

    #let bigwedge = math.and.big
    Let $V$ be an $n$ dimensional vector space.
We have the covariant endofunctor $bigwedge^n$ mapping $V$ to the 1D vector space $bigwedge^n V$ of n-volumes. We also have a contravariant transpose/dual endofunctor.

Transpose of linear map $A : V to V$ is $A^"T" : V^ast to V^ast$ such that for all $v in V$ and $f in V^ast$,

$
  A^T (f)(v)=f(A(v))
$

$A^T$ is a pullback on covectors?

$bigwedge^n A : bigwedge^n V to bigwedge^n V$ is a pushforward on n-volumes such that for all $omega in bigwedge^n V$,
$
[imat(bigwedge)^n A](omega)=det(A)dot omega
$
$
det(A)=det(imat(bigwedge)^n A)
$

Ok, then probably we can probably find some isomorphism (natural isomorphism? whatever that means) to do
$
 phi:(  imat(bigwedge)^n ,V)^ ast to  imat(bigwedge)^n ,V^ ast
$
$
[  imat(bigwedge)^n A]^T= phi^(-1) circ(  imat(bigwedge)^n A^T) circ  phi
$

$
 det[  imat(bigwedge)^n A]^T= det (  imat(bigwedge)^n A^T)= det A^T
$

(idk how valid doing this is)

and we can pushforward the first equation to become: for all $ omega  in bigwedge^n V$ and $ eta  in ( bigwedge^n V)^ ast$,

$
[  imat(bigwedge)^n A]^T( eta)( omega)= eta([  imat(bigwedge)^n A]( omega))
$
$
 det(A^T) dot  eta( omega)= eta( det(A) dot omega)
$


$ phi$ is a natural isomorphism from the functor $T  circ  bigwedge^n  implies  bigwedge^n circ T$ where $T$ is the transpose/dual endofunctor.
  ]
]

#chapter[6][Eigensystems][
  #section[1][Eigenvectors and Eigenvalues][
    #def[6.1][For all $A in RR^(n times n)$, $vec(u) in RR^n$ is an *eigenvector* of $A$ if there exists an *eigenvalue* $lambda in RR$ such that $A vec(u) = lambda vec(u)$ and $vec(u) != vec(0)$.]

    #deftheorem[6.2][Let $vec(u) in RR^n$ be an eigenvector of $A$ and let $lambda in RR$ be the associated eigenvalue. For all $c in RR$, $c!=0$ implies that $c dot vec(u)$ is also an eigenvector associated with $lambda$.]

    #deftheorem[6.3][Let $A in RR^(n times n)$ have an eigenvalue $lambda in RR$. Let $S subset.eq RR^n$ be the set of all eigenvectors associated with $lambda$. Then $S union {vec(0)}$ is a subspace of $RR^n$.]

    #def[6.4][Let $A in RR^(n times n)$ have eigenvalue $lambda in RR$. The subspace of eigenvectors associated with $lambda$ (together with $vec(0)$) is the *eigenspace* of $lambda$.]

    #deftheorem[6.5][For all $A in RR^(n times n)$, $lambda in RR$ is an eigenvalue of $A$ if and only if $det(A - lambda I_n) = 0$.]

    #deftheorem[6.6][Let $A in RR^(n times n)$ have eigenvalue $lambda in RR$. The dimension of the eigenspace associated with $lambda$ is less than or equal to the *multiplicity* of $lambda$ (the multiplicity of the root in the *characteristic polynomial*).]

    #deftheorem[6.7 - Unifying 8][Let $cal(S) = {vec(a)_1, dots, vec(a)_n}$ be a set of $n$ vectors $vec(a)_i in RR^n$, and let $A = bdmat(vec(a)_1, dots, vec(a)_n)$. Let the linear transformation $T : RR^n to RR^n$ be given by $T(vec(x)) = A vec(x)$. The following statements are equivalent:
      + $span cal(S) = RR^n$.
      + $cal(S)$ is linearly independent. 
      + $A vec(x) = vec(b)$ has a unique solution $vec(x) in RR^n$ for all $vec(b) in RR^n$.
      + $T$ is surjective.
      + $T$ is injective.
      + $A$ is invertible.
      + $ker(T) = {vec(0)}$.
      + $cal(S)$ is a basis for $RR^n$.
      + $col(A) = RR^n$.
      + $row(A) = RR^n$.
      + $rank(A) = n$.
      + $det(A) != 0$.
      + $lambda = 0$ is not an eigenvalue of $A$.
      ]
  ]

  #section[2][Diagonalization][
    #def[6.8][A matrix $A in RR^(n times n)$ is *diagonalizable* if and only if there exist a diagonal matrix $D in RR^(n times n)$ and an invertible matrix $P in RR^(n times n)$ such that $A = P D P^(-1)$.]

    #def[6.9][A matrix $A in RR^(n times n)$ is diagonalizable if and only if $A$ has eigenvectors that form a basis for $RR^n$.]

    #deftheorem[6.10][If ${lambda_1, dots, lambda_k}$ are distinct eigenvalues of $A in RR^(n times n)$, then all sets of associated eigenvectors ${vec(u)_1, dots, vec(u)_k}$ are linearly independent.]

    #deftheorem[6.11][For all $A in RR^(n times n)$ that have only real eigenvalues, $A$ is diagonalizable if and only if the dimension of each eigenspace is equal to the multiplicity of the corresponding eigenvalue.]

    #deftheorem[6.12][If $A in RR^(n times n)$ has $n$ distinct real eigenvalues, then $A$ is diagonalizable.]
  ]
]

#let dumptd(list, head: "Def") = context for a in list.get() [
  *#head #a.first()*
  #grid(columns: (1.5em, auto), box(), a.last())
]

#newpage()
= Definitions
#dumptd(definitions)

#newpage()
= Theorems
#dumptd(theorems, head: "Theorem")