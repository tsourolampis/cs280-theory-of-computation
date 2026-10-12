-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl
-- Some examples were generated using Mistral AI
-- Additional sources:
-- - 'Set Theory Game' https://adam.math.hhu.de/#/g/djvelleman/stg4
-- - https://www.youtube.com/watch?v=0QZI_m8WZ0Q

import Mathlib
set_option linter.style.setOption false
set_option pp.proofs true

-- set membership behaves like function application
-- Let A, B be Sets over a Universe U, if A is a subset of B and x ∈ A, prove that x ∈ B
example (x : U) (A B : Set U) (h1 : A ⊆ B) (h2 : x ∈ A) : x ∈ B := by
  sorry

-- adding assumptions
example (x : U) (A B C : Set U) (h1 : A ⊆ B) (h2 : B ⊆ C) (h3 : x ∈ A) : x ∈ C := by
  sorry

-- more general case
theorem Subset_trans {A B C : Set U} (h1 : A ⊆ B) (h2 : B ⊆ C) : A ⊆ C := by
  sorry

-- using Mathlib to rewrite obvious statements
#check Set.mem_inter_iff

example (x : U) (A B : Set U) (h : x ∈ A ∩ B) : x ∈ B := by
  sorry

-- set unions work like 'or', introducing rcases
example (A B : Set U) : A ∪ B ⊆ B ∪ A := by
  sorry

-- set intersection example for and
example (A B : Set U) : A ∩ B ⊆ B ∩ A := by
  sorry

-- last set example, using library functions
#check Set.mem_compl_iff
#check Set.mem_union

example (A B : Set U) : (A ∪ B)ᶜ ⊆ Aᶜ ∩ Bᶜ := by
  sorry
