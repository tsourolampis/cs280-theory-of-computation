# HY-280 · Theory of Computation

### Θεωρία Υπολογισμού · University of Crete

**Department of Computer Science · Fall 2026**  
**Instructor:** [Charalampos E. Tsourakakis](https://tsourakakis.com/)

[**Course website**][course] · [**Syllabus**][syllabus] · [**Lecture materials**](#lecture-materials) · [**Lean resources**](#lean-and-formal-proof)

---

What can a computer compute? What lies beyond computation? And when a problem is solvable, what makes it computationally difficult?

HY-280 develops the mathematical foundations for answering these questions through formal languages, automata, computability, and complexity. Constructing precise definitions and rigorous proofs is central to the course. Selected activities introduce **Lean**, connecting mathematical reasoning with machine-checked proofs.

This repository accompanies the course and provides a home for supporting materials. Teaching materials are primarily in Greek, with supplementary readings in English.

> **Start with the [course website][course].** It is the authoritative source for announcements, assigned readings, deadlines, assessment policies, and staff office hours. This README is a navigation guide; if information differs, follow the course website and course announcements.

## Course at a glance

| | Details |
|---|---|
| **Lectures** | Monday & Wednesday, 13:00–15:00 |
| **Lecture room** | Stelios Orphanoudakis Auditorium (ΑΜΦ ΣΟ) |
| **Tutorial** | Friday, 13:00–15:00 · Room A113 |
| **Instructor office hours** | Monday & Wednesday, 15:00–16:00 · Office B303 |
| **Contact** | [tsourakakis@csd.uoc.gr](mailto:tsourakakis@csd.uoc.gr) |
| **Teaching assistants** | Staff, contact details, and weekly office hours on the [course website][course] |

All times are local to Crete. Consult the course website and eLearn announcements for changes and online office-hour access.

## Getting started

1. Read the [syllabus][syllabus] and the policies on the [course website][course].
2. Follow the lecture slides and accompanying readings; work through the exercises as the material is introduced.
3. Use Friday tutorials and office hours to discuss proof ideas, questions, and difficulties.
4. Prepare exercise submissions in **LaTeX**. [Overleaf](https://www.overleaf.com/) is an online option. The source code can be found [here](https://www.overleaf.com/project/6abab1480d5b1f2a3205f468/share#faf29b9f0b1f4389395482c5fc000d5d73d68473806be00a) as well.
5. Explore Lean when it appears in the course. No prior Lean experience is required.

## Lecture materials

The course website maintains the full lecture-by-lecture record, including required readings and optional enrichment. The links below cover the first three lectures posted as of **28 September 2026**.

| Lecture | Slides | Exercises |
|---|---|---|
| 1 · 21 September 2026 | [Slides · PPTX](https://www.csd.uoc.gr/~hy280/lectures_tsourakakis/lec1_cs280_uoc.pptx) | [Problem set 1 · PDF](http://csd.uoc.gr/~hy280/hws_tsourakakis/lec1_exercises.pdf) |
| 2 · 23 September 2026 | [Slides · PDF](https://csd.uoc.gr/~hy280/lectures_tsourakakis/lec2_diagonalization_cs280.pdf) | [Problem set 2 · PDF](https://csd.uoc.gr/~hy280/hws_tsourakakis/lec2_exercises.pdf) |
| 3 · 28 September 2026 | [Slides · PDF](https://www.csd.uoc.gr/~hy280/lectures_tsourakakis/lec3_basic_toolbox_part1_cs280.pdf) | [Problem set 3 · PDF](https://csd.uoc.gr/~hy280/hws_tsourakakis/lec3_exercises.pdf) |

**[Continue to the course website for subsequent lectures and readings →][course]**

## Assessment

| Component | Weight |
|---|---:|
| Final examination | 70% |
| Midterm examination | 20% |
| Exercises, with oral examination | 10% |
| Optional Lean programming work, with oral examination | +5% bonus |

Lean is optional and is not required to earn full marks. See the course website for the complete assessment rules and examination announcements.

### Collaboration and AI

Discussion and collaboration are encouraged, with explicit acknowledgment of assistance. Under the course policy, AI tools may support understanding of the material, but may **not solve assigned exercises**. Any use of AI must be disclosed, including how it was used. Students must understand and be able to explain their submissions; oral examination may apply to all students or a sample, as specified on the course website.

## Reading and study tools

| Resource | Role |
|---|---|
| [Michael Sipser · *Introduction to the Theory of Computation*](https://cup.gr/book/eisagogi-sti-theoria-ypologis-oy-metafrasi-tis-3is-diethnoys-ekdosis/) | Recommended textbook; Greek edition |
| [Lewis & Papadimitriou · *Elements of the Theory of Computation*](https://kritiki.gr/product/stichia-theorias-ipologismou/) | Alternative textbook; Greek edition |
| [Richard Hammack · *Book of Proof*](https://richardhammack.github.io/BookOfProof/Main.pdf) | Proof techniques and mathematical foundations |
| [Jeff Erickson · *Models of Computation*](https://jeffe.cs.illinois.edu/teaching/algorithms/models/all-models.pdf) | Supplementary lecture notes |
| [MIT OCW · 18.404J Theory of Computation](https://ocw.mit.edu/courses/18-404j-theory-of-computation-fall-2020/) | Supplementary lectures by Michael Sipser |
| [JFLAP](https://www.jflap.org/) | Experimenting with automata, grammars, and Turing machines |

Supplementary resources complement the assigned material. A simulation can help test an idea; a proof establishes why it is correct.

## Lean and formal proof

Lean is used selectively to practice precise statements and rigorous reasoning, and to explore how proofs can be checked mechanically.

- [Install Lean](https://lean-lang.org/install/)
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/)
- [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/)
- [Lean Game Server](https://adam.math.hhu.de/)
- [Mathlib documentation](https://leanprover-community.github.io/mathlib4_docs/)

## Corrections and questions

Found a typo, broken link, or unclear statement? Open a GitHub issue identifying the relevant file or lecture, page number, and suggested correction. For personal matters, grading questions, or questions that would disclose assignment solutions, contact the teaching staff through the course channels.

---

**HY-280 · Department of Computer Science · University of Crete**  
[Course website][course] · [Syllabus][syllabus]

[course]: https://tsourakakis.com/%ce%b7%cf%85-280-%ce%b8%ce%b5%cf%89%cf%81%ce%af%ce%b1-%cf%85%cf%80%ce%bf%ce%bb%ce%bf%ce%b3%ce%b9%cf%83%ce%bc%ce%bf%cf%8d/
[syllabus]: https://docs.google.com/document/d/1-cVAmZIpVmN9p3QaYKkVWy7FZ6f6HbIsvhk0uXMrPEc/edit?usp=sharing
