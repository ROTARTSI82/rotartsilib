module

public import Rotartsilib.«2026».Math402.BasicRings

namespace M402
public section

open Rotartsilib

open M402

universe u v

def Unit {R} [Ring R] (a : R) : Prop :=
  ∃(ainv : R), a * ainv = 1 ∧ ainv * a = 1

def ZeroDivisor {R} [Rng R] (a : R) : Prop :=
  ∃(b : R), b ≠ 0 ∧ (a * b = 0 ∨ b * a = 0)

class IntegralDomain (R : Type u) extends CommRing R where
  integralDomain : ∀(a : R), a ≠ 0 → ¬ZeroDivisor a

class Field (R : Type u) extends CommRing R where
  isUnit : ∀{a : R}, a ≠ 0 → Unit a

variable {R : Type u} {a b c : R}

-- this theorem relies on excluded middle. :(
theorem mul_cancel [Rng R] (ha : ¬ZeroDivisor a)
    (h : a * b = a * c) : b = c := by
  obtain h := congrArg (fun x ↦ x + -(a * c)) h
  rw [add_neg, ← mul_neg, ← Rng.left_distrib] at h
  obtain ha := (forall_not_of_not_exists ha) (b + -c)
  rw [Classical.not_and_iff_not_or_not] at ha
  refine Or.rec (fun hl ↦ ?_) (fun hr ↦ ?_) ha
  · rw [Classical.not_not] at hl
    obtain hl := congrArg (fun x ↦ x + c) hl
    simpa [Rng.add_assoc] using hl
  · rw [not_or] at hr
    exact False.elim <| hr.left h

section Ring
variable [Ring R]

private theorem not_zeroDivisor_and_unit : ¬(Unit a ∧ ZeroDivisor a) := by
  intro hc
  obtain ⟨ainv, mul_inv, inv_mul⟩ := hc.left
  obtain ⟨b, hb, hz⟩ := hc.right
  cases hz with
  | inl h =>
    obtain h := congrArg (fun x ↦ ainv * x) h
    simp [inv_mul, ← Rng.mul_assoc] at h
    exact hb h
  | inr h =>
    obtain h := congrArg (fun x ↦ x * ainv) h
    simp [mul_inv, Rng.mul_assoc] at h
    exact hb h

theorem not_zeroDivisor_of_isUnit (ha : Unit a) : ¬ZeroDivisor a :=
  fun h₂ ↦ not_zeroDivisor_and_unit ⟨ha, h₂⟩

theorem not_isUnit_of_zeroDivisor {a : R} (ha : ZeroDivisor a) : ¬Unit a :=
  fun h₂ ↦ not_zeroDivisor_and_unit ⟨h₂, ha⟩

theorem isUnit_of_not_zeroDivisor {a : R} (ha : ¬ZeroDivisor a) : Unit a := by
  sorry

end Ring

instance {R} [Field R] : IntegralDomain R where
  integralDomain _ ha :=
    not_zeroDivisor_of_isUnit (Field.isUnit ha)

end


section RingHom
variable {R : Type u} {S : Type v} [Rng S] [Rng R]

class RingHom

end RingHom

end M402
