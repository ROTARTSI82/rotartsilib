module

public import Mathlib.LinearAlgebra.Matrix.Adjugate
public import Mathlib.LinearAlgebra.Matrix.Block
public import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
public import Mathlib.Data.Finset.Sort

/-!
# Jacobi's Complementary Minor Identity

This file proves that for an `n × n` matrix `A` over a commutative ring `R`,
`det(A) * A^{\text{adj}}[J^c, I^c] = \text{sgn}(\sigma_{I,J}) • (det(A)^{n-k} * A[I, J])`.
-/

public section

open Matrix

variable {n m ι₁ ι₂ R : Type*}
  [Fintype n] [DecidableEq n]
  [Fintype m] [DecidableEq m]
  [Fintype ι₁] [DecidableEq ι₁]
  [Fintype ι₂] [DecidableEq ι₂]
  [CommRing R]

/-- Reindexing rows by `eI` and columns by `eJ` multiplies the determinant by
the sign of the relative permutation `eJ.symm.trans eI`. -/
lemma det_submatrix_equiv (A : Matrix n n R) (eI eJ : m ≃ n) :
    (A.submatrix eI eJ).det = Equiv.Perm.sign (eJ.symm.trans eI) • A.det := by
  have h : A.submatrix eI eJ = (A.submatrix (eJ.symm.trans eI) id).submatrix eJ eJ := by
    ext i j
    simp
  rw [h, det_submatrix_equiv_self, det_permute, Units.smul_def, zsmul_eq_mul]

/-- **Core Block-Matrix Identity**:
For any row partition `eI : ι₁ ⊕ ι₂ ≃ n` and column partition `eJ : ι₁ ⊕ ι₂ ≃ n`,
`(A.submatrix eI eJ).det * A^{\text{adj}}[J^c, I^c] = A.det ^ |ι₂| * A[I, J]`. -/
theorem det_submatrix_mul_adjugate_minor (A : Matrix n n R) (eI eJ : ι₁ ⊕ ι₂ ≃ n) :
    (A.submatrix eI eJ).det *
      (A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inr)).det =
    A.det ^ Fintype.card ι₂ *
      (A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inl)).det := by
  let A₁₁ := A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inl)
  let A₁₂ := A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inr)
  let A₂₁ := A.submatrix (eI ∘ Sum.inr) (eJ ∘ Sum.inl)
  let A₂₂ := A.submatrix (eI ∘ Sum.inr) (eJ ∘ Sum.inr)
  let B₁₁ := A.adjugate.submatrix (eJ ∘ Sum.inl) (eI ∘ Sum.inl)
  let B₁₂ := A.adjugate.submatrix (eJ ∘ Sum.inl) (eI ∘ Sum.inr)
  let B₂₁ := A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inl)
  let B₂₂ := A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inr)
  have hA : A.submatrix eI eJ = fromBlocks A₁₁ A₁₂ A₂₁ A₂₂ := by
    ext (i | i) (j | j) <;> rfl
  have hB : A.adjugate.submatrix eJ eI = fromBlocks B₁₁ B₁₂ B₂₁ B₂₂ := by
    ext (i | i) (j | j) <;> rfl
  -- Expand `(A * A.adjugate).submatrix eI eI = A.det • 1` in block form
  have hAB : fromBlocks A₁₁ A₁₂ A₂₁ A₂₂ * fromBlocks B₁₁ B₁₂ B₂₁ B₂₂ =
      fromBlocks (A.det • 1) 0 0 (A.det • 1) := by
    rw [← hA, ← hB, submatrix_mul_equiv, mul_adjugate]
    ext (i | i) (j | j) <;> simp [one_apply]
  rw [fromBlocks_multiply, fromBlocks_inj] at hAB
  obtain ⟨-, h₁₂, -, h₂₂⟩ := hAB
  -- Multiply the reindexed `A` by the block upper-triangular matrix `fromBlocks 1 B₁₂ 0 B₂₂`
  have h_mul : A.submatrix eI eJ * fromBlocks 1 B₁₂ 0 B₂₂ =
      fromBlocks A₁₁ 0 A₂₁ (A.det • 1) := by
    rw [hA, fromBlocks_multiply]
    simp [h₁₂, h₂₂]
  calc (A.submatrix eI eJ).det * B₂₂.det
    _ = (A.submatrix eI eJ * fromBlocks 1 B₁₂ 0 B₂₂).det := by
        rw [det_mul, det_fromBlocks_zero₂₁, det_one, one_mul]
    _ = (fromBlocks A₁₁ 0 A₂₁ (A.det • 1)).det := by
        rw [h_mul]
    _ = A.det ^ Fintype.card ι₂ * A₁₁.det := by
        rw [det_fromBlocks_zero₁₂, det_smul, det_one, mul_one, mul_comm]

/-- **Jacobi's Complementary Minor Identity (General Partition Form)**:
`det(A) * A^{\text{adj}}[J^c, I^c] = sgn(eJ⁻¹ ∘ eI) • (det(A)^{|I^c|} * A[I, J])`. -/
theorem det_mul_adjugate_minor (A : Matrix n n R) (eI eJ : ι₁ ⊕ ι₂ ≃ n) :
    A.det * (A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inr)).det =
    Equiv.Perm.sign (eJ.symm.trans eI) •
      (A.det ^ Fintype.card ι₂ * (A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inl)).det) := by
  have h := det_submatrix_mul_adjugate_minor A eI eJ
  rw [det_submatrix_equiv, smul_mul_assoc] at h
  rw [← h, smul_smul, Int.units_mul_self, one_smul]

/-- **Unsigned Principal Minor Identity (`I = J`)**:
For any subset `I : Finset n` of cardinality `k`,
`det(A) * A^{\text{adj}}[I^c, I^c] = det(A)^{n - k} * A[I, I]`. -/
theorem det_mul_adjugate_principal_minor (A : Matrix n n R) (I : Finset n)
    {k : ℕ} (hI : I.card = k) :
    A.det * (A.adjugate.submatrix (Subtype.val : ↥(Iᶜ) → n) (Subtype.val : ↥(Iᶜ) → n)).det =
    A.det ^ (Fintype.card n - k) *
      (A.submatrix (Subtype.val : ↥I → n) (Subtype.val : ↥I → n)).det := by
  let eCompl : {x // x ∉ I} ≃ ↥(Iᶜ) :=
    { toFun := fun x => ⟨x.1, Finset.mem_compl.mpr x.2⟩
      invFun := fun x => ⟨x.1, Finset.mem_compl.mp x.2⟩
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl }
  let eI : ↥I ⊕ ↥(Iᶜ) ≃ n :=
    (Equiv.sumCongr (Equiv.refl ↥I) eCompl.symm).trans (Equiv.sumCompl (· ∈ I))
  have h := det_submatrix_mul_adjugate_minor A eI eI
  have hcard : Fintype.card ↥(Iᶜ) = Fintype.card n - k := by
    rw [Fintype.card_coe, Finset.card_compl, hI]
  rw [det_submatrix_equiv_self, hcard] at h
  exact h

/-- Canonical equivalence `Fin k ⊕ Fin (n - k) ≃ Fin n` induced by `I : Finset (Fin n)`
of cardinality `k`, preserving the natural order on `I` and `Iᶜ`. -/
noncomputable def finsetSumComplEquiv {n k : ℕ} (I : Finset (Fin n)) (hI : I.card = k) :
    Fin k ⊕ Fin (n - k) ≃ Fin n :=
  have hIc : (Iᶜ).card = n - k := by rw [Finset.card_compl, Fintype.card_fin, hI]
  let e₁ : Fin k ≃ ↥I := (I.orderIsoOfFin hI).toEquiv
  let e₂ : Fin (n - k) ≃ {x // x ∉ I} :=
    (Iᶜ.orderIsoOfFin hIc).toEquiv.trans
      { toFun := fun x => ⟨x.1, Finset.mem_compl.mp x.2⟩
        invFun := fun x => ⟨x.1, Finset.mem_compl.mpr x.2⟩
        left_inv := fun _ => rfl
        right_inv := fun _ => rfl }
  (Equiv.sumCongr e₁ e₂).trans (Equiv.sumCompl (· ∈ I))

/-- **Jacobi's Complementary Minor Identity for `I, J ⊆ [n]`**:
Given `I, J : Finset (Fin n)` of size `k`, denotes `A[I, J]` and `A^{\text{adj}}[J^c, I^c]`
via their canonical order-preserving enumerations `orderIsoOfFin`. -/
theorem det_mul_adjugate_finset_minor {n k : ℕ} (A : Matrix (Fin n) (Fin n) R)
    (I J : Finset (Fin n)) (hI : I.card = k) (hJ : J.card = k)
    (hIc : (Iᶜ).card = n - k := by rw [Finset.card_compl, Fintype.card_fin, hI])
    (hJc : (Jᶜ).card = n - k := by rw [Finset.card_compl, Fintype.card_fin, hJ]) :
    A.det *
      (A.adjugate.submatrix
        (Subtype.val ∘ (Jᶜ.orderIsoOfFin hJc))
        (Subtype.val ∘ (Iᶜ.orderIsoOfFin hIc))).det =
    Equiv.Perm.sign ((finsetSumComplEquiv J hJ).symm.trans (finsetSumComplEquiv I hI)) •
      (A.det ^ (n - k) *
        (A.submatrix
          (Subtype.val ∘ (I.orderIsoOfFin hI))
          (Subtype.val ∘ (J.orderIsoOfFin hJ))).det) := by
  simpa [finsetSumComplEquiv, Function.comp_def] using
    det_mul_adjugate_minor A (finsetSumComplEquiv I hI) (finsetSumComplEquiv J hJ)

end
