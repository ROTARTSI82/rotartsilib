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

def Matrix.selector (J : Set n) : Matrix {x // J x} n R :=
  fun i j =>
    if i = j then 1 else 0

section
variable (M : Matrix m n R) (I : Set m) (J : Set n)
def Matrix.select : Matrix {x // I x} {x // J x} R :=
  fun i j => M i j

def Matrix.select' : Matrix {x // I x} {x // J x} R :=
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

def Matrix.vecSelect : {x // I x} → R := fun i => v i

theorem vecSelect_eq : Matrix.vecSelect v I = Matrix.mulVec (Matrix.selector (n := m) (R := R) I) v := by
  ext i
  simp [Matrix.vecSelect, Matrix.selector, Matrix.mulVec, dotProduct, Finset.sum_ite_eq]
end

-- vibed up slop courtesy of gemini agy.
set_option linter.unusedSectionVars false in
theorem drop_prop (I : Set m) (J : Set n) (M : Matrix m n R) (v : n → R)
    (hv : ∀ j, j ∉ J → v j = 0) [DecidablePred J] [Fintype {x // J x}] :
    Matrix.vecSelect (Matrix.mulVec M v) I = Matrix.mulVec (M.select I J) (Matrix.vecSelect v J) := by
  ext i
  unfold Matrix.vecSelect Matrix.select Matrix.mulVec dotProduct
  dsimp
  have h_sum : ∑ x : n, M (↑i) x * v x = ∑ j : {x // J x}, M (↑i) (↑j) * v ↑j := by
    let _ : DecidablePred (fun x => ¬ J x) := fun _ => Classical.propDecidable _
    have h_eq : (∑ x : n, M (↑i) x * v x) = (∑ x ∈ Finset.filter (fun x => J x) Finset.univ, M (↑i) x * v x) + (∑ x ∈ Finset.filter (fun x => ¬J x) Finset.univ, M (↑i) x * v x) :=
      (Finset.sum_filter_add_sum_filter_not Finset.univ _ _).symm
    rw [h_eq]
    have h_zero : (∑ x ∈ Finset.filter (fun x => ¬J x) Finset.univ, M (↑i) x * v x) = 0 := by
      apply Finset.sum_eq_zero
      intro x hx
      rw [Finset.mem_filter] at hx
      rw [hv x hx.2, mul_zero]
    rw [h_zero, add_zero]
    exact Finset.sum_subtype (Finset.filter (fun x => J x) Finset.univ) (fun x => by simp) (fun x => M (↑i) x * v x)
  exact h_sum

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
