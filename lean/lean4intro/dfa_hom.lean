-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl

import Mathlib.Computability.DFA

theorem accepts_eq_of_hom {α σ₁ σ₂ : Type*}
(M₁ : DFA α σ₁) (M₂ : DFA α σ₂) (f : σ₁ → σ₂)
(hstart : f M₁.start = M₂.start)
(hstep : ∀ s a, f (M₁.step s a) = M₂.step (f s) a)
(hacc : ∀ s, s ∈ M₁.accept ↔ f s ∈ M₂.accept) :
M₁.accepts = M₂.accepts := by
  -- lemma: running on a word commutes with f, from ANY starting state
  have comm : ∀ (x : List α) (s : σ₁),
    f (M₁.evalFrom s x) = M₂.evalFrom (f s) x := by
    intro x -- pull x out of the goal
    induction x with
    | nil => intro s; simp [DFA.evalFrom] -- induction on empty word
    | cons a x ih => intro s; simp only [DFA.evalFrom_cons, ih, hstep] -- induction step
  -- Now compare membership word by word
  ext x -- unfold definition of equal sets
  simp only [DFA.mem_accepts, DFA.eval, hacc, comm, hstart] -- let lean figure out the rest
