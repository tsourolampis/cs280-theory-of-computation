-- This file contains examples in Lean 4 for CS-280 at
-- the University of Crete, taught by Charalampos E. Tsourakakis
-- Author: Noah A. Wahl
-- Some examples were generated using Mistral AI
-- Additional sources:
-- - 'Set Theory Game' https://adam.math.hhu.de/#/g/djvelleman/stg4
-- - https://www.youtube.com/watch?v=0QZI_m8WZ0Q

#eval 1 + 2
#eval String.append "Hello, " "Lean!"

-- implication is function application
-- every human is mortal and sokrates is human. Prove sokrates is mortal
theorem modus_ponens (p q : Prop) (hpq : p → q) (hp : p) : q :=
  sorry

-- working backwards and filling in the needed hypothesis
theorem modus_ponens' (p q : Prop) (hpq : p → q) (hp : p) : q := by
  sorry

#print modus_ponens
#print modus_ponens'

-- intro and multistep goal
theorem imp_trans (p q r : Prop) (hpq : p → q) (hqr : q → r) : p → r := by
  sorry
