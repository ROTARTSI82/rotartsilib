module

public import Mathlib

public section

namespace Rotartsilib

universe u

/-!
## Eventual periodicity

Every orbit of a self-map of a finite type is eventually periodic: it has the shape of the
letter ρ, a tail of length `preperiod f x` followed by a cycle of length `eventualPeriod f x`.

These complement `Function.minimalPeriod`, which only describes points that are already periodic.
The main characterization is `iterate_add_eq_iterate_iff`:
for `n ≠ 0`, `f^[k + n] x = f^[k] x ↔ preperiod f x ≤ k ∧ eventualPeriod f x ∣ n`.
-/

open Function Set

variable {α : Type*} {f : α → α} {x : α} {k n : ℕ}

/-- The least `m` such that `f^[m] x` is a periodic point of `f`, or `0` if no iterate of `x`
is periodic (which cannot happen on a finite type). -/
noncomputable def preperiod (f : α → α) (x : α) : ℕ :=
  sInf {n | f^[n] x ∈ periodicPts f}

/-- The length of the cycle that the orbit of `x` eventually enters, or `0` if the orbit never
becomes periodic. -/
noncomputable def eventualPeriod (f : α → α) (x : α) : ℕ :=
  minimalPeriod f (f^[preperiod f x] x)

theorem preperiod_le (h : f^[n] x ∈ periodicPts f) : preperiod f x ≤ n :=
  Nat.sInf_le h

theorem iterate_preperiod_mem_periodicPts (h : ∃ n, f^[n] x ∈ periodicPts f) :
    f^[preperiod f x] x ∈ periodicPts f :=
  Nat.sInf_mem (s := {n | f^[n] x ∈ periodicPts f}) h

theorem preperiod_eq_zero_of_mem_periodicPts (hx : x ∈ periodicPts f) : preperiod f x = 0 :=
  Nat.eq_zero_of_le_zero (preperiod_le (n := 0) hx)

theorem eventualPeriod_eq_minimalPeriod (hx : x ∈ periodicPts f) :
    eventualPeriod f x = minimalPeriod f x := by
  rw [eventualPeriod, preperiod_eq_zero_of_mem_periodicPts hx, iterate_zero_apply]

/-- Past the preperiod, every iterate lies on the same cycle. -/
theorem minimalPeriod_iterate_of_preperiod_le (hx : f^[preperiod f x] x ∈ periodicPts f)
    (hk : preperiod f x ≤ k) : minimalPeriod f (f^[k] x) = eventualPeriod f x := by
  obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le' hk
  rw [iterate_add_apply, minimalPeriod_apply_iterate hx, eventualPeriod]

theorem isPeriodicPt_iterate_iff (hn : n ≠ 0) :
    IsPeriodicPt f n (f^[k] x) ↔ preperiod f x ≤ k ∧ eventualPeriod f x ∣ n := by
  constructor
  · intro hp
    have hk : f^[k] x ∈ periodicPts f := mk_mem_periodicPts (Nat.pos_of_ne_zero hn) hp
    have hle := preperiod_le hk
    refine ⟨hle, ?_⟩
    rw [← minimalPeriod_iterate_of_preperiod_le (iterate_preperiod_mem_periodicPts ⟨k, hk⟩) hle]
    exact hp.minimalPeriod_dvd
  · rintro ⟨hle, hdvd⟩
    have hx : f^[preperiod f x] x ∈ periodicPts f :=
      minimalPeriod_pos_iff_mem_periodicPts.mp (Nat.pos_of_ne_zero (ne_zero_of_dvd_ne_zero hn hdvd))
    rw [isPeriodicPt_iff_minimalPeriod_dvd, minimalPeriod_iterate_of_preperiod_le hx hle]
    exact hdvd

/-- The orbit of `x` repeats with step `n ≠ 0` from time `k` on exactly when `k` is past the
preperiod and `n` is a multiple of the eventual period. In particular `preperiod f x` is the least
such `k` and `eventualPeriod f x` the least such `n`. -/
theorem iterate_add_eq_iterate_iff (hn : n ≠ 0) :
    f^[k + n] x = f^[k] x ↔ preperiod f x ≤ k ∧ eventualPeriod f x ∣ n := by
  rw [← isPeriodicPt_iterate_iff hn, IsPeriodicPt, IsFixedPt, ← iterate_add_apply, add_comm]

theorem iterate_add_eventualPeriod (hk : preperiod f x ≤ k) :
    f^[k + eventualPeriod f x] x = f^[k] x := by
  rcases eq_or_ne (eventualPeriod f x) 0 with h | h
  · rw [h, add_zero]
  · exact (iterate_add_eq_iterate_iff h).mpr ⟨hk, dvd_rfl⟩

/-- The tail and first lap of the cycle consist of distinct points. -/
theorem iterate_injOn_Iio_preperiod_add_eventualPeriod :
    (Iio (preperiod f x + eventualPeriod f x)).InjOn (f^[·] x) := by
  intro i _ j hj heq
  by_contra hne
  wlog hij : i < j generalizing i j
  · exact this hj (by assumption) heq.symm (Ne.symm hne) (by omega)
  obtain ⟨hle, hdvd⟩ := (iterate_add_eq_iterate_iff (k := i) (Nat.sub_ne_zero_of_lt hij)).mp
    (by rw [Nat.add_sub_cancel' hij.le]; exact heq.symm)
  have := Nat.le_of_dvd (Nat.sub_pos_of_lt hij) hdvd
  rw [mem_Iio] at hj
  omega

section Finite

/-- On a finite type, some iterate of every point is periodic (pigeonhole). -/
theorem exists_iterate_mem_periodicPts [Finite α] (f : α → α) (x : α) :
    ∃ n, f^[n] x ∈ periodicPts f := by
  obtain ⟨i, j, hne, heq⟩ := Finite.exists_ne_map_eq_of_infinite (f^[·] x)
  wlog hij : i < j generalizing i j
  · exact this j i hne.symm heq.symm (by omega)
  refine ⟨i, mk_mem_periodicPts (Nat.sub_pos_of_lt hij) ?_⟩
  rw [IsPeriodicPt, IsFixedPt, ← iterate_add_apply, Nat.sub_add_cancel hij.le]
  exact heq.symm

variable [Finite α]

theorem iterate_mem_periodicPts_iff : f^[k] x ∈ periodicPts f ↔ preperiod f x ≤ k := by
  refine ⟨preperiod_le, fun hk => ?_⟩
  have hx := iterate_preperiod_mem_periodicPts (exists_iterate_mem_periodicPts f x)
  rw [← minimalPeriod_pos_iff_mem_periodicPts, minimalPeriod_iterate_of_preperiod_le hx hk,
    eventualPeriod, minimalPeriod_pos_iff_mem_periodicPts]
  exact hx

theorem preperiod_eq_zero_iff : preperiod f x = 0 ↔ x ∈ periodicPts f := by
  rw [← iterate_zero_apply f x, iterate_mem_periodicPts_iff, Nat.le_zero, iterate_zero_apply]

theorem eventualPeriod_pos : 0 < eventualPeriod f x :=
  minimalPeriod_pos_of_mem_periodicPts
    (iterate_preperiod_mem_periodicPts (exists_iterate_mem_periodicPts f x))

theorem _root_.Function.Injective.preperiod_eq_zero (hf : Injective f) : preperiod f x = 0 :=
  preperiod_eq_zero_of_mem_periodicPts (hf.mem_periodicPts x)

/-- **Eventual periodicity.** The orbit of every point of a finite type is ρ-shaped: there are a
unique `m` and `p > 0` such that `f^[k + n] x = f^[k] x` for `n ≠ 0` exactly when `m ≤ k` and
`p ∣ n`. Namely `m = preperiod f x` and `p = eventualPeriod f x`. -/
theorem exists_eventually_periodic (f : α → α) (x : α) :
    ∃ m p, 0 < p ∧ ∀ k n, n ≠ 0 → (f^[k + n] x = f^[k] x ↔ m ≤ k ∧ p ∣ n) :=
  ⟨_, _, eventualPeriod_pos (f := f) (x := x), fun _ _ => iterate_add_eq_iterate_iff⟩

end Finite

theorem preperiod_add_eventualPeriod_le_card [Fintype α] :
    preperiod f x + eventualPeriod f x ≤ Fintype.card α := by
  have := Finset.card_le_card_of_injOn (s := Finset.range (preperiod f x + eventualPeriod f x))
    (t := Finset.univ) (f^[·] x) (fun _ _ => Finset.mem_coe.2 (Finset.mem_univ _))
    (by rw [Finset.coe_range]; exact iterate_injOn_Iio_preperiod_add_eventualPeriod)
  simpa using this

end Rotartsilib

end
