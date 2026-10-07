-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl
-- Some examples were generated using Mistral AI
-- Additional sources:
-- - 'Set Theory Game' https://adam.math.hhu.de/#/g/djvelleman/stg4
-- - https://www.youtube.com/watch?v=0QZI_m8WZ0Q

import Mathlib

-- TODO more basic examples and eval, def etc

-- implication is function application
-- every human is mortal and socrates is human. Prove socrates is mortal
theorem modus_ponens (p q : Prop) (hpq : p → q) (hp : p) : q := hpq hp

-- working backwards and filling in the needed hypothesis
theorem modus_ponens' (p q : Prop) (hpq : p → q) (hp : p) : q := by
  apply hpq
  exact hp

#print modus_ponens
#print modus_ponens'

-- intro and multistep goal
theorem imp_trans (p q r : Prop) (hpq : p → q) (hqr : q → r) : p → r := by
  intro hp
  apply hqr
  apply hpq
  exact hp

-- set membership behaves like function application
example (x : U) (A B : Set U) (h1 : A ⊆ B) (h2 : x ∈ A) : x ∈ B := by
  exact h1 h2

-- adding assumptions
example (x : U) (A B C : Set U) (h1 : A ⊆ B) (h2 : B ⊆ C) (h3 : x ∈ A) : x ∈ C := by
  have h4 : x ∈ B := h1 h3
  exact h2 h4

-- more general case
theorem Subset.trans {A B C : Set U} (h1 : A ⊆ B) (h2 : B ⊆ C) : A ⊆ C := by
  intro x
  intro h
  have h3 := h1 h
  exact h2 h3

-- using Mathlib to rewrite obvious statements
#check Set.mem_inter_iff

example (x : U) (A B : Set U) (h : x ∈ A ∩ B) : x ∈ B := by
  rw [Set.mem_inter_iff] at h
  exact h.2

-- set unions work like 'or', introducing rcases
theorem union_subset_swap (A B : Set U) : A ∪ B ⊆ B ∪ A := by
  intro x h
  rcases h with hA | hB
  · exact Or.inr hA
  · exact Or.inl hB

-- set intersection example for and
theorem inter_subset_swap (A B : Set U) : A ∩ B ⊆ B ∩ A := by
  intro x h
  exact And.intro h.2 h.1
  --exact ⟨h.2, h.1⟩

-- last set example, using library functions
#check Set.mem_compl_iff
#check Set.mem_union

example (A B : Set U) : (A ∪ B)ᶜ ⊆ Aᶜ ∩ Bᶜ := by
  intro x h
  rw [Set.mem_compl_iff, Set.mem_union] at h
  push Not at h
  --rw [← Set.mem_compl_iff A x, ← Set.mem_compl_iff B x] at h
  exact h

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
