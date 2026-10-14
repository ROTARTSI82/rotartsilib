module

public section

namespace Rotartsilib

universe u

class Nontrivial (R : Type u) : Prop where
  nontrivial : ∃(a b : R), a ≠ b

public abbrev ℕ := Nat
public abbrev ℤ := Int



end Rotartsilib

end
