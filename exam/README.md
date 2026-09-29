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

## Revision guides written so far

- [`revision-uke34-35.md`](revision-uke34-35.md) — the first two lecture weeks:
  what was actually taught (with slide pages), the practice attached to them,
  and a six-hour route through it. Written 31 August.
- [`interactive-revision.html`](interactive-revision.html) — the drill room.
  70 concepts across Hutton 1–8 and 10 plus his grammar notes, each cited to the slide it came from, and 142
  drills. Published at <https://claude.ai/code/artifact/e3c608e9-c5c4-471a-b1c3-b710d40c945c>
  (private); open the local file with `xdg-open exam/interactive-revision.html`
  if you would rather not use the hosted copy. Every value and type in it was
  checked against GHC 9.10.3 before publishing.

  Each concept is a **reading page** with the same five parts: *In plain words*
  (the idea in ordinary language, before any notation), the precise version, a
  code listing, a second block that says what the rule costs you when you get it
  wrong and where it turns up again later, and a checkpoint question. Most also
  carry an interactive demo.

  **Week 5 — recursive functions, Hutton 6 — is uke38's material**, and it is the
  first week where the demos do real work: drag an input below zero and watch
  which definitions of `fac` still reach a base case, step `merge` one comparison
  at a time and switch its base case to `[]` to watch it silently lose half the
  data, or run `qsort` and `msort` over the same list and see the comparisons
  move from the split to the combine.

  A fourth tab, **Work**, is the bridge to the repo: the week's paper drills and
  its coding exercises, each with a hint ladder that gets more specific and stops
  where the thinking starts. Written for weeks 1–8.

  It contains **no answers** to `uke1.txt`, `uke2.txt` or the tutorial
  exercises — different examples, same ideas, deliberately. The hints name the
  trap, never the definition. It cannot run Haskell either: a browser has no
  GHC, so every drill ends by telling you what to type into GHCi.

## What goes in here

Past papers, and your own revision material. Anything the lecturer publishes
about the exam arrives automatically in `docs/canvas/course.md` — no need to copy
it here by hand.
