module

public import Mathlib

#check Matrix.mul_adjugate

#check Matrix.isUnit_iff_isUnit_det

#check Matrix.adjugate_fin_succ_eq_det_submatrix
#check Matrix.det_succ_row

#check Matrix.fromBlocks
#check Matrix.toBlocks₁₁

namespace MathAI.Resultant

public section

open scoped Matrix

variable {n m R : Type*} [DecidableEq n] [DecidableEq m]
variable [Fintype m] [Fintype n] [CommRing R]

def Matrix.selector (J : Set n) : Matrix {x // x ∈ J} n R :=
  Matrix.of <| fun i j =>
    if i = j then 1 else 0

section
variable (M : Matrix m n R) (I : Set m) (J : Set n)
def _root_.Matrix.select : Matrix {x // x ∈ I} {x // x ∈ J} R :=
  Matrix.of <| fun i j => M i j

def _root_.Matrix.select' : Matrix {x // x ∈ I} {x // x ∈ J} R :=
  M.submatrix Subtype.val Subtype.val

omit [DecidableEq n] [DecidableEq m] [Fintype m] [Fintype n] [CommRing R] in
theorem select_eq' : M.select I J = M.select' I J := by
  ext i j
  rfl

theorem select_eq : M.select I J = (Matrix.selector (R:=R) I) * M * (Matrix.selector (R:=R) J).transpose := by
  ext i j
  simp [Matrix.select, Matrix.selector, Matrix.mul_apply, Matrix.transpose]
end

section
variable (v : m → R) (I : Set m)

def Matrix.vecSelect : {x // x ∈ I} → R := fun i => v i

theorem vecSelect_eq : Matrix.vecSelect v I = (Matrix.selector I) *ᵥ v := by
  ext i
  simp [Matrix.vecSelect, Matrix.selector, Matrix.mulVec, dotProduct, Finset.sum_ite_eq]
end

lemma Fintype.sum_eq_sum_subtype_of_zero {α M} [Fintype α] [AddCommMonoid M]
    (p : α → Prop) [DecidablePred p] (f : α → M) (h : ∀ x, ¬ p x → f x = 0) :
    ∑ x : α, f x = ∑ x : {a // p a}, f ↑x := by
  rw [← Fintype.sum_subtype_add_sum_subtype p f]
  have h_zero : (∑ x : {a // ¬ p a}, f ↑x) = 0 := Finset.sum_eq_zero (fun x _ => h x.1 x.2)
  simp only [h_zero, add_zero]

set_option linter.unusedSectionVars false in
theorem drop_prop (I : Set m) (J : Set n) (M : Matrix m n R) (v : n → R)
    (hv : ∀ j, j ∉ J → v j = 0) [DecidablePred (· ∈ J)] :
    Matrix.vecSelect (M *ᵥ v) I = (M.select I J) *ᵥ (Matrix.vecSelect v J) := by
  ext i
  unfold Matrix.vecSelect Matrix.select Matrix.mulVec dotProduct
  exact Fintype.sum_eq_sum_subtype_of_zero (· ∈ J) (fun x => M (↑i) x * v x) (fun j hj => by rw [hv j hj, mul_zero])

end


section

variable {n : Type*} (I : Set n) [DecidablePred (· ∈ I)]

def setPartitionIso : n ≃ {x // x ∈ I} ⊕ {x // ¬ (x ∈ I)} where
  toFun x := if h : x ∈ I then Sum.inl ⟨x, h⟩ else Sum.inr ⟨x, h⟩
  invFun := Sum.elim Subtype.val Subtype.val 
  left_inv := by
    intro x
    by_cases h : x ∈ I
    · simp [dite_eq_left h]
    · simp [dite_eq_right h]
  right_inv := by
    intro x
    rcases x with l | r
    · simp
    · simp [r.property]

#check Fintype.card

variable [hn : Fintype n] 
  
instance : Fintype {x // x ∈ I} where
  elems := hn.elems.filterMap (fun x => if h : x ∈ I then Option.some ⟨x, h⟩ else Option.none) <| by
    intro a a' b hb₁ hb₂ 
    by_cases h : a ∈ I
    · simp [dite_eq_left h] at *
      rw [← hb₁] at hb₂
      simp [hb₂]
    · simp [dite_eq_right h] at *
  complete := by
    intro x
    simp [hn.complete]

end


public section

end


/- Solutions to the problems -/
public section

variable {n : Type*} [hn : Fintype n]
variable {k : ℕ} (hk : k ≤ Fintype.card n)
variable {I J : Finset n} 

variable (hI : I.card = k) (hJ : J.card = k)



#check Set.toFinset

end

end MathAI.Resultant

