module


import Rotartsilib.Utils

public section

namespace Rotartsilib.Inductive
open Rotartsilib


def distinguish (x : Nat) : Prop :=
  match x with
  | 0 => True
  | _+1 => False

theorem zero_neq_succ {n : Nat} : 0 ≠ (Nat.succ n) := by
  let t : distinguish 0 := True.intro
  intro h
  rw [h] at t
  exact t

/- theorem succ_inj {n m : Nat} (h : Nat.succ m = Nat.succ n) : m = n := by
  induction n with
  | zero => -/


inductive BinTree where
  | leaf : BinTree
  | node (left : BinTree) (right : BinTree) : BinTree

inductive BinTree₂ where
  | leaf : BinTree₂
  | node (children : Bool → BinTree₂) : BinTree₂

/- 
#print BinTree₂.rec
#print BinTree.rec
-/

mutual
  inductive Even : Type
    | zero : Even
    | succ_odd : Odd → Even

  inductive Odd : Type
    | succ_even : Even → Odd
end

mutual
  inductive ONat where
  | mk : OptionONat → ONat

  inductive OptionONat where
  | none : OptionONat
  | some : ONat → OptionONat
end

/-
#print ONat.rec
#print OptionONat.rec

#check Eq

#check Eq
#check Option.none

#check ONat.rec
#check List.cons

-/

inductive Tree where
  | leaf : Tree
  | node : List Tree → Tree

inductive ONat2 where
  | mk : Option ONat2 → ONat2


/-
#check ONat2.rec

#check Tree.rec

#check BinTree.rec
#check BinTree₂.rec

-/




end Rotartsilib.Inductive

end
