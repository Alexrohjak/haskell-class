# INF122 — A 12-Week Haskell Tutorial

A self-study companion for **INF122 Funksjonell programmering** (UiB, 10 ECTS,
autumn). Built to run *alongside* your 4h lectures + 2h exercises, not to replace
them. Budget **2–3 hours per week**.

Aligned to **Graham Hutton, _Programming in Haskell_ (2nd ed.)**, chapters 1–10
and 15.

---

## How to use this

Every week is a folder with the same four things:

| File | What it is |
|---|---|
| `LESSON.md` | Read this first. Concepts, worked examples, paper drills. |
| `Exercises.hs` | Stubs to fill in. Every `undefined` is a task. |
| `Tests.hs` | The checks. You don't edit this. |
| `../solutions/weekNN/` | Reference answers. Open **after** you've tried. |

The loop:

```bash
cd tutorial

./check.sh 3              # run week 3's tests against your code
./check.sh 3 --repl       # GHCi with your week-3 code loaded
./check.sh 3 --solution   # run the tests against the reference answers
```

Unimplemented stubs report as `todo`, not `FAIL`, so you can work one exercise at a
time and watch the count climb. Exit status is 0 only when everything passes.

**No dependencies.** The harness is a single file (`lib/Check.hs`) using nothing but
`base`. No cabal, no stack, no installing packages — `runghc` and go.

### The two feedback loops

1. **Tests** — instant, mechanical, correctness only.
2. **Me** — when a week's tests are green, paste your `Exercises.hs` and ask for an
   **idiom review**. The tests can't tell you that your five-line recursion should
   have been a one-line `foldr`, and that distinction is most of what separates a C
   from an A in this course.

---

## The plan

| Week | Hutton | Topic | Why it matters |
|:--:|:--:|---|---|
| 1 | 1–2 | Mindset, GHCi, first steps | The `=` sign isn't assignment |
| 2 | 3 | Types and classes | `Ord a =>` explained; the type system is the course |
| 3 | 4 | Defining functions | Guards, pattern matching, lambdas, sections |
| 4 | 5 | List comprehensions | Generators, guards, the Caesar cipher |
| 5 | 6 | Recursive functions | **Learning outcome #1** |
| 6 | 7 | Higher-order functions | **Learning outcome #2** — `map`/`filter`/`foldr` |
| 7 | 8 | Declaring types and classes | **Learning outcome #3** — your own data types |
| 8 | 9 | The countdown problem | A real program, built from everything so far |
| 9 | 10 | Interactive programming | `IO`, and how purity survives side effects |
| 10 | 15 | Lazy evaluation | Infinite lists, `seq`, why `take 5 [1..]` works |
| 11 | *TBD* | **FLEX** | Reserved for the chapters not yet pinned down |
| 12 | — | Exam prep | Timed, handwritten, no aids |

---

## Build status

Not all twelve weeks are written yet. Current state:

| Week | LESSON.md | Exercises + Tests | Solutions |
|:--:|:--:|:--:|:--:|
| 1 | done | done (19 checks) | done + PAPER.md |
| 2 | done | done (31 checks) | done + PAPER.md |
| 3 | **missing** | done (42 checks) | done |
| 4–12 | — | — | — |

Weeks 1 and 2 are complete and ready to work through. Week 3's exercises and tests
are in place and verified green against the reference solutions, but its `LESSON.md`
and `PAPER.md` are still to be written — so the exercises currently arrive without
their teaching material. Weeks 4–12 are planned (see the table above) but not built.

---

**Week 11 is deliberately open.** The syllabus lists chapters 1–10 and 15; if the
missing ones turn out to be 12 (monads), 13 (parsing), 14 (foldables) or 16
(reasoning), that week gets built to match. If nothing more turns up, it becomes a
second revision week. Tell me when you find the full pensum.

---

## What the course actually assesses

From the emneplan:

- **Exam: 3 hours, written, _no aids permitted_.** You will write Haskell by hand
  on paper. Every `LESSON.md` therefore has a **paper exercises** section — do those
  without a computer. Typing fluency is not the skill being tested.
- **Obligatoriske oppgåver must be approved** before you can sit the exam.
- Grading A–F; both the compulsory work and the exam must pass independently.

The stated learning outcomes name three concepts explicitly — **rekursjon, høgre
ordens funksjonar, ikkje-muterbare datastrukturar** — plus being able to *discuss*
the difference between imperative and functional paradigms. That last one is an
essay question in waiting, so several weeks include a short written-explanation
drill alongside the code.

---

## Where things live

```
tutorial/
  README.md           this file
  check.sh            the test runner
  lib/Check.hs        the harness (don't edit)
  week01/ ... week12/ LESSON.md, Exercises.hs, Tests.hs
  solutions/
    week01/ ...       Exercises.hs and PAPER.md per week
```

The repo's other folders are yours: `lectures/` for code written in class,
`assignments/` for graded work, `scratch/` for experiments.

---

## If you get stuck

In order:

1. `:t` the thing you don't understand. Most confusion is a type confusion.
2. Read the error message from the **bottom up** — GHC puts the useful part last.
3. Re-read the relevant Hutton section; each lesson names it.
4. Ask me. Paste the code *and* the full error.

The one habit worth building above all others: **when in doubt, ask GHCi for the
type.** Everything in this language falls out of the types.
