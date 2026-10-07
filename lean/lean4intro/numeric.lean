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
  use 3

#check Real.rpow_mul

example : ∃ y : ℝ, 2 ^ (2 * y) = ((2 : ℝ) ^ 2) ^ y := by
  use 0
  have nonneg_2 : (0 : ℝ) ≤ 2 := by simp
  rw [Real.rpow_mul nonneg_2 2 0]      -- goal: (2 ^ 2) ^ 0 = (2 ^ 2) ^ 0
  simp

#check Classical.em

#check irrational_sqrt_two

theorem irrat_pow_irrat_rat
  : ∃ (x y : ℝ), Irrational x ∧ Irrational y
    ∧ ¬ Irrational (x ^ y) := by
      have em := Classical.em (Irrational (√2^√2))
      rcases em with hl | hr
      · use √2^√2, √2
        have irrat : Irrational √2 := by
          exact irrational_sqrt_two
        have eq : ((√2^√2)^√2) = 2 := by
          calc
            (√2^√2)^√2 = √2^(√2*√2) := by
              have nonneg_sq : 0 ≤ √2 := by simp
              have h := Real.rpow_mul nonneg_sq √2 √2
              rw [h]
            _ = √2^2 := by simp
            _ = 2 := by simp
        have rat : ¬ Irrational ((√2^√2)^√2) := by
          rw [eq]
          simp
        exact ⟨hl, irrat, rat⟩
      · use √2, √2
        have irrat: Irrational √2 := by
          exact irrational_sqrt_two
        exact ⟨irrat, irrat, hr⟩
