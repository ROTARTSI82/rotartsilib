module

public import Mathlib

#check Matrix.mul_adjugate

#check Matrix.isUnit_iff_isUnit_det

public instance myInst {m} [Fintype m] {I : Set m} : Fintype {x // I x} :=
  sorry

public section

variable {n m R : Type*} [DecidableEq n] [DecidableEq m]
variable [Fintype m] [Fintype n] [CommRing R]

#check Subtype

def Matrix.select (J : Set n) : Matrix {x // J x} n R :=
  fun i j =>
    if i = j then 1 else 0

#check Matrix.mul_add

def Matrix.drop (M : Matrix m n R) (I : Set m) (J : Set n) :=
  (Matrix.select (n := m) (R := R) I) * M * (Matrix.select (n := n) (R := R) J).transpose

def Matrix.vecDrop (v : m → R) (I : Set m) : {x // I x} → R :=
  Matrix.mulVec (Matrix.select (n := m) (R := R) I) v

#check mulVec_one_of_mem_doublyStochastic

theorem drop_prop (I : Set m) (J : Set n) (M : Matrix m n R) (v : n → R) :
    letI : Fintype {x // J x} := myInst
    Matrix.vecDrop (Matrix.mulVec M v) I = Matrix.mulVec (M.drop I J) (Matrix.vecDrop v J) := by
  sorry

end
