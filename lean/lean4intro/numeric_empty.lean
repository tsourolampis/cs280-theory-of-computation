-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl
-- Some examples were generated using Mistral AI
-- Additional sources:
-- - 'Set Theory Game' https://adam.math.hhu.de/#/g/djvelleman/stg4
-- - https://www.youtube.com/watch?v=0QZI_m8WZ0Q

import Mathlib

-- exist proof template, 'use', maybe skip
def EvenSet : Set Nat := {n | ∃ k, n = 2 * k}

theorem six_even : 6 ∈ EvenSet := by
  sorry

#check Real.rpow_mul

example : ∃ y : ℝ, 2 ^ (2 * y) = ((2 : ℝ) ^ 2) ^ y := by
  sorry

#check Classical.em

#check irrational_sqrt_two

theorem irrat_pow_irrat_rat
  : ∃ (x y : ℝ), Irrational x ∧ Irrational y
    ∧ ¬ Irrational (x ^ y) := by
      sorry
