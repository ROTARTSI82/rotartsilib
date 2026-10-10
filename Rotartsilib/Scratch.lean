module

import Mathlib

section
variable {α β}

#check IsAddUnit

#check α ⊕ β
#check α × β

#check α → β

#check α → Empty

end

section 
variable {α : Type} {β : α → Type}

#check (a : α) → β a
#check Σ(a : α), β a

-- #check Π(a : α), β a


variable {P Q a b : Prop}
variable {N : α → Prop}

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

end


theorem contrapos {P Q : Prop} (h : P → Q) : ¬Q → ¬P :=
  fun nq => nq ∘ h

theorem not_p_and_not_p {P : Prop} : ¬(P ∧ ¬P) := 
  fun h => match h with
    | .intro left right => right left

theorem demorgans {P Q : Prop} (h : ¬P ∧ ¬Q) : ¬(P ∨ Q) :=
  fun hc => match hc with
    | .inl hp => h.left hp
    | .inr hq => h.right hq 

#check@ demorgans

