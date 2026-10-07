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

theorem add_left_comm : ∀(a b c : R), a + (b + c) = b + (a + c) := by
  intro a b c
  rw [← Rng.add_assoc, Rng.add_comm a b, Rng.add_assoc]

end Rng


section Ring
variable [Ring R]

@[simp] theorem one_mul : ∀(a : R), 1 * a = a := Ring.one_mul
@[simp] theorem mul_one : ∀(a : R), a * 1 = a := Ring.mul_one

theorem one_unique (n : R) (h : ∀(a : R), n * a = a) : n = 1 := 
  mul_one n ▸ h 1

end Ring


/-!
Some implementation details for how scalar multiplication and powers
are implemented. Not really any mathematical content here.
-/

section HMul
variable [Rng R]

abbrev ℕ := Nat

def nsmul (n : ℕ) (a : R) : R :=
  match n with
  | 0 => 0
  | p+1 => a + nsmul p a

instance : HMul ℕ R R where
  hMul := nsmul 

theorem nsmul_succ {n : ℕ} {a : R} : (n + 1) * a = n * a + a := by
  conv => rhs; rw [Rng.add_comm]
  rfl

theorem nsmul_add {n m : ℕ} {a : R} : (n + m) * a = n * a + m * a := by
  induction n with
  | zero => 
    dsimp; rw [Nat.zero_add]
    change m * a = 0 + m * a
    rw [zero_add]
  | succ p h =>
    have eq : p.succ + m = (p + m) + 1 := by 
      simp [Nat.add_comm, Nat.add_assoc]
    rw [eq, nsmul_succ (n := p + m), h, nsmul_succ (n := p)]
    simp [add_left_comm, Rng.add_comm]

theorem add_nsmul {n m : ℕ} {a : R} : n * a + m * a = (n + m) * a :=
  nsmul_add.symm

end HMul

end
end M402
