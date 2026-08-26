def IsEven (n : Nat) : Prop :=
  ∃(k : Nat), 2*k = n

theorem mul {a b : Nat} (ha : IsEven a)
    (hb : IsEven b) : IsEven (a*b) := by
  unfold IsEven at *
  obtain ⟨ka, ha⟩ := ha
  obtain ⟨kb, hb⟩ := hb
  refine ⟨2*ka*kb, ?_⟩
  grind

#check @mul
