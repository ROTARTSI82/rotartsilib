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

end Ring

section CommRng
variable [CommRng R]

theorem mul_left_comm : ∀(a b c : R), a * (b * c) = b * (a * c) := by
  intro a b c
  rw [← Rng.mul_assoc, CommRng.mul_comm a b, Rng.mul_assoc]

end CommRng


/-!
Some implementation details for how scalar multiplication and powers
are implemented. Not really any mathematical content here.
-/

abbrev ℕ := Nat

section HMul
variable [Rng R]

def nsmul (n : ℕ) (a : R) : R :=
  match n with
  | 0 => 0
  | p+1 => a + nsmul p a

instance : HMul ℕ R R where
  hMul := nsmul

variable {a b : R} {n m : ℕ}

@[simp] theorem zero_nsmul : (0 : Nat) * a = 0 := by rfl
theorem succ_nsmul : (n + 1) * a = n * a + a := by
  rw [Rng.add_comm]; rfl

@[simp] theorem nsmul_neg : n * (-a) = -(n * a) := by
  induction n with
  | zero => simp
  | succ p h => rw [succ_nsmul, h, succ_nsmul, neg_distrib]

theorem nsmul_zero : n * (0 : R) = 0 := by
  induction n with
  | zero => simp
  | succ p h => rw [succ_nsmul, add_zero, h]

theorem add_nsmul : n * a + m * a = (n + m) * a := by
  induction n with
  | zero => simp [zero_nsmul] 
  | succ p h =>
    have eq : p.succ + m = (p + m) + 1 := by 
      simp [Nat.add_comm, Nat.add_assoc]
    rw [eq, succ_nsmul (n := p + m), ← h, succ_nsmul (n := p)]
    simp [add_left_comm, Rng.add_comm]

theorem nsmul_add : n * (a + b) = n * a + n * b := by
  induction n with
  | zero => simp
  | succ p h => 
    rw [succ_nsmul, h, succ_nsmul, succ_nsmul]
    simp [add_left_comm, Rng.add_assoc, Rng.add_comm]

theorem mul_nsmul : n * (m * a) = (n * m) * a := by
  induction n with
  | zero => simp [zero_nsmul]
  | succ p h =>
    rw [succ_nsmul, h, Nat.succ_mul, add_nsmul]

end HMul

section HPow 
variable [Ring R]

def npow (a : R) (n : ℕ) : R :=
  match n with
  | 0 => 1
  | p+1 => a * npow a p

instance : HPow R ℕ R where
  hPow := npow

variable {a b : R} {n m : ℕ}

@[simp] theorem pow_zero : a ^ 0 = 1 := by rfl
theorem pow_succ : a ^ (n + 1) = a * a ^ n := by rfl

@[simp] theorem one_nsmul : (1 : ℕ) * a = a := by 
  change nsmul 1 a = a; simp [nsmul]
@[simp] theorem pow_one : a ^ 1 = a := by 
  change npow a 1 = a; simp [npow]

@[simp] theorem one_pow : (1 : R) ^ n = 1 := by
  induction n with
  | zero => rfl
  | succ p h =>
    rw [pow_succ, h, one_mul]

theorem pow_add : a ^ (n + m) = a ^ n * a ^ m := by
  induction n with
  | zero => simp [pow_zero]
  | succ p h =>
    have eq : p.succ + m = (p + m) + 1 := by
      simp [Nat.add_comm, Nat.add_assoc]
    rw [eq, pow_succ, pow_succ, Rng.mul_assoc, h]

theorem pow_mul : (a ^ n) ^ m = a ^ (n * m)  := by
  induction m with
  | zero => simp
  | succ p h => 
    rw [pow_succ, Nat.mul_succ, h, ← pow_add, Nat.add_comm] 

@[simp] theorem zero_pow_succ : (0 : R) ^ (n + 1) = 0 := by
  induction n with
  | zero => simp
  | succ p h => rw [pow_succ, h, mul_zero]


theorem nsmul_mul_left : (n * a) * b = n * (a * b) := by
  induction n with
  | zero => simp
  | succ p h => rw [succ_nsmul, succ_nsmul, ← h, Rng.right_distrib]

theorem nsmul_mul_right : a * (n * b) = n * (a * b) := by
  induction n with
  | zero => simp
  | succ p h => rw [succ_nsmul, succ_nsmul, Rng.left_distrib, h]

@[simp] theorem nsmul_one_mul : (n * (1 : R)) * a = n * a := by
  simp [nsmul_mul_left]

theorem nsmul_mul_nsmul : (n * a) * (m * b) = (n * m) * (a * b) := by
  induction n with
  | zero => simp
  | succ p h =>
    rw [nsmul_mul_left, succ_nsmul, ← nsmul_mul_left, h,
      Nat.succ_mul, ← add_nsmul, nsmul_mul_right]

theorem nsmul_pow : (n * a) ^ m = (n ^ m) * a ^ m := by
  induction m with
  | zero => simp
  | succ p h =>
    rw [pow_succ, pow_succ, Nat.pow_succ, h,
      nsmul_mul_nsmul, Nat.mul_comm]
    
end HPow

section HPowComm
variable [CommRing R]

variable {a b : R} {n m : ℕ}

theorem mul_pow : (a * b) ^ n = a ^ n * b ^ n := by
  induction n with
  | zero => simp
  | succ p h =>
    rw [pow_succ, pow_succ, pow_succ, h]
    simp [mul_left_comm, Rng.mul_assoc]

end HPowComm

end
end M402
