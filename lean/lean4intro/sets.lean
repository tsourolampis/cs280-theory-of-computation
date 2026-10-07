-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl
-- Some examples were generated using Mistral AI
-- Additional sources:
-- - 'Set Theory Game' https://adam.math.hhu.de/#/g/djvelleman/stg4
-- - https://www.youtube.com/watch?v=0QZI_m8WZ0Q

import Mathlib

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
