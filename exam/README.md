# Eksamen — 2. desember 2026

**3 hours, written, no aids permitted.** You write Haskell by hand, on paper.
The date is from the lecturer's plan (`weeks/uke34/slides/1krav-plan+intro.pdf`,
p.2: *"49: 2.12 – Eksamen"*). Mitt UiB is the source of truth — re-run the sync
and check `docs/canvas/course.md` before you trust this file.

Two independent gates: the **obligatorisk oppgåve** must be approved before you
may sit, and the exam is then graded A–F on its own.

## What is examinable

- **(A)** Hutton, kap. **1–8, 10, 15**
- **(B)** *All* forelesningsnotater — this is where **parsing** and
  **typeinferens** live, and they are in no chapter of the book
- **(C)** *All* exercises from the chapters covered — assumed solved

Chapter 9 (countdown) and chapters 11–14 are not pensum.

The learning outcomes name three things outright — **rekursjon**, **høgre ordens
funksjonar**, **ikkje-muterbare datastrukturar** — plus being able to *discuss*
the difference between the imperative and the functional paradigm. That last one
is an essay question in waiting, and the easiest mark on the paper to leave on
the table. His own intro notes argue that case on slides 3–6; they are the model
answer, so read them before you write your own.

## Revising

No aids means typing fluency is worth nothing and handwriting Haskell is worth a
lot. Each tutorial lesson has a paper-exercise section for exactly that:

```bash
.venv/bin/python src/find.py typeinferens   # the notes are PDFs — grep can't see them
.venv/bin/python src/find.py "paper"        # every paper drill in the tutorial
cd tutorial && ./check.sh 5                 # then verify what you wrote by hand
```

Work a drill on paper first, type it in second, and note every place GHC
disagreed with you. That gap is your revision list.

Weeks 47 and 48 are gjennomgang of the oblig and open Q&A — the last chance to
ask the person who writes the paper what he expects on it.

## What goes in here

Past papers, and your own revision material. Anything the lecturer publishes
about the exam arrives automatically in `docs/canvas/course.md` — no need to copy
it here by hand.
