# CS280 Bonus Project: DFA Compression and Formal Verification
## Professor C.E. Tsourakakis
## Responsible TA: Noah Wahl

This repository contains the optional **CS280 bonus project** on DFA compression for deep packet inspection, inspired by the work of Kumar et al. on delayed-input deterministic finite automata (D²FA).

The project combines:

- deterministic finite automata,
- regular-expression matching,
- DFA compression,
- Python implementation and testing,
- experimental evaluation,
- and formal verification in Lean.

The project is intended for students who enjoy research-oriented challenges and want to go beyond the core course material.

> **Bonus:** up to **+5%** on the final course grade.
> Students who are still working to master the core material are strongly encouraged to focus first on the regular homework and exams, which account for 100% of the base course grade.

---


## Key paper

Sailesh Kumar, Sarang Dharmapurikar, Fang Yu, Patrick Crowley, and Jonathan Turner.
**Algorithms to Accelerate Multiple Regular Expressions Matching for Deep Packet Inspection.**
ACM SIGCOMM 2006.

Author-hosted PDF:
https://www.arl.wustl.edu/~jon.turner/pubs/2006/sigcomm2006.pdf

For the project, read especially:

- §3.1 — Motivating Example
- §3.2 — Problem Statement
- §3.3 — Converting DFAs to D²FAs
- §4 — Bounding Default Paths
- §4.1 — Results

The implementation target is the *refined* Kruskal-style construction described in §4, not a generic library maximum-spanning-tree call.

## 1. Background

Modern network-security systems often inspect not only packet headers, but also the packet payload.

At the networking level:

- **IP** transports packets between machines.
- **TCP** provides applications with an ordered, reliable stream of bytes.
- A byte can take one of 256 possible values, so we model the alphabet as

$\Sigma = \{0,1,\ldots,255\}.$

A complete DFA transition table therefore contains $256|Q|$ entries for a DFA with $|Q|$ states.

If each destination state is stored using 4 bytes, the transition table alone requires approximately $
256|Q|\cdot 4$ bytes.

For large automata produced from many regular expressions, this can become a significant memory bottleneck.

Kumar et al. exploit the fact that many DFA states have very similar transition rows. Instead of storing every transition explicitly, one state can reuse transitions from another state through a **default link**, while storing only the transitions that differ. The resulting representation is a **D²FA**.

---

## 2. Project goal

The project has two main goals:

1. **Implement the DFA compression algorithm described by Kumar et al.**
2. **Formally verify in Lean that the compressed automaton is equivalent to the original DFA.**

The complete workflow is:

```text
generate DFA instances
        ↓
load DFA from JSON
        ↓
implement Kumar compression in Python
        ↓
produce compressed D²FA
        ↓
test implementation with pytest
        ↓
encode/export original and compressed automata in Lean
        ↓
prove equivalence
        ↓
run experiments and report the compression/runtime tradeoff
```

---

## 3. DFA generator

The file

```text
generate_instances.py
```

generates deterministic DFA benchmark instances.

The generated automata:

- are complete,
- use byte symbols `0..255`,
- use state `0` as the start state,
- are reproducible from fixed random seeds,
- and are written to JSON files.

The generator includes multiple families of automata, including instances with deliberately planted transition-row similarity so that DFA compression has meaningful structure to exploit.

### Running the generator

From the project directory:

```bash
python3 generate_instances.py
```

The generated JSON files are the input instances for the project.

Students should **not modify the supplied seeds** when producing the results used in the final report.

After generating the instances, run the supplied verification script:

```bash
python3 verify_instances.py
```

This script checks the integrity of the generated benchmark files, including their format, transition-table dimensions, valid state identifiers, completeness of the DFA, and reachability requirements.

A successful run of `verify_instances.py` confirms that the benchmark instances were generated correctly. It does **not** test your compression algorithm or prove that your compressed automata are equivalent to the originals. Those checks are part of your own `pytest` suite and Lean verification.

## 4. Paper

The repository contains the paper by Kumar et al.:

```text
deep_packet_inspection_kumar_etal.pdf
```

You are expected to read the paper and understand the compression algorithm before implementing it.

The key idea is simple. Suppose two DFA states have transition rows

```text
        a    b    c    d
q1      q4   q5   q2   q7
q2      q4   q5   q6   q7
```

The rows agree on `a`, `b`, and `d`.

Instead of storing all four transitions for `q2`, we may store only

```text
q2 --c--> q6
```

together with a default link

```text
q2 ----> q1
```

If the current state is `q2` and the next input symbol is `a`, the compressed lookup follows the default link to `q1` and then uses the explicit transition on `a`.

**Important:** following a default link does **not** consume the current input symbol.

Default links therefore do not turn the automaton into an NFA. For every state and every input symbol, lookup still determines exactly one next state.

---

## 5. Task A — Baseline DFA implementation

Write Python code that:

- loads a DFA from the provided JSON format,
- stores the transition table,
- stores the start state,
- stores the accepting states,
- executes the DFA on a sequence of bytes,
- reports whether the input is accepted.

Your baseline implementation should correspond directly to the standard DFA transition function
$\delta : Q \times \Sigma \rightarrow Q.$ This implementation is the reference implementation for testing the compressed automaton.

---

## 6. Task B — Implement Kumar's compression algorithm

Read the relevant sections of the Kumar et al. paper and implement the DFA compression algorithm in Python.
Your implementation should construct a compressed representation consisting of:

- explicit transitions,
- default links,
- the original start state,
- the original accepting states.

The compressed automaton must support a deterministic lookup operation $\operatorname{lookup}(q,a).$
If an explicit transition on `a` exists at state `q`, use it. 
Otherwise, follow the default link and continue searching **without consuming `a`**.

---

## 7. Task C — Python testing with pytest

Create a `pytest` test suite.

At minimum, your tests should cover:

- correct loading of JSON instances,
- correct execution of the original DFA,
- correct compressed lookup,
- correct handling of default links,
- termination of lookup,
- agreement between the original and compressed automata on individual transitions,
- agreement on many test strings,
- malformed compressed representations.

A particularly important test is

$\forall q \in Q,\ \forall a \in \Sigma,
\qquad
\operatorname{lookup}_C(q,a)=\delta_M(q,a).
$

Because the alphabet contains 256 bytes, this requires only
$256|Q|$ local checks per automaton. You should also test the two implementations on many generated input strings.

However:

> **Testing is not a proof.**

Even millions of successful test cases do not establish equivalence for every possible input string.

---

## 8. Task D — Formal verification in Lean

For every original DFA $M$ and compressed automaton $C$, formally prove that they are equivalent.
The intended proof has two levels.

### Step 1: one-symbol equivalence

Prove that for every state and every input symbol,

$
\forall q\in Q,\ \forall a\in\Sigma,
\qquad
\operatorname{lookup}_C(q,a)=\delta_M(q,a).
$

This is a finite property.

### Step 2: equivalence on arbitrary strings

Use induction on the input word to prove

$
\forall q\in Q,\ \forall w\in\Sigma^*,
\qquad
\operatorname{run}_C(q,w)=M.\operatorname{evalFrom}(q,w).
$

From the common start state and accepting states, conclude that both automata accept exactly the same language.

The key idea is $\boxed{
\underbrace{\forall q,a}_{\text{finite local verification}}
+
\underbrace{\text{induction on }w}_{\text{generic proof}}
\Longrightarrow
\underbrace{\forall q,w}_{\text{all possible inputs}}
}$

A Lean starter file may be provided in `lean/`.

---

## 9. Task E — Experimental evaluation

Evaluate your implementation on the supplied DFA instances. For every instance, report at least:

- number of states $|Q|$,
- original number of transition entries $256|Q|$,
- number of explicit transitions after compression,
- number of default links,
- compression ratio,
- average number of default hops per processed byte,
- compression time,
- matching time of the original DFA,
- matching time of the compressed DFA.

A useful compression metric is
$\text{compression ratio} = \frac{
\#\text{explicit transitions}+\#\text{default links}
}{
256|Q|
}.$

The central tradeoff to investigate is $
\boxed{
\text{less memory}
\quad\text{vs.}\quad
\text{more lookup work}
}$

Your report should include plots illustrating this tradeoff.

Possible plots include:

- compression ratio vs. maximum default depth,
- average default hops vs. maximum default depth,
- original vs. compressed transition count,
- matching time vs. compression ratio.

You may come with your own ideas beyond these suggestions. However the trade-off is necessary to show. 

---

## 10. Deliverables

Your submission should contain the following.

### Code

Python source code for:

- DFA loading,
- baseline execution,
- Kumar et al. compression,
- compressed execution,
- experiments.

### Tests

A complete `pytest` test suite.

### Lean proofs

Lean files containing:

- the original DFA representation,
- the compressed representation,
- the one-step correctness result,
- the full equivalence theorem.

### README

A short README explaining:

- dependencies,
- how to regenerate the DFA instances,
- how to run the compressor,
- how to run the test suite,
- how to reproduce experiments,
- how to compile the Lean proofs.

### Experimental results

Include:

- raw results,
- CSV files if used,
- generated plots.

### Report

Submit a short report, approximately **8 pages** using the Neurips template that you can find [here](https://www.overleaf.com/latex/templates/formatting-instructions-for-neurips-2026/bjdwqfdkyftc), describing:

1. the compression algorithm,
2. your implementation,
3. your correctness strategy,
4. your experiments,
5. the main plots,
6. the tradeoffs you observed,
7. any implementation difficulties or interesting findings.

---

## 11. Oral discussion

Students should be prepared to explain their implementation and proof.

Example questions include:

- Why does a default link not make the automaton nondeterministic?
- Why does following a default link not consume the current symbol?
- Why are random tests insufficient to establish language equivalence?
- What does the one-symbol Lean theorem guarantee?
- Why does induction on the input string establish equivalence for arbitrary inputs?
- What is the memory/runtime tradeoff introduced by D²FA compression?
- What happens if default paths become very long?

---

## 12. Reproducibility

All reported experiments must be reproducible.

Please:

- use the supplied generator,
- use the supplied seeds,
- record Python and Lean versions,
- include exact commands in your README,
- do not manually modify generated DFA instances.

---

## 13. Academic integrity and AI tools

You are expected to understand and be able to explain all submitted code and proofs.

If you use AI-assisted coding tools, you remain responsible for:

- correctness,
- testing,
- understanding the algorithm,
- understanding the Lean proof,
- and explaining your work during the oral discussion.

Code or proofs that you cannot explain should not be submitted.
