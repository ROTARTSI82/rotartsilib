module

public import Rotartsilib.«2026».Math402.BasicRings

namespace M402
public section


/-!
Some implementation details for how scalar multiplication and powers
are implemented.
-/

abbrev ℕ := Nat
abbrev ℤ := Int

section HMul
variable [Rng R]

def nsmul (n : ℕ) (a : R) : R :=
  match n with
  | 0 => 0
  | p+1 => a + nsmul p a

instance : HMul ℕ R R where
  hMul := nsmul


variable {a b : R} {n m : ℕ}

@[simp] theorem zero_nsmul : (0 : ℕ) * a = 0 := by rfl
@[simp] theorem one_nsmul : (1 : ℕ) * a = a := by change a + 0 = a; simp
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

theorem nsmul_mul_left : (n * a) * b = n * (a * b) := by
  induction n with
  | zero => simp
  | succ p h => rw [succ_nsmul, succ_nsmul, ← h, Rng.right_distrib]

theorem nsmul_mul_right : a * (n * b) = n * (a * b) := by
  induction n with
  | zero => simp
  | succ p h => rw [succ_nsmul, succ_nsmul, Rng.left_distrib, h]

theorem nsmul_mul_nsmul : (n * a) * (m * b) = (n * m) * (a * b) := by
  induction n with
  | zero => simp
  | succ p h =>
    rw [nsmul_mul_left, succ_nsmul, ← nsmul_mul_left, h,
      Nat.succ_mul, ← add_nsmul, nsmul_mul_right]


def zsmul (z : ℤ) (a : R) : R :=
  match z with
  | Int.ofNat n => n * a
  | Int.negSucc n => -((n + 1) * a)

instance : HMul ℤ R R where
  hMul := zsmul

variable {i j : ℤ}


@[simp] theorem zero_zsmul : (0 : ℤ) * a = 0 := by rfl
@[simp] theorem one_zsmul : (1 : ℤ) * a = a := by change (1 : ℕ) * a = a; simp
@[simp] theorem neg_one_zsmul : (-1 : ℤ) * a = -a := by change -((1 : ℕ) * a) = -a; simp


@[simp] theorem ofNat_zsmul : (n : ℤ) * a = n * a := by rfl
@[simp] theorem ofNat_zsmul' : (Int.ofNat n) * a = n * a := by rfl
theorem negSucc_zsmul : (Int.negSucc n) * a = -((n+1)*a) := by rfl

theorem zsmul_add : i * (a + b) = i * a + i * b := by
  cases i <;> simp [negSucc_zsmul, nsmul_add, succ_nsmul, neg_distrib, add_left_comm, Rng.add_comm, Rng.add_assoc]

@[simp] theorem neg_ofNat_zsmul : (-n : ℤ) * a = -(n * a) := by
  induction n with
  | zero => simp
  | succ p h =>
    -- weird, don't use the inductive hypothesis here.
    -- just cases for n = 0 and n > 0
    simp only [Nat.succ_eq_add_one, Int.natCast_add, Int.cast_ofNat_Int, succ_nsmul]
    rw [neg_distrib, Int.ofNat_add_one_out, Int.neg_ofNat_succ, negSucc_zsmul, succ_nsmul, neg_distrib]

theorem subNatNat_zsmul (n m : ℕ) : (Int.subNatNat n m) * a = n * a + -(m * a) := by
  refine Int.subNatNat_elim n m (fun x y s => s * a = x * a + -(y * a)) ?_ ?_
  · intro i n
    rw [ofNat_zsmul, ← add_nsmul, Rng.add_comm, ← Rng.add_assoc]
    simp
  · intro i m
    rw [negSucc_zsmul, succ_nsmul, succ_nsmul, ← add_nsmul]
    repeat rw [neg_distrib]
    rw [Rng.add_assoc, ← Rng.add_assoc (a := m*a), add_neg, zero_add]

@[simp] theorem zsmul_neg : i * (-a) = -(i * a) := by cases i <;> simp [negSucc_zsmul]
theorem zsmul_zero : i * (0 : R) = 0 := by cases i <;> simp [negSucc_zsmul, nsmul_zero]

theorem add_zsmul : i * a + j * a = (i + j) * a := by
  cases i <;> cases j
  · simp [← Int.natCast_add, add_nsmul]
  · simp only [Int.ofNat_eq_natCast, ofNat_zsmul]
    rw [Int.ofNat_add_negSucc, subNatNat_zsmul, negSucc_zsmul]
  · simp only [Int.ofNat_eq_natCast, ofNat_zsmul]
    rw [Int.add_comm, Int.ofNat_add_negSucc, subNatNat_zsmul,
        negSucc_zsmul, succ_nsmul, neg_distrib]
    simp [Rng.add_comm]
  · simp only [negSucc_zsmul, succ_nsmul, Int.negSucc_add_negSucc]
    rw [← add_nsmul]
    simp [neg_distrib, add_left_comm, Rng.add_comm, Rng.add_assoc]

theorem zsmul_nsmul : i * (n * a) = (i * (n : ℤ)) * a := by
  cases i
  · simp [← Int.natCast_mul, mul_nsmul]
  · rw [negSucc_zsmul, Int.negSucc_mul_ofNat, neg_ofNat_zsmul, mul_nsmul]

theorem nsmul_zsmul : n * (i * a) = (i * (n : ℤ)) * a := by
  cases i
  · simp [← Int.natCast_mul, mul_nsmul, Nat.mul_comm]
  · rw [negSucc_zsmul, Int.negSucc_mul_ofNat, neg_ofNat_zsmul]
    rw [nsmul_neg, mul_nsmul]
    simp [Nat.mul_succ, Nat.succ_mul, Nat.mul_comm]

theorem mul_zsmul : i * (j * a) = (i * j) * a := by
  cases i <;> cases j
  · simp only [Int.ofNat_eq_natCast, ofNat_zsmul, mul_nsmul]
    rw [← Int.natCast_mul, ofNat_zsmul]
  · simp only [Int.ofNat_eq_natCast, negSucc_zsmul, zsmul_neg, ofNat_zsmul]
    rw [Int.ofNat_mul_negSucc, neg_ofNat_zsmul, mul_nsmul]
  · rw [negSucc_zsmul, ofNat_zsmul', Int.ofNat_eq_natCast,
        Int.negSucc_mul_ofNat, neg_ofNat_zsmul]
    simp [mul_nsmul]
  · repeat rw [negSucc_zsmul]
    rw [Int.negSucc_mul_negSucc, ← Int.natCast_mul, ofNat_zsmul]
    rw [nsmul_neg, neg_neg, mul_nsmul]

theorem zsmul_mul_left : (i * a) * b = i * (a * b) := by
  cases i
  · simp [nsmul_mul_left]
  · simp only [negSucc_zsmul, succ_nsmul, neg_distrib, Rng.right_distrib]
    repeat rw [neg_mul]
    rw [nsmul_mul_left]

theorem zsmul_mul_right : a * (i * b) = i * (a * b) := by
  cases i
  · simp [nsmul_mul_right]
  · simp only [negSucc_zsmul, succ_nsmul, neg_distrib, Rng.left_distrib]
    repeat rw [mul_neg]
    rw [nsmul_mul_right]

theorem zsmul_mul_zsmul : (i * a) * (j * b) = (i * j) * (a * b) := by
  cases i <;> cases j
  · simp [← Int.natCast_mul, nsmul_mul_nsmul]
  · simp only [negSucc_zsmul, Int.ofNat_eq_natCast,
        Int.ofNat_mul_negSucc, ofNat_zsmul, neg_ofNat_zsmul, mul_neg, nsmul_mul_nsmul]
  · simp only [negSucc_zsmul, Int.ofNat_eq_natCast,
        Int.negSucc_mul_ofNat, ofNat_zsmul, neg_ofNat_zsmul, neg_mul, nsmul_mul_nsmul]
  · simp only [negSucc_zsmul, neg_mul_neg]
    rw [Int.negSucc_mul_negSucc]
    rw [← Int.natCast_mul, nsmul_mul_nsmul, ofNat_zsmul]

end HMul

/- section Coe
variable [Ring R]

instance : Coe ℕ R where
  coe n := n * (1 : R)

instance : Coe ℤ R where
  coe z := z * (1 : R)

end Coe -/

section HPow
variable [Ring R]

def npow (a : R) (n : ℕ) : R :=
  match n with
  | 0 => 1
  | p+1 => a * npow a p

instance : HPow R ℕ R where
  hPow := npow

variable {a b : R} {n m : ℕ}

@[simp] theorem nsmul_one_mul : (n * (1 : R)) * a = n * a := by
  simp [nsmul_mul_left]

@[simp] theorem pow_zero : a ^ 0 = 1 := by rfl
theorem pow_succ : a ^ (n + 1) = a * a ^ n := by rfl

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

theorem nsmul_pow : (n * a) ^ m = (n ^ m) * a ^ m := by
  induction m with
  | zero => simp
  | succ p h =>
    rw [pow_succ, pow_succ, Nat.pow_succ, h,
      nsmul_mul_nsmul, Nat.mul_comm]

theorem zsmul_pow {i : ℤ} : (i * a) ^ m = (i ^ m) * a ^ m := by
  induction m with
  | zero => simp
  | succ p h =>
    rw [pow_succ, pow_succ, Int.pow_succ, h,
        zsmul_mul_zsmul, Int.mul_comm]

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
