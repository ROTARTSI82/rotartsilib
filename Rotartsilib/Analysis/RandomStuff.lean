import Mathlib

/-!
this is a formalization of https://discord.com/channels/687491241793159223/887035729975324732/1537253316910780488

> Prove that a continuous function on R with a periodic point must have a fixed point
> periodic point meaning some point such that f(f(...f(x_0))))) = x_0

special case of Sharkovskii's Theorem.

-/

section

open Function

universe u



theorem iterate_not_monotone_of_periodic_of_not_fixed {α : Type u} [PartialOrder α]
    {f : α → α} {x : α} (hperiod : x ∈ f.periodicPts)
    (hnotfixed : f x ≠ x) : ¬Monotone (fun n : ℕ => f^[n] x) := by
  intro h
  obtain ⟨n, hn, (hp : f^[n] x = x)⟩ := mem_periodicPts.mpr hperiod
  exact hnotfixed <| le_antisymm_iff.mpr
    ⟨by simpa [hp] using h hn, h (Nat.zero_le 1)⟩

theorem iterate_not_antitone_of_periodic_of_not_fixed {α : Type u} [PartialOrder α]
    {f : α → α} {x : α} (hperiod : x ∈ f.periodicPts)
    (hnotfixed : f x ≠ x) : ¬Antitone (fun n : ℕ => f^[n] x) :=
  iterate_not_monotone_of_periodic_of_not_fixed (α := αᵒᵈ) hperiod hnotfixed

theorem monotone_nat_iff {α : Type*} [Preorder α] {u : ℕ → α} :
    Monotone u ↔ ∀ n, u n ≤ u (n + 1) :=
  ⟨fun h n => h (Nat.le_succ n), monotone_nat_of_le_succ⟩

theorem antitone_nat_iff {α : Type*} [Preorder α] {u : ℕ → α} :
    Antitone u ↔ ∀ n, u (n + 1) ≤ u n :=
  ⟨fun h n => h (Nat.le_succ n), antitone_nat_of_succ_le⟩

theorem exists_of_not_monotone {α : Type*} [LinearOrder α] {u : ℕ → α} :
    ¬Monotone u ↔ ∃(b : ℕ), u (b + 1) < u b := by
  constructor
  · intro h
    rw [monotone_nat_iff] at h
    push Not at h
    exact h
  · intro ⟨n, hn⟩
    rw [monotone_nat_iff]
    push Not
    exact ⟨n, hn⟩

theorem exists_of_not_antitone {α : Type*} [LinearOrder α] {u : ℕ → α} :
    ¬Antitone u ↔ ∃(b : ℕ), u b < u (b + 1) := by
  constructor
  · intro h
    rw [antitone_nat_iff] at h
    push Not at h
    exact h
  · intro ⟨n, hn⟩
    rw [antitone_nat_iff]
    push Not
    exact ⟨n, hn⟩

theorem exists_lt_self_of_periodic_of_not_fixed {α : Type u} [LinearOrder α]
    {f : α → α} {x : α} (hperiod : x ∈ f.periodicPts)
    (hnotfixed : f x ≠ x) : ∃(b : α), b ∈ f.periodicOrbit x ∧ f b < b:= by
  have h := iterate_not_monotone_of_periodic_of_not_fixed hperiod hnotfixed
  by_contra h'
  push Not at h'
  obtain ⟨b, hb⟩ := exists_of_not_monotone.mp h
  simp only [iterate_succ', comp_apply] at hb
  have h₂ := h' (f^[b] x) (iterate_mem_periodicOrbit hperiod b)
  exact (not_lt.mpr <| h₂) hb

theorem exists_self_lt_of_periodic_of_not_fixed {α : Type u} [LinearOrder α]
    {f : α → α} {x : α} (hperiod : x ∈ f.periodicPts)
    (hnotfixed : f x ≠ x) : ∃(b : α), b ∈ f.periodicOrbit x ∧ b < f b := by
  have h := iterate_not_antitone_of_periodic_of_not_fixed hperiod hnotfixed
  by_contra h'
  push Not at h'
  obtain ⟨b, hb⟩ := exists_of_not_antitone.mp h
  simp only [iterate_succ', comp_apply] at hb
  have h₂ := h' (f^[b] x) (iterate_mem_periodicOrbit hperiod b)
  exact (not_lt.mpr <| h₂) hb

theorem exists_fixed_pt_of_continuous_of_periodic_pt
    {f : ℝ → ℝ} (hf : Continuous f)
    {x₀ : ℝ} (hx₀ : x₀ ∈ f.periodicPts) : ∃(b : ℝ), f b = b := by
  by_cases hfixed : f x₀ = x₀
  · use x₀
  obtain ⟨a, hamem, ha⟩ := exists_self_lt_of_periodic_of_not_fixed hx₀ hfixed
  obtain ⟨b, hbmem, hb⟩ := exists_lt_self_of_periodic_of_not_fixed hx₀ hfixed
  let g (x : ℝ) := f x - x
  have hg : Continuous g := hf.sub continuous_id
  have hivt := intermediate_value_uIcc (a := a) (b := b) hg.continuousOn
  have h0 : (0 : ℝ) ∈ Set.uIcc (g a) (g b) := by
    rw [Set.mem_uIcc]
    right
    constructor <;> dsimp [g] <;> linarith
  obtain ⟨c, hc_mem, hcg⟩ := hivt h0
  use c
  dsimp [g] at hcg
  linarith

end

