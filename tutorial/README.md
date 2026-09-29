# INF122 — A 12-Week Haskell Tutorial

A self-study companion for **INF122 Funksjonell programmering** (UiB, 10 ECTS,
autumn). Built to run *alongside* your 4h lectures + 2h exercises, not to replace
them. Budget **2–3 hours per week**.

Aligned to the confirmed pensum: **Graham Hutton, _Programming in Haskell_
(2nd ed.), kap. 1–8, 10 and 15**, plus the two topics that exist only in the
lecturer's notes — **enkel parsing** and **typeinferens**. Chapter 9 (countdown)
and 11–14 are *not* pensum.

---

## How to use this

Every week is a folder holding **two sets of exercises side by side**: the book's,
and the lecturer's weekly sheet. Both count, and both get done.

| File | What it is |
|---|---|
| `LESSON.md` | Read this first. Concepts, worked examples, paper drills. |
| `Exercises.hs` | The **book** exercises — stubs to fill in. Every `undefined` is a task. |
| `Tests.hs` | The checks for `Exercises.hs`. You don't edit this. |
| `Oppgaver.hs` | The **lecturer's weekly sheet** (`oppgaver ukeN`), task text copied verbatim, as stubs. |
| `OppgaverTests.hs` | The checks for `Oppgaver.hs`. You don't edit this either. |
| `../solutions/weekNN/` | Reference answers to the **book** exercises. Open **after** you've tried. |

The lecturer's sheets have **no reference answers, deliberately.** His first slide
asks students not to have AI solve them, and the groups don't hand out solutions
either. Their tests pin down only what the sheet actually specifies — where the sheet
asks *you* a question ("what should happen when the input is longer?"), or says *how*
to solve it (one traversal, tail recursion, a list comprehension), the tests stay out
of it and the idiom review picks it up.

The loop:

```bash
cd tutorial

./check.sh 3                 # both: the book, then the lecturer's sheet
./check.sh 3 --book          # just the book exercises
./check.sh 3 --oppg          # just the lecturer's sheet
./check.sh 3 --repl          # GHCi with your week-3 book code loaded
./check.sh 3 --oppg --repl   # GHCi with your week-3 sheet code loaded
./check.sh 3 --solution      # the book tests against the reference answers
```

Unimplemented stubs report as `todo`, not `FAIL`, so you can work one exercise at a
time and watch the count climb. Exit status is 0 only when everything passes.

**No dependencies.** The harness is a single file (`lib/Check.hs`) using nothing but
`base`. No stack, no installing packages — `runghc` and go.

There *is* an `inf122-tutorial.cabal` at the repo root, but it is not a build
system and you never run `cabal build`. It exists only so haskell-language-server
can load this code in an editor: every week defines modules called `Exercises`
and `Oppgaver`, so they need separate components, and the tests import `Check`
from `lib/`, so importer and imported must share one. `check.sh` is unaffected —
still `runghc`.
See [`../docs/setup-notes.md`](../docs/setup-notes.md).

### The two feedback loops

1. **Tests** — instant, mechanical, correctness only.
2. **Me** — when a week's tests are green, paste your `Exercises.hs` or
   `Oppgaver.hs` and ask for an **idiom review**. The tests can't tell you that your
   five-line recursion should have been a one-line `foldr`, and that distinction is
   most of what separates a C from an A in this course.

Everything outside those two files — the Hutton exercises this tutorial didn't pick
up (pensum point C), and the oblig — still comes with no tests in the box. Checking
those is a skill of its own —
[`../docs/checking-your-work.md`](../docs/checking-your-work.md) covers it, mostly with
QuickCheck, which is what the lecturer's week-1 slide introduces it for.

---

## The plan

| Week | Source | Topic | Why it matters |
|:--:|:--:|---|---|
| 1 | Hutton 1–2 | Mindset, GHCi, first steps | The `=` sign isn't assignment |
| 2 | Hutton 3 | Types and classes | `Ord a =>` explained; the type system is the course |
| 3 | Hutton 4 | Defining functions | Guards, pattern matching, lambdas, sections |
| 4 | Hutton 5 | List comprehensions | Generators, guards, the Caesar cipher |
| 5 | Hutton 6 | Recursive functions | **Learning outcome #1** |
| 6 | Hutton 7 | Higher-order functions | **Learning outcome #2** — `map`/`filter`/`foldr` |
| 7 | Hutton 8 | Declaring types and classes | **Learning outcome #3** — your own data types |
| 8 | Hutton 10 | Interactive programming | `IO`, and how purity survives side effects |
| 9 | Hutton 15 | Lazy evaluation | Infinite lists, `seq`, why `take 5 [1..]` works |
| 10 | *notes* | Enkel parsing | Examinable, and in no chapter of the book |
| 11 | *notes* | Typeinferens | Examinable, and in no chapter of the book |
| 12 | — | Exam prep | Timed, handwritten, no aids |

---

## Build status

Not all twelve weeks are written yet. Current state:

| Week | LESSON.md | Exercises + Tests | Solutions | Lecturer's sheet |
|:--:|:--:|:--:|:--:|:--:|
| 1 | done | done (19 checks) | done + PAPER.md | uke1 (29 checks) |
| 2 | done | done (31 checks) | done + PAPER.md | uke2 (5 checks, rest is paper) |
| 3 | done | done (42 checks) | done + PAPER.md | uke3 (30 checks) |
| 4 | done | done (50 checks) | done + PAPER.md | uke4 (47 checks) |
| 5 | done | done (63 checks) | done + PAPER.md | uke5 (55 checks) |
| 6 | done | done (81 checks) | done + PAPER.md | uke6 (30 checks; task 2 is week 7's Exercise 6) |
| 7 | done | done (89 checks) | done + PAPER.md | not published yet |
| 8 | done | done (76 checks) | done + PAPER.md | not published yet |
| 9 | done | done (56 checks) | done + PAPER.md | not published yet |
| 10–11 | blocked | blocked | blocked | not published yet |
| 12 | — | — | — | — |

**Lecturer's sheets** arrive one a week on Mitt UiB, and sheet *N* belongs to
tutorial week *N* — the same course week, so `uke3.txt` is `week03/Oppgaver.hs`.
When a new one lands, run the sync (it files the original under
`../weeks/ukeNN/exercises/`), then ask me to scaffold it: `Oppgaver.hs` stubs with the
task text verbatim, `OppgaverTests.hs`, one `weekNN-oppgaver` component in the
`.cabal` file, and a row in this table. The tests get verified against a throwaway
implementation that is deleted afterwards and never committed.

**Weeks 1–9 are complete** — lesson, exercises, tests, reference solutions and paper
answers, every week verified green against its own solution. **507 checks in total.**
That is *the whole of Hutton in pensum*: chapters 1–8, 10 and 15.

Weeks **10 and 11 cannot be written yet**. They are *enkel parsing* and *typeinferens*,
which appear in no chapter of the book — the lecturer's notes are the only source, and
they arrive in uke 42–44. Watch `../weeks/uke42/` onward; `python src/find.py parsing`
will search inside the PDFs the moment they land. Week 12 is exam prep and can be
written any time.

Two notes on how the later weeks are built. **Week 8 is mostly pure**: an IO action that
prints has no value to compare, so the exercises are the pure cores of Nim, Hangman and
Life, with IO left as a thin shell — which is the professional habit the chapter is
really teaching, and the reason 76 automatic checks over two interactive games are
possible at all. **Week 9 builds infinite structures**, and every test truncates them, so
a correct answer always terminates; a hang means a definition that recurses before
producing a constructor.

---

**The plan above changed once the real pensum arrived** (uke 34's
`1krav-plan+intro.pdf`, mirrored into `../weeks/uke34/slides/`). Two edits, both
to weeks not yet built:

- **Chapter 9, the countdown problem, is gone.** It isn't pensum. It is still the
  best single exercise in the book for assembling everything at once, so ask for
  it as a bonus week if you want it — just don't spend exam-revision time there.
- **Weeks 10 and 11 are now parsing and type inference.** These are examinable
  and appear in *no chapter of Hutton* — the lecturer's notes are the only
  source, and he flags them twice with "kun forelesningsnotater!". They arrive
  in uke 42–44, so those two tutorial weeks can only be written after his notes
  are published.

---

## What the course actually assesses

From the emneplan and his own first-lecture notes:

- **Exam: 2 December, 3 hours, written, _no aids permitted_.** You will write
  Haskell by hand on paper. Every `LESSON.md` therefore has a **paper exercises**
  section — do those without a computer. Typing fluency is not being tested.
- **One obligatorisk oppgåve**, October/November, deadline around 10 November,
  approved or not approved. The lecturer warns there is probably *no time to fix
  a rejected submission* — see `../assignments/`.
- Grading A–F; the oblig and the exam must pass independently.
- Pensum point (C) is **all exercises from the chapters covered**, assumed
  solved. The lecturer's weekly sheets are separate work again — the sheet itself
  says the book's exercises are solved *uavhengig* of it. Both live in each
  tutorial week now: the book in `Exercises.hs`, the sheet in `Oppgaver.hs`.

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
  week01/ ... week12/ LESSON.md, Exercises.hs, Tests.hs            -- the book
                      Oppgaver.hs, OppgaverTests.hs                -- the lecturer's sheet
  solutions/
    week01/ ...       Exercises.hs and PAPER.md per week (book only)
```

The repo's other folders are yours: `../weeks/ukeNN/code/` for code written in
class, `../assignments/` for the oblig, `../scratch/` for experiments. The
lecturer's original sheet text stays in `../weeks/ukeNN/exercises/`, where the sync
files it — `Oppgaver.hs` is where you answer it.

In VS Code the explorer hides all of that on purpose, nests `LESSON.md` and
`Tests.hs` under each `Exercises.hs`, and nests `OppgaverTests.hs` under each
`Oppgaver.hs`, so the sidebar shows the work and nothing else. Nothing is
deleted — it is one `files.exclude` block in `../.vscode/settings.json`.

---

## If you get stuck

In order:

1. `:t` the thing you don't understand. Most confusion is a type confusion.
2. Read the error message from the **bottom up** — GHC puts the useful part last.
3. Re-read the relevant Hutton section; each lesson names it.
4. Ask me. Paste the code *and* the full error.

The one habit worth building above all others: **when in doubt, ask GHCi for the
type.** Everything in this language falls out of the types.
