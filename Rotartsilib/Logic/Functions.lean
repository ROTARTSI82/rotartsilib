import Mathlib.Tactic

universe u v
variable {X : Sort u} {Y : Sort v}

/--
Depends on AOC to construct a right inverse given surjectivity.
Axioms: `Classical.choice` and `Quot.sound`.
In Mathlib as `Function.HasRightInverse.Surjective` and `Function.Surjective.hasRightInverse`
-/
theorem surjective_iff_right_inverse {f : X → Y} :
    f.Surjective ↔ ∃(g : Y → X), f ∘ g = id := by
  constructor
  · intro hf
    use fun y => (hf y).choose
    ext y; dsimp
    rw [hf y |>.choose_spec]
  · intro ⟨g, hg⟩ y
    use g y
    change (f ∘ g) y = id y
    rw [hg]

/---
Does not require hard AOC but does require membership in the image to be decidable. Still depends on `Classical.choice` :(
Mathlib: `Function.HasLeftInverse.Injective`  and `Function.Injective.exists_leftInverse`
--/
theorem injective_iff_left_inverse {f : X → Y} [hx : Nonempty X] :
    f.Injective ↔ ∃(g : Y → X), g ∘ f = id := by
  constructor
  · intro hf
    classical
    let g (y : Y) : X :=
      if h : ∃(x : X), f x = y
      then h.choose else Classical.choice hx
    use g; ext x
    unfold g; dsimp
    have h : ∃(x₁ : X), f x₁ = f x := ⟨x, rfl⟩
    rw [dite_eq_left h]
    exact hf h.choose_spec
  · intro ⟨g, hg⟩ x₁ x₂ h
    obtain heq := congrArg g h
    change (g ∘ f) x₁ = (g ∘ f) x₂ at heq
    rwa [hg] at heq

--- Does not depend on any axioms! Very constructive.
theorem cantor {X : Type u} (f : X → Set X) : ¬f.Surjective := by
  intro hf
  let diag (x : X) := ¬f x x
  let ⟨x, hx⟩ := hf diag
  have h : ¬diag x := by
    intro h₁
    have h₂ := hx ▸ h₁
    unfold diag at h₁
    exact h₁ h₂
  have h' : diag x := by
    unfold diag
    rwa [hx]
  exact h h'
