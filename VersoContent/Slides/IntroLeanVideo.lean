import VersoSlides
import Verso.Doc.Concrete

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "A Guide to Inductive Types" =>

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
#eval luckyNumber "Bob" 2
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

# Inductive Types
%%%
vertical := true
%%%

```lean
inductive Color where
| red
| green
| blue

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

## Curry-Howard Correspondence

:::fragment fadeUp
```lean -stretch
axiom h : 2 + 2 = 5
```
:::

:::fragment fadeUp
$$`P \implies Q`
```lean -show
set_option warn.sorry false
```
```lean -stretch
axiom JohnDrinksAlcohol : Prop
axiom JohnOver21 : Prop

theorem underage_drinking
    (_h : JohnDrinksAlcohol) : JohnOver21 :=
  sorry

-- !fragment fadeUp
#print axioms underage_drinking
-- ^ !click
-- !fragment fadeUp
#check sorryAx
```
:::

## Basic Logical Connectives
```lean -stretch
-- P ∨ Q
inductive Or₂ (P Q : Prop) : Prop where
| inl : P → Or₂ P Q
| inr : Q → Or₂ P Q

-- P ∧ Q
inductive And₂ (P Q : Prop) : Prop where
| intro : P → Q → And₂ P Q
```

:::fragment fadeUp
```lean -stretch
axiom hjohn : JohnDrinksAlcohol

-- !fragment fadeUp
example : JohnDrinksAlcohol ∧ JohnOver21 :=
  And.intro hjohn (underage_drinking hjohn)

-- !fragment fadeUp
example : JohnDrinksAlcohol ∨ JohnOver21 :=
  Or.inl hjohn

example : JohnDrinksAlcohol ∨ JohnOver21 :=
  Or.inr (underage_drinking hjohn)
```
:::



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
error: (kernel) arg #1 of 'Invalid.mk'
has a non positive occurrence of the
datatypes being declared
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
