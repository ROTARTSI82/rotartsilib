module

public import Rotartsilib.Utils

namespace M402
public section

open Rotartsilib

universe u

variable (R : Type u)

class Rng extends Add R, Mul R, Zero R, Neg R where
  add_zero : ∀(a : R), a + 0 = a
  add_comm : ∀(a b : R), a + b = b + a
  add_assoc : ∀(a b c : R), (a + b) + c = a + (b + c)
  mul_assoc : ∀(a b c : R), (a * b) * c = a * (b * c)
  left_distrib : ∀(a b c : R), a * (b + c) = a * b + a * c
  right_distrib : ∀(a b c : R), (a + b) * c = a * c + b * c
  add_neg : ∀(a : R), a + (-a) = 0

class CommRng extends Rng R where
  mul_comm : ∀(a b : R), a * b = b * a

class Ring extends Rng R, One R where
  one_mul : ∀(a : R), 1 * a = a
  mul_one : ∀(a : R), a * 1 = a

class CommRing extends Ring R, CommRng R

variable {R}

section Rng
variable [Rng R]
open Rng

@[simp] theorem add_zero : ∀(a : R), a + 0 = a := Rng.add_zero
@[simp] theorem add_neg : ∀(a : R), a + (-a) = 0 := Rng.add_neg
@[simp] theorem zero_add : ∀(a : R), 0 + a = a := by intro _; rw [add_comm, add_zero]
@[simp] theorem neg_add : ∀(a : R), (-a) + a = 0 := by intro _; rw [add_comm, add_neg]

theorem zero_unique {z : R} (h : ∀(a : R), a + z = a) : z = 0 :=
  zero_add z ▸ h 0

theorem neg_unique {a : R} {n : R} (h : a + n = 0) : n = -a := by
  have h' := congrArg (fun x => x + -a) h
  rwa [add_comm, ← add_assoc, neg_add, zero_add, zero_add] at h'

@[simp] theorem mul_zero : ∀(a : R), a * 0 = 0 := by
  intro a
  have h : a * 0 = a * 0 + a * 0 := by
    rw [← left_distrib, add_zero]
  have h' := congrArg (fun x => x + -(a * 0)) h |>.symm
  rwa [add_neg, add_assoc, add_neg, add_zero] at h'

@[simp] theorem zero_mul : ∀(a : R), 0 * a = 0 := by
  intro a
  have h : 0 * a = 0 * a + 0 * a := by
    rw [← right_distrib, add_zero]
  have h' := congrArg (fun x => x + -(0 * a)) h |>.symm
  rwa [add_neg, add_assoc, add_neg, add_zero] at h'

theorem mul_neg : ∀(a b : R), a * (-b) = -(a * b) := by
  intro a b
  have h : a * b + a * (-b) = 0 := by
    rw [← left_distrib, add_neg, mul_zero]
  exact neg_unique h

theorem neg_mul : ∀(a b : R), (-a) * b = -(a * b) := by
  intro a b
  have h : a * b + (-a) * b = 0 := by
    rw [← right_distrib, add_neg, zero_mul]
  exact neg_unique h

@[simp] theorem neg_zero : -(0 : R) = 0 :=
  (neg_unique <| add_zero (0 : R)).symm

@[simp] theorem neg_neg {a : R} : -(-a) = a := by
  refine (neg_unique ?_).symm
  rw [add_comm, add_neg]

@[simp] theorem neg_mul_neg {a b : R} : (-a) * (-b) = a * b := by
  simp [mul_neg, neg_mul]

theorem add_left_comm : ∀(a b c : R), a + (b + c) = b + (a + c) := by
  intro a b c
  rw [← Rng.add_assoc, Rng.add_comm a b, Rng.add_assoc]

theorem add_inj {a b c : R} : a + c = b + c ↔ a = b := by
  constructor
  · intro h
    simpa [add_assoc] using congrArg (fun x => x + -c) h
  · intro h; rw [h]

theorem neg_distrib : ∀(a b : R), -(a + b) = (-a) + (-b) := by
  intro a b
  have h₁ : ((-a) + (-b)) + (a + b) = 0 := by
    rw [Rng.add_comm a b, Rng.add_assoc]
    simp [Rng.add_comm, Rng.add_assoc]
  have h₂ : -(a + b) + (a + b) = 0 := by simp [add_comm]
  rw [← h₁] at h₂
  rwa [add_inj] at h₂

end Rng


section Ring
variable [Ring R]

@[simp] theorem one_mul : ∀(a : R), 1 * a = a := Ring.one_mul
@[simp] theorem mul_one : ∀(a : R), a * 1 = a := Ring.mul_one

theorem one_unique (n : R) (h : ∀(a : R), n * a = a) : n = 1 :=
  mul_one n ▸ h 1

theorem zero_neq_one : Nontrivial R ↔ 0 ≠ (1 : R) := by
  constructor
  · intro ⟨a, b, hneq⟩
    intro hc
    have ha := congrArg (fun x => x * a) hc
    have hb := congrArg (fun x => x * b) hc
    rw [zero_mul, one_mul] at *
    exact hneq (ha ▸ hb)
  · intro h
    exact ⟨0, 1, h⟩

end Ring

section CommRng
variable [CommRng R]

theorem mul_left_comm : ∀(a b c : R), a * (b * c) = b * (a * c) := by
  intro a b c
  rw [← Rng.mul_assoc, CommRng.mul_comm a b, Rng.mul_assoc]

end CommRng

end
end M402
