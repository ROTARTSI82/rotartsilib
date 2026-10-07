module

namespace M402
public section

universe u

variable (R : Type u)

class Rng extends Add R, Mul R, Zero R, Neg R where
  add_zero : ∀(a : R), a + 0 = a
  add_comm : ∀(a b : R), a + b = b + a
  add_assoc : ∀(a b c : R), (a + b) + c = a + (b + c)
  mul_assoc : ∀(a b c : R), (a * b) * c = a * (b * c)
  left_distrib : ∀(a b c : R), a * (b + c) = a * b + a * c
  add_neg : ∀(a : R), a + (-a) = 0 

class CommRng extends Rng R where
  mul_comm : ∀(a b : R), a * b = b * a 

class Ring extends Rng R, One R where
  one_mul : ∀(a : R), 1 * a = a

class CommRing extends Ring R, CommRng R

variable {R}

section Rng
variable [Rng R]
open Rng

theorem zero_add : ∀(a : R), 0 + a = a := by intro _; rw [add_comm, add_zero]
theorem neg_add : ∀(a : R), (-a) + a = 0 := by intro _; rw [add_comm, add_neg]

theorem zero_unique (z : R) (h : ∀(a : R), a + z = a) : z = 0 := 
  zero_add z ▸ h 0

theorem neg_unique (a : R) (n : R) (h : a + n = 0) : n = -a := by
  have h' := congrArg (fun x => x + -a) h
  rwa [add_comm, ← add_assoc, neg_add, zero_add, zero_add] at h'

theorem neg_zero : -(0 : R) = 0 := by
  have h := add_zero (0 : R)
  exact (neg_unique (0 : R) (0 : R) h).symm

theorem mul_neg : ∀(a b : R), a * (-b) = -(a * b) := by
  intro a b
  sorry

theorem neg_mul : ∀(a b : R), (-a) * b = -(a * b) := by
  intro a b
  sorry

theorem right_distrib : ∀(a b c : R), (a + b) * c = a * c + b * c := by
  sorry

theorem mul_zero : ∀(a : R), a * 0 = 0 := by
  intro a
  calc a * 0
    _ = a * (a + -a) := by rw [← add_neg]
    _ = a * a + a * (-a) := by rw [left_distrib]
    _ = 0 := by rw [mul_neg, add_neg]

theorem zero_mul : ∀(a : R), 0 * a = 0 := by
  intro a
  calc 0 * a
    _ = (a + -a) * a := by rw [← add_neg]
    _ = a * a + (-a) * a := by rw [right_distrib]
    _ = 0 := by rw [neg_mul, add_neg]
 
end Rng



section Ring
variable [Ring R]

theorem one_unique (n : R) (h : ∀(a : R), n * a = a) : n = 1 := by
  have test := h 1
  sorry

theorem mul_one : ∀(a : R), a * 1 = a := by
  sorry

end Ring


end
end M402
