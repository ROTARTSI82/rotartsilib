module

public import Mathlib

#check Matrix.mul_adjugate

#check Matrix.isUnit_iff_isUnit_det

#check Matrix.adjugate_fin_succ_eq_det_submatrix
#check Matrix.det_succ_row

#check Matrix.fromBlocks
#check Matrix.toBlocks₁₁

public section

variable {n m R : Type*} [DecidableEq n] [DecidableEq m]
variable [Fintype m] [Fintype n] [CommRing R]

def Matrix.selector (J : Set n) : Matrix {x // x ∈ J} n R :=
  fun i j =>
    if i = j then 1 else 0

section
variable (M : Matrix m n R) (I : Set m) (J : Set n)
def Matrix.select : Matrix {x // x ∈ I} {x // x ∈ J} R :=
  fun i j => M i j

def Matrix.select' : Matrix {x // x ∈ I} {x // x ∈ J} R :=
  M.submatrix Subtype.val Subtype.val

omit [DecidableEq n] [DecidableEq m] [Fintype m] [Fintype n] [CommRing R] in
theorem select_eq' : M.select I J = M.select' I J := by
  ext i j
  rfl

theorem select_eq : M.select I J = (Matrix.selector (n := m) (R := R) I) * M * (Matrix.selector (n := n) (R := R) J).transpose := by
  ext i j
  simp [Matrix.select, Matrix.selector, Matrix.mul_apply, Matrix.transpose]
end

section
variable (v : m → R) (I : Set m)

def Matrix.vecSelect : {x // x ∈ I} → R := fun i => v i

theorem vecSelect_eq : Matrix.vecSelect v I = Matrix.mulVec (Matrix.selector (n := m) (R := R) I) v := by
  ext i
  simp [Matrix.vecSelect, Matrix.selector, Matrix.mulVec, dotProduct, Finset.sum_ite_eq]
end

-- wanted api
lemma Fintype.sum_eq_sum_subtype_of_zero {α M} [Fintype α] [AddCommMonoid M]
    (p : α → Prop) [DecidablePred p] (f : α → M) (h : ∀ x, ¬ p x → f x = 0) :
    ∑ x : α, f x = ∑ x : {a // p a}, f ↑x := by
  have h_zero : (∑ x : {a // ¬ p a}, f ↑x) = 0 := Finset.sum_eq_zero (fun x _ => h x.1 x.2)
  calc
    ∑ x : α, f x = (∑ x : {a // p a}, f ↑x) + (∑ x : {a // ¬ p a}, f ↑x) := (Fintype.sum_subtype_add_sum_subtype p f).symm
    _ = (∑ x : {a // p a}, f ↑x) + 0 := by rw [h_zero]
    _ = ∑ x : {a // p a}, f ↑x := add_zero _

-- definitely not slop anymore
set_option linter.unusedSectionVars false in
theorem drop_prop (I : Set m) (J : Set n) (M : Matrix m n R) (v : n → R)
    (hv : ∀ j, j ∉ J → v j = 0) [DecidablePred (· ∈ J)] :
    Matrix.vecSelect (Matrix.mulVec M v) I = Matrix.mulVec (M.select I J) (Matrix.vecSelect v J) := by
  ext i
  unfold Matrix.vecSelect Matrix.select Matrix.mulVec dotProduct
  dsimp
  exact Fintype.sum_eq_sum_subtype_of_zero (· ∈ J) (fun x => M (↑i) x * v x) (fun j hj => by rw [hv j hj, mul_zero])

end

section

variable (n k : ℕ)

#check { s : Finset (Fin n) // s.card = k }
#eval let k := 3
  let n := 5
  Finset.powersetCard k (Finset.univ : Finset (Fin n))

#check { s : Finset (Fin n) // s.card ≤ k }
#eval let k := 3
  let n := 5
  (Finset.univ : Finset (Fin n)).powerset.filter (fun s => s.card ≤ k)

end
