import Mathlib.Computability.DFA

namespace CS280

variable {Symbol State : Type}

structure D2FA (Symbol State : Type) where
  explicit : State → Symbol → Option State
  default  : State → Option State

-- TODO:
-- 1. Define lookup for the compressed automaton.
-- 2. Define execution on a list of symbols.
-- 3. Prove that if one-step transitions agree with the original DFA,
--    then both automata behave identically on every input word.

end CS280
