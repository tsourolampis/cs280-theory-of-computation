-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl
-- Additional source: https://nelsmartin.github.io/ComputationBook/

import Mathlib.Data.Set.Basic

-- defining a basic DFA and states
structure DFA (Q : Type u) (σ : Type v) where
  δ : Q → σ → Q  -- Delta (transition) function
  q₀ : Q         -- Start state
  F : Set Q      -- Accept states

inductive state where
| q₀ : state
| q₁ : state

namespace state

def M : DFA (state) (Fin 1) :=
⟨
  fun x s => match x with
  | q₀ => match s with | 0 => q₁
  | q₁ => match s with | 0 => q₀,
  q₀,
  {q₀}
⟩

end state

-- first version of acceptance
@[simp]
def accepts {Q : Type u} {σ : Type v} (M : DFA Q σ) (w : List σ) :=
  ∃ r : Fin (w.length + 1) → Q,
  (r 0 = M.q₀) ∧
  (∀ i : Fin (w.length), M.δ (r (i.castSucc)) w[i] = r (i.castSucc + 1)) ∧
  (r ⟨ w.length, by simp ⟩ ∈ M.F)

def L {Q : Type u} {σ : Type v} (M : DFA Q σ) : Set (List σ) := {w | accepts M w}

-- Alternative accepts
@[simp]
def evalFrom (M : DFA Q σ) (s : Q) : List σ → Q :=
  List.foldl M.δ s

@[simp]
def eval (M : DFA Q σ) : List σ → Q :=
  evalFrom M M.q₀

@[simp]
def acceptsFrom (M : DFA Q σ) (s : Q) : Set (List σ) := {x | evalFrom M s x ∈ M.F}

@[simp]
def L' (M : DFA Q σ) : Set (List σ) := acceptsFrom M M.q₀

-- testing
#eval eval state.M [0, 0]
#eval eval state.M [0, 0, 0]
