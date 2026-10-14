import Mathlib

/-!
# Jacobi's complementary minor theorem

For `I J : Finset (Fin n)` of size `k`, write `A[I, J]` for the minor of `A` with rows `I` and
columns `J` (both taken in increasing order). Jacobi's theorem relates the minors of the adjugate
to the complementary minors of `A`:

  `det A * adj(A)[Jᶜ, Iᶜ] = (-1) ^ (∑ I + ∑ J) * (det A) ^ (n - k) * A[I, J]`.

## Proof sketch

Reorder rows as `I, Iᶜ` and columns as `J, Jᶜ` to get a block matrix `B = A.submatrix P Q`, and
let `C = (adj A).submatrix Q P` so that `B * C = det A • 1`. Replacing the first block column of
`C` with `(1, 0)` gives `M = !![1, C₁₂; 0, C₂₂]`, and `B * M = !![B₁₁, 0; B₂₁, det A • 1]` is block
triangular. Taking determinants gives `det B * det C₂₂ = det B₁₁ * (det A) ^ (n - k)`, and
`det B = ± det A` where the sign is that of a shuffle permutation (`sign_shuffle`).
-/

open Equiv Finset Matrix

namespace DetPoly

variable {R : Type*} [CommRing R] {n k : ℕ}

/-! ### Signs of shuffle permutations -/

/-- The sign of a permutation of `Fin n` as a product over its inversions. -/
theorem sign_eq_prod_ite (σ : Perm (Fin n)) :
    Perm.sign σ = ∏ y, ∏ x, if x < y ∧ σ y < σ x then -1 else 1 := by
  rw [σ.sign_eq_prod_prod_Iio]
  refine prod_congr rfl fun y _ ↦ ?_
  rw [← filter_gt_eq_Iio, prod_filter]
  refine prod_congr rfl fun x _ ↦ ?_
  split_ifs <;> grind [EmbeddingLike.apply_eq_iff_eq]

/-- The sign of a shuffle: the permutation of `Fin (k + m)` that is increasing on `[0, k)` and on
`[k, k + m)`. Its sign depends only on the image of `[0, k)`. -/
theorem sign_shuffle {m : ℕ} (h : k + m = n) (e : Fin k ⊕ Fin m ≃ Fin n)
    (hl : StrictMono (e ∘ Sum.inl)) (hr : StrictMono (e ∘ Sum.inr)) :
    Perm.sign ((finSumFinEquiv.trans (finCongr h)).symm.trans e) =
      (-1) ^ (∑ a, (e (.inl a) : ℕ) + ∑ a : Fin k, (a : ℕ)) := by
  have hl' (a b) : e (.inl a) < e (.inl b) ↔ a < b := hl.lt_iff_lt
  have hr' (a b) : e (.inr a) < e (.inr b) ↔ a < b := hr.lt_iff_lt
  have h₁ (a b : Fin k) : Fin.castAdd m a < Fin.castAdd m b ↔ a < b := Iff.rfl
  have h₂ (a : Fin k) (b : Fin m) : Fin.castAdd m a < Fin.natAdd k b := by
    rw [Fin.lt_def]; simp; omega
  have h₃ {α : Type} [Preorder α] (a b : α) : ¬(a < b ∧ b < a) := fun h ↦ lt_asymm h.1 h.2
  -- the only inversions are pairs `(inl a, inr b)` with `e (inr b) < e (inl a)`
  have hcount (a : Fin k) : #{b | e (.inr b) < e (.inl a)} + a = (e (.inl a) : ℕ) := by
    rw [← Fin.card_Iio, ← Fin.card_Iio (e _), ← filter_gt_eq_Iio, ← filter_gt_eq_Iio]
    simp only [card_filter, ← e.sum_comp (fun x ↦ ite _ _ _), Fintype.sum_sum_type, hl']
    ring
  set E := finSumFinEquiv.trans (finCongr h)
  rw [sign_eq_prod_ite, ← E.prod_comp]
  simp_rw [← E.prod_comp (fun x ↦ ite _ _ _)]
  simp [Fintype.prod_sum_type, E, hl', hr', h₁, h₂, (h₂ _ _).not_gt, h₃]
  rw [prod_comm, ← sum_congr rfl fun a _ ↦ hcount a, sum_add_distrib, add_assoc, ← two_mul,
    pow_add, pow_mul]
  simp [prod_ite, prod_pow_eq_pow_sum]

/-! ### Splitting `Fin n` into a subset and its complement -/

theorem card_compl_of_card {I : Finset (Fin n)} (hI : #I = k) : #Iᶜ = n - k := by
  rw [card_compl, Fintype.card_fin, hI]

/-- Enumerate `I` in increasing order, followed by `Iᶜ` in increasing order. -/
noncomputable def finSumComplEquiv (I : Finset (Fin n)) (hI : #I = k) :
    Fin k ⊕ Fin (n - k) ≃ Fin n :=
  .ofBijective (Sum.elim (I.orderEmbOfFin hI) (Iᶜ.orderEmbOfFin (card_compl_of_card hI))) <| by
    refine (Fintype.bijective_iff_injective_and_card _).2 ⟨?_, ?_⟩
    · refine (I.orderEmbOfFin hI).injective.sumElim (Iᶜ.orderEmbOfFin _).injective fun a b h ↦ ?_
      have := Iᶜ.orderEmbOfFin_mem (card_compl_of_card hI) b
      rw [← h, mem_compl] at this
      exact this (I.orderEmbOfFin_mem hI a)
    · have := hI ▸ I.card_le_univ
      simp at this ⊢
      omega

theorem sign_finSumComplEquiv (I : Finset (Fin n)) (hI : #I = k) (h : k + (n - k) = n) :
    Perm.sign ((finSumFinEquiv.trans (finCongr h)).symm.trans (finSumComplEquiv I hI)) =
      (-1) ^ (∑ i ∈ I, (i : ℕ) + ∑ a : Fin k, (a : ℕ)) := by
  rw [sign_shuffle h (finSumComplEquiv I hI) (I.orderEmbOfFin hI).strictMono
    (Iᶜ.orderEmbOfFin (card_compl_of_card hI)).strictMono]
  conv_rhs => rw [← I.map_orderEmbOfFin_univ hI, sum_map]
  rfl

/-- Reindexing rows and columns by two different equivalences multiplies the determinant by the
sign of the permutation relating them. -/
theorem det_submatrix_equiv {α : Type*} [Fintype α] [DecidableEq α]
    (A : Matrix (Fin n) (Fin n) R) (e f : α ≃ Fin n) :
    (A.submatrix e f).det = Perm.sign (f.symm.trans e) * A.det := by
  rw [← det_permute, ← det_submatrix_equiv_self f]
  congr 1
  ext
  simp

/-! ### Jacobi's theorem -/

/-- **Jacobi's complementary minor theorem**: for `#I = #J = k`,
`det A * adj(A)[Jᶜ, Iᶜ] = (-1) ^ (∑ I + ∑ J) * (det A) ^ (n - k) * A[I, J]`. -/
theorem det_mul_det_submatrix_adjugate (A : Matrix (Fin n) (Fin n) R) {I J : Finset (Fin n)}
    (hI : #I = k) (hJ : #J = k) :
    A.det * ((adjugate A).submatrix (Jᶜ.orderEmbOfFin (card_compl_of_card hJ))
        (Iᶜ.orderEmbOfFin (card_compl_of_card hI))).det =
      (-1) ^ (∑ i ∈ I, (i : ℕ) + ∑ j ∈ J, (j : ℕ)) * A.det ^ (n - k) *
        (A.submatrix (I.orderEmbOfFin hI) (J.orderEmbOfFin hJ)).det := by
  set ε : R := (-1) ^ (∑ i ∈ I, (i : ℕ) + ∑ j ∈ J, (j : ℕ))
  set P := finSumComplEquiv I hI
  set Q := finSumComplEquiv J hJ
  set B := A.submatrix P Q
  set C := (adjugate A).submatrix Q P
  -- `B * C = det A • 1`, read off blockwise
  have hBC : B * C = fromBlocks (A.det • 1) 0 0 (A.det • 1) := by
    ext (i | i) (j | j) <;> simp [B, C, mul_adjugate, one_apply]
  rw [← fromBlocks_toBlocks B, ← fromBlocks_toBlocks C, fromBlocks_multiply,
    fromBlocks_inj] at hBC
  -- replacing the first block column of `C` by `(1, 0)` gives a block triangular product
  have hBM : B * fromBlocks 1 C.toBlocks₁₂ 0 C.toBlocks₂₂ =
      fromBlocks B.toBlocks₁₁ 0 B.toBlocks₂₁ (A.det • 1) := by
    rw [← fromBlocks_toBlocks B, fromBlocks_multiply]
    simp [hBC.2.1, hBC.2.2.2]
  have hsign : (Perm.sign (Q.symm.trans P) : R) = ε := by
    have h : k + (n - k) = n := by
      have := hI ▸ I.card_le_univ
      simp at this
      omega
    set E := finSumFinEquiv.trans (finCongr h)
    rw [show Q.symm.trans P = (E.symm.trans Q).symm.trans (E.symm.trans P) by ext; simp,
      Perm.sign_trans, Perm.sign_symm, sign_finSumComplEquiv I hI h,
      sign_finSumComplEquiv J hJ h, ← pow_add,
      show _ + _ + (_ + _) = ∑ i ∈ I, (i : ℕ) + ∑ j ∈ J, (j : ℕ) + 2 * ∑ a : Fin k, (a : ℕ) by ring,
      pow_add, pow_mul]
    simp [ε]
  have hdet := congrArg det hBM
  rw [det_mul, det_fromBlocks_zero₂₁, det_fromBlocks_zero₁₂, det_smul, det_submatrix_equiv,
    hsign] at hdet
  simp only [det_one, one_mul, mul_one, Fintype.card_fin] at hdet
  have hε : ε ^ 2 = 1 := by rw [← pow_mul, pow_mul', neg_one_sq, one_pow]
  -- `C₂₂ = adj(A)[Jᶜ, Iᶜ]` and `B₁₁ = A[I, J]` by definition
  change A.det * C.toBlocks₂₂.det = ε * A.det ^ (n - k) * B.toBlocks₁₁.det
  linear_combination ε * hdet - A.det * C.toBlocks₂₂.det * hε

end DetPoly
