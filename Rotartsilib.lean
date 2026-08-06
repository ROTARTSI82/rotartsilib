import Mathlib.Data.Real.Basic
import Mathlib.Topology.Basic

def hello := "world"

-- A dummy mathlib proof to show mathlib is working
theorem dummy_proof (a b : ℝ) : a + b = b + a := by
  exact add_comm a b
