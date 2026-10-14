import Mathlib

namespace Jacobi

variable {m l R : Type*} [Fintype m] [Fintype l]
  [DecidableEq m] [DecidableEq l] [CommRing R]

/-- Jacobi's identity when the selected indices are the left summand.
    This works without an invertibility assumption, including empty summands. -/
theorem complementary_block_minor
    (A : Matrix (m ⊕ l) (m ⊕ l) R) :
    A.det * (A.adjugate.submatrix Sum.inr Sum.inr).det =
      A.det ^ Fintype.card l * (A.submatrix Sum.inl Sum.inl).det := by
  let B : Matrix (m ⊕ l) (m ⊕ l) R := Matrix.of fun i j =>
    match j with
    | .inl k => (1 : Matrix (m ⊕ l) (m ⊕ l) R) i (.inl k)
    | .inr k => A.adjugate i (.inr k)
  let C : Matrix (m ⊕ l) (m ⊕ l) R := Matrix.of fun i j =>
    match j with
    | .inl k => A i (.inl k)
    | .inr k => A.det * (1 : Matrix (m ⊕ l) (m ⊕ l) R) i (.inr k)
  have hmul : A * B = C := by
    ext i j
    cases j with
    | inl j =>
        simp only [Matrix.mul_apply, B, C, Matrix.of_apply]
        rw [← Matrix.mul_apply]
        simp
    | inr j =>
        simp only [Matrix.mul_apply, B, C, Matrix.of_apply]
        rw [← Matrix.mul_apply]
        simpa [Matrix.smul_apply, smul_eq_mul] using congrArg
          (fun M : Matrix (m ⊕ l) (m ⊕ l) R => M i (.inr j))
          (Matrix.mul_adjugate A)
  have hB : B = Matrix.fromBlocks (1 : Matrix m m R)
      (A.adjugate.submatrix Sum.inl Sum.inr)
      (0 : Matrix l m R)
      (A.adjugate.submatrix Sum.inr Sum.inr) := by
    ext i j
    cases i with
    | inl i =>
        cases j with
        | inl j => simp [B, Matrix.fromBlocks_apply₁₁, Matrix.one_apply]
        | inr j => simp [B, Matrix.fromBlocks_apply₁₂]
    | inr i =>
        cases j with
        | inl j => simp [B, Matrix.fromBlocks_apply₂₁]
        | inr j => simp [B, Matrix.fromBlocks_apply₂₂]
  have hC : C = Matrix.fromBlocks (A.submatrix Sum.inl Sum.inl)
      (0 : Matrix m l R)
      (A.submatrix Sum.inr Sum.inl)
      (A.det • (1 : Matrix l l R)) := by
    ext i j
    cases i with
    | inl i =>
        cases j with
        | inl j => simp [C, Matrix.fromBlocks_apply₁₁]
        | inr j => simp [C, Matrix.fromBlocks_apply₁₂]
    | inr i =>
        cases j with
        | inl j => simp [C, Matrix.fromBlocks_apply₂₁]
        | inr j => simp [C, Matrix.fromBlocks_apply₂₂, Matrix.one_apply, smul_eq_mul]
  calc
    A.det * (A.adjugate.submatrix Sum.inr Sum.inr).det =
        A.det * B.det := by rw [hB]; simp
    _ = C.det := by rw [← Matrix.det_mul, hmul]
    _ = A.det ^ Fintype.card l *
        (A.submatrix Sum.inl Sum.inl).det := by
      rw [hC, Matrix.det_fromBlocks_zero₁₂, Matrix.det_smul]
      simp only [Matrix.det_one, mul_one]
      ac_rfl

/-- General Jacobi identity, with its sign as a permutation sign. -/
theorem complementary_minor_equiv {ι : Type*} [Fintype ι] [DecidableEq ι]
    (A : Matrix ι ι R) (eI eJ : (m ⊕ l) ≃ ι) :
    A.det * (A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inr)).det =
      ((Equiv.Perm.sign (eI.symm.trans eJ) : ℤ) : R) *
        A.det ^ Fintype.card l *
        (A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inl)).det := by
  let p : Equiv.Perm ι := eI.symm.trans eJ
  let s : Finset ι := Finset.univ.image (eI ∘ Sum.inl)
  have hs (x : m) : eI (Sum.inl x) ∈ s :=
    Finset.mem_image.mpr ⟨x, Finset.mem_univ x, rfl⟩
  have hns (x : l) : eI (Sum.inr x) ∉ s := by
    intro hx
    obtain ⟨y, _, hy⟩ := Finset.mem_image.mp hx
    have h := eI.injective hy
    cases h
  let B : Matrix ι ι R := Matrix.of fun i j =>
    if j ∈ s then (1 : Matrix ι ι R) i (p j) else A.adjugate i j
  let C : Matrix ι ι R := Matrix.of fun i j =>
    if j ∈ s then A i (p j) else A.det * (1 : Matrix ι ι R) i j
  have hmul : A * B = C := by
    ext i j
    by_cases hj : j ∈ s
    · simp only [Matrix.mul_apply, B, C, Matrix.of_apply, hj, ite_true]
      rw [← Matrix.mul_apply]
      simp
    · simp only [Matrix.mul_apply, B, C, Matrix.of_apply, hj, ite_false]
      rw [← Matrix.mul_apply]
      simpa [Matrix.smul_apply, smul_eq_mul] using congrArg
        (fun M : Matrix ι ι R => M i j) (Matrix.mul_adjugate A)
  have hB : B.submatrix eJ eI =
      Matrix.fromBlocks (1 : Matrix m m R)
        (A.adjugate.submatrix (eJ ∘ Sum.inl) (eI ∘ Sum.inr))
        (0 : Matrix l m R)
        (A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inr)) := by
    ext i j
    cases i with
    | inl i =>
        cases j with
        | inl j => simp [B, hs, p, Matrix.fromBlocks_apply₁₁, Matrix.one_apply]
        | inr j => simp [B, hns, Matrix.fromBlocks_apply₁₂]
    | inr i =>
        cases j with
        | inl j => simp [B, hs, p, Matrix.fromBlocks_apply₂₁]
        | inr j => simp [B, hns, Matrix.fromBlocks_apply₂₂]
  have hC : C.submatrix eI eI =
      Matrix.fromBlocks (A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inl))
        (0 : Matrix m l R)
        (A.submatrix (eI ∘ Sum.inr) (eJ ∘ Sum.inl))
        (A.det • (1 : Matrix l l R)) := by
    ext i j
    cases i with
    | inl i =>
        cases j with
        | inl j => simp [C, hs, p, Matrix.fromBlocks_apply₁₁]
        | inr j => simp [C, hns, Matrix.fromBlocks_apply₁₂]
    | inr i =>
        cases j with
        | inl j => simp [C, hs, p, Matrix.fromBlocks_apply₂₁]
        | inr j => simp [C, hns, Matrix.fromBlocks_apply₂₂, Matrix.one_apply, smul_eq_mul]
  have hdetB :
      (B.submatrix eJ eI).det =
        ((Equiv.Perm.sign p : ℤ) : R) * B.det := by
    simpa [p, Matrix.reindex_apply] using
      (Matrix.det_reindex eJ.symm eI.symm B)
  have hdetC : (C.submatrix eI eI).det = C.det :=
    Matrix.det_submatrix_equiv_self eI C
  have h1 : A.det * B.det = C.det := by rw [← Matrix.det_mul, hmul]
  rw [hB, Matrix.det_fromBlocks_zero₂₁, Matrix.det_one, one_mul] at hdetB
  rw [hC, Matrix.det_fromBlocks_zero₁₂, Matrix.det_smul,
    Matrix.det_one, mul_one] at hdetC
  calc
    A.det * (A.adjugate.submatrix (eJ ∘ Sum.inr) (eI ∘ Sum.inr)).det =
        A.det * (((Equiv.Perm.sign p : ℤ) : R) * B.det) := by rw [hdetB]
    _ = ((Equiv.Perm.sign p : ℤ) : R) * C.det := by rw [← h1]; ring
    _ = ((Equiv.Perm.sign p : ℤ) : R) *
        A.det ^ Fintype.card l *
        (A.submatrix (eI ∘ Sum.inl) (eJ ∘ Sum.inl)).det := by
      rw [← hdetC]
      ring
    _ = _ := rfl

end Jacobi

