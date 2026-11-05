# lean4intro

 These files contain examples in Lean 4 for CS-280 at
 the University of Crete, taught by Charalampos E. Tsourakakis
 Author: Noah A. Wahl
 Some examples were generated using Mistral AI
 Additional sources:
 - [Set Theory Game](https://adam.math.hhu.de/#/g/djvelleman/stg4)
 - [Tutorial with many examples](https://www.youtube.com/watch?v=0QZI_m8WZ0Q)

 This repository contains empty files (suffix 'empty') for you to try the exercises yourself, as well as the solutions (no 'empty' suffix).

## Installing Lean

To install Lean, follow the instructions on [the project website](https://lean-lang.org/) and install VS Code as well as the Lean 4 extension for VS Code.
Follow the setup guide given by the extension.

Alternatively, use the [playground](https://live.lean-lang.org/?from=lean) to use Lean without a local installation on your device.

## Finding Help

Use the hover actions and the Lean InfoView in VS Code to view documentation in your editor.
To learn more about Lean, read through the [core documentation](https://lean-lang.org/learn/#core-documentation).

For all other questions, post them in the courses e-lean forum or come to my office hours (Tue 12:00-13:00, link in the forum).

# DFAs in Lean

The files `dfa.lean` and `dfa_hom.lean` contain examples for how to encode DFAs in Lean.
It is important to note that the definitions in `dfa.lean` are available in Lean's Mathlib library.
The proof in `dfa_hom.lean` checks whether two DFAs on the same alphabet but different states accept the same language.
This is an important puzzle piece for the [Project](https://github.com/tsourolampis/cs280-theory-of-computation/tree/main/project).
