def hello := "world"

def IsEven (n : Nat) : Prop :=
  ∃(k : Nat), 2*k = n

theorem mul {a b : Nat} (ha : IsEven a)
    (hb : IsEven b) : IsEven (a*b) := by
  unfold IsEven at *
  obtain ⟨ka, ha⟩ := ha
  obtain ⟨kb, hb⟩ := hb
  refine ⟨2*ka*kb, ?_⟩
  grind

universe u v

@[ext]
structure RelationSet (X : Sort u) (Y : Sort v) where
  rel : X → Y → Prop
  total : ∀(x : X), {y : Y // rel x y}
  unique : ∀(x : X), ∀(y₁ y₂ : Y),
    rel x y₁ → rel x y₂ → y₁ = y₂

def RelationSet.fromFunc {X Y} (f : X → Y) : RelationSet X Y where
  rel := fun x y => f x = y
  total := fun x => ⟨f x, rfl⟩
  unique := fun x y₁ y₂ h₁ h₂ => by
    rwa [h₁] at h₂

def RelationSet.toFunc {X Y} (s : RelationSet X Y) : X → Y :=
  fun x => (s.total x).val

theorem RelationSet.heq_total {X Y} {rel₁ rel₂ : X → Y → Prop}
    (h_rel : rel₁ = rel₂)
    (t₁ : ∀ x, {y // rel₁ x y})
    (t₂ : ∀ x, {y // rel₂ x y})
    (h_val : ∀ x, (t₁ x).val = (t₂ x).val) :
    HEq t₁ t₂ := by
  subst h_rel
  have : t₁ = t₂ := by
    apply funext; intro x
    apply Subtype.ext
    exact h_val x
  rw [this]

theorem iso₁ {X Y} (f : X → Y) :
    (RelationSet.fromFunc f).toFunc = f := by
  rfl

theorem iso₂ {X Y} (s : RelationSet X Y) :
    RelationSet.fromFunc s.toFunc = s := by
  cases s with
  | mk rel total unique =>
    have h_rel : (fun x y => (total x).val = y) = rel := by
      apply funext; intro x; apply funext; intro y; apply propext
      constructor
      · intro h; rw [← h]; exact (total x).property
      · intro h; exact unique x (total x).val y (total x).property h
    apply RelationSet.ext
    · exact h_rel
    · apply RelationSet.heq_total h_rel
      intro x
      rfl

#print axioms iso₂
