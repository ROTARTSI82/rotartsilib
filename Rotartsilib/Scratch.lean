module

import Mathlib

section
variable {α β}

/- 
#check IsAddUnit

#check α ⊕ β
#check α × β

#check α → β

#check α → Empty-/

end

section 
variable {α : Type} {β : α → Type}

/- 
#check (a : α) → β a
#check Σ(a : α), β a

#check Π(a : α), β a
-/ 

variable {P Q a b : Prop}
variable {N : α → Prop}

/- 
#check ∀(a : α), P

#check a ∧ b
#check a ∨ b
#check a → b
#check ∃(x : α), N x
#check P ∧ Q

#check Eq.rec 

def test (x : List Type) : Nat :=
  match x with
  | [] => 0
  | x::xs => (if x = Nat then 1 else 0)

-/ 

end


theorem contrapos {P Q : Prop} (h : P → Q) : ¬Q → ¬P :=
  fun nq => nq ∘ h

theorem not_p_and_not_p {P : Prop} : ¬(P ∧ ¬P) := 
  fun h => match h with
    | .intro left right => right left


theorem demorgans {P Q : Prop} (h : ¬P ∧ ¬Q) : ¬(P ∨ Q) := by
  refine fun hc => ?_
  refine Or.rec (fun hp => ?_) (fun hq => ?_) hc
  · refine h.left hp
  · refine h.right hq

theorem demorgans' {P Q : Prop} (h : ¬P ∧ ¬Q) : ¬(P ∨ Q) := by
  intro hc
  rcases hc with hp | hq
  · apply h.left
    exact hp
  · apply h.right
    exact hq

  
/-
#check Eq.rec

#check Classical.choice

axiom choice₂ {α : Type} (h : ∃(_ : α), True) : α
#check Exists.choose_spec
#check Exists.intro

#check@ demorgans

-/

def IsEven (n : Nat) : Prop :=
  ∃(k : Nat), 2*k = n

theorem exists_even_v1 : ∃(n : Nat), IsEven n := ⟨2, ⟨1, rfl⟩⟩
theorem exists_even_v2 : ∃(n : Nat), IsEven n := ⟨4, ⟨2, rfl⟩⟩

theorem does_two_equals_four : exists_even_v1.choose = exists_even_v2.choose := rfl


/-
inductive Nonpositive : Type
| mk : (Nonpositive → False) → Nonpositive

def selfApply (b : Nonpositive) : False := 
  match b with
  | .mk f => f b

def val : Nonpositive := Nonpositive.mk selfApply
def falsehood : False := selfApply val
-/



def factorial (t : Nat) : Nat :=
  Nat.rec 1 (fun n prev => (n + 1) * prev) t

def fib (t : Nat) : Nat :=
  match t with
  | 0 => 1
  | n+1 => fib (n - 1) + fib n

def fib₂ (t : Nat) : Nat × Nat :=
  Nat.rec ⟨1, 1⟩ (fun _ prev => ⟨prev.snd, prev.fst + prev.snd⟩) t

/- 
#check WellFounded.fix
#check WellFounded.rec

#eval fib 6
#eval (fib₂ 6).snd

#eval factorial 5  /- still 120 -/

#check Nat.succ_injective

inductive Test : Type where
  | mk : Type → Test

#check Prod
#check ULift
-/

universe u v
inductive ProdTest (α : Type u) (β : Type v) : Type ((max u v)+1) where
  | mk : α → β → ProdTest α β

inductive EqTest { α : Type u } (a : α) : α → Type where
  | refl : EqTest a a

/-
#check EqTest Type Type

#check (Type : Type 3)
-/

def Hom (X : Sort u) (Y : Sort v) : Sort (imax u v) :=
  X → Y

/-
  ∞ 

#check Prod.rec

#check Hom  /- Hom.{u} (X Y : Type u) : Type u -/
#check ((fun x ↦ x + 1) : Hom.{0, 0} Nat Nat)
#check ((fun X ↦ X → Type) : Hom.{1, 2} Type (Type 1))
-/


