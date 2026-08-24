# Exam

**3 hours, written, no aids permitted.** You write Haskell by hand, on paper.

Nothing about the date is confirmed here yet — run `python src/canvas_sync.py`
and read `docs/canvas/course.md`, which mirrors whatever Mitt UiB says. Mitt UiB
is the source of truth; if this file disagrees with it, this file is wrong.

Both parts must pass independently: the obligatory exercises must be approved
before you may sit, and the exam is graded A–F on its own.

## What the exam actually tests

The learning outcomes name three things outright:

- **rekursjon** — write it, and reason about what it evaluates to
- **høgre ordens funksjonar** — `map`, `filter`, `foldr`, and functions returning functions
- **ikkje-muterbare datastrukturar** — why a list is never modified, only rebuilt

Plus one prose question in waiting: **discuss the difference between the
imperative and the functional paradigm.** That is an essay, not code, and it is
the easiest mark on the paper to leave on the table.

## Revising

No aids means typing fluency is worth nothing here and handwriting Haskell is
worth a lot. Each tutorial lesson has a paper-exercise section for exactly this:

```bash
python src/find.py "paper"           # find every paper drill
cd tutorial && ./check.sh 5          # then verify what you wrote by hand
```

Work a drill on paper first, type it in second, and note every place GHC
disagreed with you. That gap is your revision list.

## What goes in here

Past papers, the pensum list once it is confirmed, and your own revision
material. Anything the lecturer publishes about the exam arrives automatically
in `docs/canvas/course.md` — no need to copy it here by hand.
