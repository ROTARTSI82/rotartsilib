import VersoSlides
import Verso.Doc.Concrete

open VersoSlides

set_option verso.code.warnLineLength 500

#doc (Slides) "A Guide to Inductive Types" =>

# Basic Syntax & Functions

```lean
-- !fragment fadeUp 1
-- this is a comment

/- this is a
 multi-line comment -/

/-- this is documentation. `code`, _formatting_. -/
def hello : String := "world"
--   ^ !click 2

-- !fragment fadeUp 3
def luckyNumber (s : String) (n : Nat) : String :=
  s ++ " has a lucky number of " ++ (toString n)

-- !fragment fadeUp 4
#check luckyNumber
#eval luckyNumber "Aeneas" 5
#eval luckyNumber "Bob" 2
```

# Currying
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

# Implicit Parameters
:::: attr (style := "margin-top: 0; padding-top: 1rem;")

```lean -stretch
def myList₂ : List Nat := [1, 2, 3]

def reverseList₂ {α : Type} (input : List α) : List α :=
  match input with
  | [] => []
  | x::xs => (reverseList₂ xs) ++ [x]

#eval reverseList₂ myList₂
#eval reverseList₂ ["a", "b", "c"]
```
:::fragment fadeUp
```lean -stretch
#check @reverseList₂ Nat
#eval @reverseList₂ Nat myList₂
```
:::
::::

# Simple Inductive Types
:::fragment fadeUp
```lean -stretch -panel
inductive Color where
| red
| green
| blue
```
:::
:::fragment fadeUp
```lean -stretch -panel
#check Color
#check Color.red
#check Color.green
#check Color.blue
```
:::

# Simple Inductive Types (2)
```lean
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

# Recursors
```lean
def toHexCode' (c : Color) : String :=
  match c with
  | .red => "ff0000"
  | .green => "00ff00"
  | .blue => "0000ff"

-- !fragment fadeUp
noncomputable
def toHexCode₂ (c : Color) : String :=
  Color.rec "ff0000" "00ff00" "0000ff" c
--       ^ !click
-- !fragment fadeUp
/- !hide -/
noncomputable def toHexCode₃ (c : Color) : String :=
/- !end hide -/
  @Color.rec (fun _ => String)
    "ff0000" "00ff00" "0000ff" c
```

# Dependent Typing
```lean
-- !fragment fadeUp
def myMotive (c : Color) : Type :=
  match c with
  | .red => Bool
  | .green => List Int
  | .blue => String

-- !fragment fadeUp
def dependentlyTyped (c : Color) : myMotive c :=
  match c with
  | .red => true
  | .green => [0, 255, 0]
  | .blue => "blue"

-- !fragment fadeUp
noncomputable
def dependentlyTyped₂ (c : Color) : myMotive c :=
  @Color.rec myMotive true [0, 255, 0] "blue" c
-- !fragment fadeUp
/- !hide -/
noncomputable def dependentlyTyped₃ (c : Color) : myMotive c :=
/- !end hide -/
  @Color.rec _ true [0, 255, 0] "blue" c
-- !fragment fadeUp
/- !hide -/
noncomputable def dependentlyTyped₄ (c : Color) : myMotive c :=
/- !end hide -/
  Color.rec true [0, 255, 0] "blue" c
```

# Dependent Typing (cont)
```lean -stretch
#eval dependentlyTyped Color.red
#eval dependentlyTyped Color.green
#eval dependentlyTyped Color.blue
```

# Propositions
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
#check Eq.refl "hi"
```
:::

# Implicit Parameters & Universes
```lean
#check Eq.refl
```
