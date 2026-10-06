module

public import Mathlib

/-!
this is a formalization of https://discord.com/channels/687491241793159223/887035729975324732/1537253316910780488

> Prove that a continuous function on R with a periodic point must have a fixed point
> periodic point meaning some point such that f(f(...f(x_0))))) = x_0

special case of Sharkovskii's Theorem.

-/

public section

open Function

universe u
variable {α : Type*}

theorem strictMono_nat_iff [Preorder α] {f : ℕ → α} :
    StrictMono f ↔ ∀ n, f n < f (n + 1) :=
  ⟨fun h n ↦ h (Nat.lt_succ_self n), strictMono_nat_of_lt_succ⟩

theorem strictAnti_nat_iff [Preorder α] {f : ℕ → α} :
    StrictAnti f ↔ ∀ n, f (n + 1) < f n :=
  ⟨fun h n ↦ h (Nat.lt_succ_self n), strictAnti_nat_of_succ_lt⟩

theorem monotone_nat_iff [Preorder α] {f : ℕ → α} :
    Monotone f ↔ ∀ n, f n ≤ f (n + 1) :=
  ⟨fun h n ↦ h (Nat.le_succ n), monotone_nat_of_le_succ⟩

theorem antitone_nat_iff [Preorder α] {f : ℕ → α} :
    Antitone f ↔ ∀ n, f (n + 1) ≤ f n :=
  ⟨fun h n ↦ h (Nat.le_succ n), antitone_nat_of_succ_le⟩

variable {f : α → α} {x : α}

theorem iterate_not_monotone_of_mem_periodicPts [PartialOrder α]
    (hx : x ∈ periodicPts f) (hnfix : ¬IsFixedPt f x) :
    ¬Monotone (f^[·] x) := by
  intro h
  obtain ⟨n, hn, (hp : f^[n] x = x)⟩ := hx
  refine hnfix <| le_antisymm ?_ (h (Nat.zero_le 1))
  simpa [hp] using h hn

theorem exists_map_lt_of_mem_periodicPts [LinearOrder α]
    (hx : x ∈ periodicPts f) (hnfix : ¬IsFixedPt f x) :
    ∃ b ∈ periodicOrbit f x, f b < b := by
  have h := iterate_not_monotone_of_mem_periodicPts hx hnfix
  rw [monotone_nat_iff] at h
  push Not at h
  obtain ⟨n, hn⟩ := h
  refine ⟨f^[n] x, iterate_mem_periodicOrbit hx n, ?_⟩
  rwa [iterate_succ'] at hn

theorem exists_lt_map_of_mem_periodicPts [LinearOrder α]
    (hx : x ∈ periodicPts f) (hnfix : ¬IsFixedPt f x) :
    ∃ b ∈ periodicOrbit f x, b < f b :=
  exists_map_lt_of_mem_periodicPts (α := αᵒᵈ) hx hnfix

end
