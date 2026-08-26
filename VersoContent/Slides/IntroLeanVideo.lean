import VersoSlides
import Verso.Doc.Concrete

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "A Guide to Inductive Types" =>

# Lean Tutorial 1: The Curry-Howard Correspondence

# Basic Syntax & Functions
%%%
vertical := true
%%%

```lean
-- !fragment fadeUp 1
-- this is a comment

/- this is a
 multi-line comment -/

/-- this is documentation. `code`, _formatting_. -/
def hello : String := "world"
--  ^ !click 2

-- !fragment fadeUp 3
def luckyNumber (s : String) (n : Nat) : String :=
  s ++ " has a lucky number of " ++ (toString n)

-- !fragment fadeUp 4
#check luckyNumber
#eval luckyNumber "Aeneas" 5
#eval luckyNumber "Dido" 2
```

## Currying
```lean
-- !fragment fadeUp 1
def add (a b : Nat) : Nat :=
--                     ^ !click 5
  a + b

-- !fragment fadeUp 2
def add₂ : Nat → (Nat → Nat) :=
--   ^ !click 3
  fun a => (fun b => a + b)

-- !fragment fadeUp 4
#check add₂ 5
#eval (add₂ 5) 2
#eval add₂ 5 2
```

# `Type`: The Type of Types
%%%
vertical := true
%%%

:::fragment fadeUp
```lean -stretch
def myList : List Nat := [1, 2, 3]

#check List.{0}
```
:::

:::fragment fadeUp
```lean -stretch
def reverseList (α : Type) (input : List α) : List α :=
  match input with
  | [] => []
  | x::xs => (reverseList α xs) ++ [x]

-- !fragment fadeUp
#eval reverseList Nat myList
#eval reverseList String ["a", "b", "c"]
```
:::

## Implicit Parameters

```lean -stretch
def reverseList₂ {α : Type} (input : List α) : List α :=
  reverseList α input

-- !fragment fadeUp
#eval reverseList₂ myList
#eval reverseList₂ ["a", "b", "c"]
#check @reverseList₂ Nat
```

:::fragment fadeUp
```lean -stretch
#eval reverseList _ myList
#eval reverseList _ ["a", "b", "c"]
```
:::

# Inductive Types
%%%
vertical := true
%%%

```lean
inductive Color : Type where
| red : Color
| green : Color
| blue : Color

-- !fragment fadeUp
def toHexCode (c : Color) : String :=
  match c with
  | .red => "ff0000"
  | .green => "00ff00"
  | .blue => "0000ff"

-- !fragment fadeUp
#eval toHexCode Color.red
#eval toHexCode Color.green
#eval toHexCode Color.blue
```

## More Inductive Types
```lean
inductive Opt (α : Type) : Type where
| some : α → Opt α
-- ^ !click
| none : Opt α

-- !fragment fadeUp
def greet (name : Opt String) : String :=
  match name with
  | .some n => "curse you, " ++ n
  | .none => "nobody is attacking me!"

-- !fragment fadeUp
#eval greet Opt.none
#eval greet (Opt.some "Odysseus")
```

# Propositions
%%%
vertical := true
%%%

:::fragment fadeUp
```lean -stretch
#check 2 + 2 = 5
```
:::
:::fragment fadeUp
```lean -stretch
#check Prop
```
:::
:::fragment fadeUp
```lean -stretch
#check (Eq.refl 4 : 2 + 2 = 4)
```
:::
:::fragment fadeUp
```lean -stretch
inductive Eq₂ {α : Type} : α → α → Prop where
| refl (a : α) : Eq₂ a a
-- ^ !click
```
:::
:::fragment fadeUp
```lean -stretch
#check (Eq.refl 4 : Eq (2 + 2) 4)
```
:::

## Basic Proofs
:::fragment fadeUp
```lean -stretch -panel
theorem eq_transitive {α : Type} {a b c : α}
    (h₁ : a = b) (h₂ : b = c) : a = c
  := by rwa [h₂] at h₁

#check @eq_transitive
```
:::
:::fragment fadeUp
```lean -stretch
inductive And₂ (P Q : Prop) : Prop where
| intro : P → Q → And₂ P Q

inductive Or₂ (P Q : Prop) : Prop where
| inl : P → Or₂ P Q
| inr : Q → Or₂ P Q
```
:::
:::fragment fadeUp
```lean -stretch
example (b : Bool) : b = true ∨ b = false :=
  match b with
  | .true => Or.inl (Eq.refl true)
  | .false => Or.inr (Eq.refl false)
```
:::

## Negations
:::fragment fadeUp
```lean -stretch
inductive Flase₂ : Prop where

inductive True₂ : Prop where
| intro : True₂
```
:::
:::::fragment fadeUp
```lean -stretch
def Not₂ (P : Prop) : Prop := P → False
```
::::attr (style := "text-align: center; font-size: 14pt;")
:::table +colHeaders +border +headerSep +colSeps +rowSeps
*
  * $`P` (Drinking Alcohol?)
  * $`Q` (Over 21?)
  * $`P \implies Q` (Legal?)
*
  * No
  * No
  * Yes
*
  * Yes
  * No
  * No
*
  * Yes
  * Yes
  * Yes
*
  * No
  * Yes
  * Yes
:::
::::
:::::

## Negation (continued)
```lean -stretch
theorem contrapos {P Q : Prop} (h : P → Q) : ¬Q → ¬P :=
  fun hq => hq ∘ h
```
:::fragment fadeUp
```lean -stretch
theorem self_contradiction (P : Prop) : ¬(P ∧ ¬P) :=
  fun h =>
    match h with
    | .intro hp hnp => hnp hp
/- !hide -/
theorem self_contradiction₂ (P : Prop) : ¬(P ∧ ¬P) :=
/- !end hide -/
-- !fragment fadeUp
  fun ⟨hp, hnp⟩ => hnp hp
```
:::
:::fragment fadeUp
```lean -stretch
#check Classical.em
#print axioms Classical.em
```
:::

## Exists
```lean -stretch
inductive Exists₂ {α : Type} (P : α → Prop) : Prop where
| intro : (a : α) → P a → Exists₂ P

-- !fragment fadeUp
def EqualsTwo : Nat → Prop :=
  fun n => n = 2

-- !fragment fadeUp
example : Exists EqualsTwo :=
  Exists.intro 2 (Eq.refl 2)

example : ∃(n : Nat), n = 2 :=
  ⟨2, rfl⟩
--     ^ !click
```

## Proof Irrelevance
```lean +error -stretch
theorem proof1 : ∃(s : String), s.length = 3 :=
  ⟨"abc", rfl⟩

theorem proof2 : ∃(s : String), s.length = 3 :=
  ⟨"123", rfl⟩

-- !fragment fadeUp
theorem proof_irrelevant : proof1 = proof2
  := rfl

-- !fragment fadeUp
def fst (h : ∃(s : String), s.length = 3) : String :=
  match h with
  | .intro s _ => s
```
:::fragment fadeUp
```lean -stretch
theorem eq_of_eq_and_eq {α : Type} {a b c : α}
    (h : a = b ∧ b = c) : a = c :=
  match h with
  | .intro h₁ h₂ => eq_transitive h₁ h₂
```
:::

## The Axiom of Choice
```lean -stretch
noncomputable
def exampleString := proof1.choose

example : exampleString.length = 3 :=
  proof1.choose_spec

#print axioms exampleString
```
:::fragment fadeUp
```lean -stretch
example : proof1.choose = proof2.choose
  := rfl
```
:::
:::fragment fadeUp
```lean -stretch
#check Classical.choice
```
:::

# Lean Tutorial 2: The Natural Numbers

# Recursive Inductive Types
%%%
vertical := true
%%%

```lean -panel
inductive Lst (α : Type) : Type where
| empty : Lst α
| cons : α → Lst α → Lst α

-- !fragment fadeUp
/-- returns `front ++ back` -/
def append {α} (back front : Lst α) : Lst α :=
  match front with
  | .empty => back
  | .cons x xs => Lst.cons x (append back xs)

-- !fragment fadeUp
#eval append
  (Lst.cons 2 (Lst.cons 3 Lst.empty))
  (Lst.cons 1 Lst.empty)
```

## Strict Positivity
```lean -stretch
inductive BTree (α : Type) : Type where
| empty : BTree α
| node : α → BTree α → BTree α → BTree α

-- !fragment fadeUp
inductive BTree₂ (α : Type) : Type where
| empty : BTree₂ α
| node : α → (Bool → BTree₂ α) → BTree₂ α
```

:::fragment fadeUp
```lean +error -stretch
/--
error: (kernel) arg #1 of 'Invalid.mk' has a
non positive occurrence of the datatypes being declared
-/
#guard_msgs in
inductive Invalid where
| mk : (Invalid → String) → Invalid

def undefinedFunc (x : Invalid) : String :=
  match x with
  | .mk f => f x

#eval undefinedFunc (Invalid.mk undefinedFunc)
```
:::

## No Infinite Loops!

```lean -stretch -panel
/--
error: fail to show termination for
  f
with errors
failed to infer structural recursion:
Not considering parameter x of f:
  it is unchanged in the recursive calls
no parameters suitable for structural recursion

well-founded recursion cannot be used, `f` does not take any (non-fixed) arguments
-/
#guard_msgs in
def f (x : Nat) : String :=
  f x
```

# Some Useful Language Features
%%%
vertical := true
%%%

```lean -stretch
structure Iff₂ (P Q : Prop) : Prop where
  intro ::
-- ^ !click
    mp : P → Q
    mpr : Q → P

-- !fragment fadeUp
theorem trivial_iff : 2 + 2 = 5 ↔ 4 = 5 :=
  Iff.intro id id
--           ^ !click
-- !fragment fadeUp
/- !hide -/
theorem trivial_iff₂ : 2 + 2 = 5 ↔ 4 = 5 :=
/- !end hide -/
  ⟨id, id⟩

-- !fragment fadeUp
#check trivial_iff.mp
#check trivial_iff.mpr
```

## Structures (cont)
:::fragment fadeUp
```lean -stretch
inductive Iff₃ (P Q : Prop) : Prop where
| intro : (P → Q) → (Q → P) → Iff₃ P Q

-- !fragment fadeUp
theorem Iff₃.mp {P Q : Prop} (h : Iff₃ P Q) : P → Q :=
  match h with
  | .intro mp _ => mp

-- !fragment
namespace Iff₃
variable {P Q : Prop}

theorem mpr (h : Iff₃ P Q) : Q → P :=
--       ^ !click
  match h with
  | .intro _ mpr => mpr

end Iff₃
```
:::

## Typeclasses
```lean -stretch
class Add₂ (α : Type) : Type where
  add : α → α → α

#check Add.mk
```
```lean -stretch +error
#eval "3" + "4"

instance instAddString : Add String :=
  Add.mk (fun a b => a ++ b)

#eval "3" + "4"
```
## Typeclasses (cont)
```lean -stretch
def addThrice {α : Type} [Add α] (a : α) : α :=
  a + a + a

#check addThrice
#eval addThrice "1"
#eval addThrice 1
```
```lean -stretch
#eval @addThrice String instAddString "1"
#eval @addThrice _ _ "1"
```

## Multiple Instances
```lean -stretch
instance : Add String where
  add (a b : String) := a ++ " plus " ++ b

#eval "3" + "4"
#eval letI := instAddString
  "3" + "4"
```
```lean -show
set_option warn.classDefReducibility false
```
```lean -stretch
#check inferInstance
```
```lean -stretch
def instCurrent : Add String := inferInstance

#eval instCurrent.add "a" "b"
#eval instAddString.add "a" "b"
```

## Instance Chains
```lean -stretch

```

# The Natural Numbers
```lean
inductive Nat₂ : Type where
| zero : Nat₂
| succ : Nat₂ → Nat₂

-- !fragment
def addₙ (a b : Nat) : Nat :=
  match b with
  | .zero => a
  | .succ p => Nat.succ (addₙ a p)
```
