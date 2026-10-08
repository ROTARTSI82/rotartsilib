module

public import Mathlib

namespace M402

public section

theorem freshmans_dream {p : ℕ} (hp : Nat.Prime p) (x y : ZMod p) : (x + y)^p = x^p + y^p := by
  -- binomial theorem: p ∣ Binom p k for prime p (see HW1)
  let : Fact (Nat.Prime p) := ⟨hp⟩
  exact add_pow_char (R := ZMod p) x y p

end

end M402
