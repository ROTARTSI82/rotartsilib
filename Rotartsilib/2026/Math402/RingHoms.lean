module

public import Rotartsilib.«2026».Math402.ZInitial


public section
namespace M402

universe u v

variable (R : Type u) (S : Type v)

section Rng
variable [Rng R] [Rng S]

structure RingHom where
  toFun : R → S
  map_add {a b : R} : toFun (a + b) = toFun a + toFun b
  map_mul {a b : R} : toFun (a * b) = toFun a * toFun b

instance : CoeFun (RingHom R S) (fun _ ↦ R → S) where
  coe hom := hom.toFun

variable {R S}

@[simp]
theorem map_zero {f : RingHom R S} : f 0 = 0 := by
  have h : f 0 = f 0 + f 0 := by
    conv => left; rw [← zero_add 0, RingHom.map_add]
  simpa [Rng.add_assoc] using congrArg (fun x ↦ x + -f 0) h.symm

theorem map_neg {f : RingHom R S} {a : R} : f (-a) = -f a := by
  have h : f a + f (-a) = f a + -f a := by
    conv => left; rw [← RingHom.map_add]
    simp
  refine neg_unique ?_
  simpa using h


end Rng

variable {R S} [Ring R] [Ring S]

theorem map_one_of_surjective {f : RingHom R S} (h : Function.Surjective f)
    : f 1 = 1 := by
  refine one_unique (f 1) ?_
  intro s
  obtain ⟨r, hr⟩ := h s
  rw [← hr, ← RingHom.map_mul, one_mul]


end M402
end
