# INF122 — Funksjonell programmering

UiB, autumn 2026, 10 ECTS. Everything for this subject lives here.

Mitt UiB: https://mitt.uib.no/courses/59171 · Emneplan: https://www.uib.no/emne/INF122

Forelesningar: **mandag 08:15–10, tysdag 14:15–16**. Gruppetimar: torsdag 10:15,
fredag 10:15 or fredag 12:15 — or a small group (2–5 people, ≤30 min) arranged
by email with a gruppeleiar. Emneansvarleg: Michal Walicki
(`Michal.Walicki@uib.no`). Exam and Mitt UiB admin: `Jenny.Thunes@uib.no`.
Contact details for the gruppeleiarar are in [`docs/canvas/course.md`](docs/canvas/).

## Start working

```bash
cd ~/code/haskell-class
.venv/bin/python src/week.py   # what week is it, what is filed
cd tutorial && ./check.sh 2    # work this week's tutorial
```

Verify the toolchain: `.venv/bin/python src/check_setup.py`. It runs week 1's
tests against the reference solution, so a green result means GHC, the harness
and the runner all work — not just that the binaries exist.

The Python side is only for the scripts in `src/`, and this machine has no bare
`python` on the PATH — only `python3`, without the packages the scripts need.
So call the venv's interpreter directly, as above, or activate it once per
terminal and drop the prefix:

```bash
source .venv/bin/activate      # then plain `python src/...` works
```

Nothing in Haskell needs it.

## Pensum

From the lecturer's own plan, [`weeks/uke34/slides/1krav-plan+intro.pdf`](weeks/uke34/slides/) p.2:

- **(A)** Hutton, *Programming in Haskell* (2016) — **kap. 1–8, 10, 15**
- **(B)** *All* forelesningsnotater. Parsing and type inference are examinable
  and appear in **no chapter of the book** — the notes are the only source.
- **(C)** *All* exercises from the chapters covered — assumed solved.

Note what is **not** in it: chapter 9 (the countdown problem), and 11–14. The
weekly exercise sheets are separate work from the book's exercises; `uke1.txt`
says so outright.

## Semester plan

His "tentativ framdriftsplan", verbatim, in ISO weeks. Mitt UiB is the source of
truth — re-run the sync and update `PLAN` in `src/week.py` when it changes.

| Uke | Dates | Tema | Tutorial | Folder |
|-----|-------|------|----------|--------|
| 34 | 17.–23. aug | kap. 1–2 (15) | [week01](tutorial/week01/) | [`uke34`](weeks/uke34/) |
| 35 | 24.–30. aug | kap. 3–4 | [week02](tutorial/week02/) | [`uke35`](weeks/uke35/) |
| 36 | 31. aug–6. sep | kap. 4–5 † | [week03](tutorial/week03/) | [`uke36`](weeks/uke36/) |
| 37 | 7.–13. sep | kap. 5–8 | [week04](tutorial/week04/) | [`uke37`](weeks/uke37/) |
| 38 | 14.–20. sep | kap. 5–8 | week05 | [`uke38`](weeks/uke38/) |
| 39 | 21.–27. sep | kap. 5–8 | week06 | [`uke39`](weeks/uke39/) |
| 40 | 28. sep–4. okt | kap. 5–8 | week07 | [`uke40`](weeks/uke40/) |
| 41 | 5.–11. okt | kap. 10 | week08 | [`uke41`](weeks/uke41/) |
| 42 | 12.–18. okt | kap. 10 · enkel parsing | week09 | [`uke42`](weeks/uke42/) |
| 43 | 19.–25. okt | enkel parsing · typeinferens | week10 | [`uke43`](weeks/uke43/) |
| 44 | 26. okt–1. nov | typeinferens · **Oblig opens** | week11 | [`uke44`](weeks/uke44/) |
| 45 | 2.–8. nov | Oblig | — | [`uke45`](weeks/uke45/) |
| 46 | 9.–15. nov | Oblig — frist ~10. nov | — | [`uke46`](weeks/uke46/) |
| 47 | 16.–22. nov | Resultat og gjennomgang av Oblig | — | [`uke47`](weeks/uke47/) |
| 48 | 23.–29. nov | Spørsmål og svar | week12 | [`uke48`](weeks/uke48/) |
| 49 | 30. nov–6. des | **Eksamen 2. desember** — 3t skriftleg, ingen hjelpemiddel | — | [`exam/`](exam/) |

† His plan said "kap. 3–4" here as well. The notes he actually published for
the week are titled *[kap.4–5]* — patterns, lists and list comprehensions — so
the table follows the slides. He is running a chapter ahead of his own plan, and
has already dipped into two later chapters: lazy evaluation (kap. 15) in lecture
1, and type classes (kap. 8.1–8.5) in lecture 2. Nothing in the pensum changed —
only the order.

The oblig weeks and the exam week have no tutorial week. The rest of the column
is my mapping, not his: it points at the tutorial week whose chapter the course
is on, and tutorial weeks 10 and 11 are parsing and type inference — the two
topics no chapter of Hutton covers. `PLAN` in [`src/week.py`](src/week.py) is
the source of truth for this column; the week records are generated from it, so
edit it there and this table follows.

**One obligatorisk oppgåve**, October/November, deadline around 10 November.
Godkjent/ikke-godkjent, no part-grade — and he warns there will probably be *no
time to fix a rejected submission*. That makes it the one hard deadline in the
semester. See [`assignments/`](assignments/).

## Two tracks, one repo

This repo holds two different things, and keeping them apart is the point.

- **[`weeks/ukeNN/`](weeks/)** — the course. What the *lecturer* published, plus
  the code you wrote in class. The `README.md` in each is **generated** by the
  sync: it records what was posted. Don't hand-edit it.
- **[`tutorial/`](tutorial/)** — the 12-week self-study track, with tests, at
  2–3 h/week. Yours to edit, and the only place with a feedback loop that tells
  you when you're right.

## Where things go

| I have… | It goes in… |
|---|---|
| A lecture note or slide deck | `weeks/ukeNN/slides/` — or just re-run the sync |
| The week's exercise sheet | `weeks/ukeNN/exercises/` — the sync files these too |
| Code I wrote in class | `weeks/ukeNN/code/` |
| My answer to a weekly exercise | `weeks/ukeNN/code/` |
| My answers to the tutorial | `tutorial/weekNN/Exercises.hs` |
| The obligatorisk oppgåve | `assignments/` |
| A useful link | `resources/links.md` |
| Revision material | `exam/` — the [uke34–35 guide](exam/revision-uke34-35.md) and the [drill room](exam/interactive-revision.html) |
| A half-formed idea | `scratch/` — no rules there |

## Finding things

```bash
.venv/bin/python src/find.py foldr        # where is this covered?
.venv/bin/python src/find.py --sources    # what is indexed
```

Searches the week records, the Mitt UiB mirror, every lesson, every exercise and
test file, your own Haskell, and every lecture-note PDF — and reports the page or
line, so you can go straight there. `grep` only reads the text files; the notes
arrive as PDF, and since parsing and type inference exist *only* in those notes,
searching inside them is not optional.

**Solutions are excluded by default.** Pass `--solutions` when you mean it.

First run extracts and caches. After that it is instant until a file changes.
The cache lives in `.searchcache/`, is gitignored, and can be deleted any time.

## Syncing from Mitt UiB

Mitt UiB is the source of truth, and it changes weekly. `src/canvas_sync.py`
mirrors it into this repo — read-only, GETs only. It never submits an
assignment, marks a module complete, or changes a single setting.

```bash
.venv/bin/python src/canvas_sync.py                # refresh, and pull new files into weeks/
.venv/bin/python src/canvas_sync.py --no-download  # text only, skip the files
```

Needs an API token in `.env` (gitignored — see `.env.example`). Generate one at
*Account → Settings → + New Access Token*, and revoke it when the course ends.

This course publishes almost nothing on pages: the lecture notes live in Canvas
`Filer/forelesningsnotater/` and the weekly exercises in `Filer/oppgaver/`. UiB
lets students read that folder tree, so the sync walks it and files each item by
the week number in its name — `uke1.txt` and `1krav-plan+intro.pdf` are both
course week 1, which is uke34. Anything whose week can't be worked out lands in
`docs/canvas/files/` for you to place by hand; nothing is guessed at.

Output: [`docs/canvas/course.md`](docs/canvas/) (the whole course flattened), a
generated `README.md` per week folder, and `resources/canvas-links.md`.
**Don't edit those by hand** — re-run the script.

Two things stay out of reach, both Canvas permission boundaries rather than bugs:
LTI external tools (**Panopto**, **Litteraturliste**) have no API, and the page
index is disabled for this course, so pages are found through modules instead.

## Reference material

`reference/` is gitignored — everything in it is public and re-downloadable, so
it is not this repo's job to version it. Put Hutton's chapter code there (the zip
is linked from his book page in [`resources/links.md`](resources/links.md)), plus
any PDF you want `find.py` to index.

> **A warning.** Hutton's archive contains worked code for the book's exercises —
> which pensum point (C) assumes you have solved yourself. Reading it before you
> have struggled with the problem feels like learning and is not.

## Environment

GHC 9.10.3, cabal 3.16.1, stack 3.11.1, all via GHCup. Reinstall on a new
machine with:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

Also installed, both of which the course expects and plain GHC does not give you:
**QuickCheck 2.18** (his notes use it from week 1) and **HLS 2.14** (point your
editor at `haskell-language-server-wrapper`). The tutorial harness still needs
**nothing beyond `base`** — no project file, just `runghc`.

> **One thing needed root, and is now done.** GHC could interpret but not
> *link*: Ubuntu ships `libgmp10` while the linker wants `libgmp.so`, which comes
> with `libgmp-dev`. `ghci`, `runghc` and the tutorial were unaffected, but
> `cabal build` failed — and the oblig is a cabal project. Fixed on 24 August
> with `sudo apt install libgmp-dev`; `ghc -o` and `cabal build` are both
> verified in a scrubbed environment. On a **new machine** you will hit this
> again: [`docs/setup-notes.md`](docs/setup-notes.md) has the whole story, and
> `check_setup.py` catches it in one run.

In GHCi: `:r` reload, `:t expr` type of, `:i` info, `:q` quit. The one habit
worth building above all others is asking GHCi for the type — everything in this
language falls out of the types.

## What the lecturer said about AI

On the first slide of his own intro, verbatim:

> *NB! AI kan løse problemer på dette nivå: vil du lære så bruker du den ikke.*

Take it seriously — the exam is three hours, handwritten, with no aids, so
anything you didn't build yourself is worth nothing on the day. The same slide
says the groups serve no solutions and you must have attempted the problems
first. This repo is set up to match: `find.py` hides `tutorial/solutions/`
unless you ask for them, and the useful thing to ask me for is an **idiom review
after your tests are green** — not an answer before you've fought for it.

## Repo rules

- **Private repo.** Lecture notes are the lecturer's copyright. Don't make it
  public, and don't push anything you'd be uncomfortable sharing.
- `.env`, `.venv/`, `.searchcache/` and `reference/` are gitignored — secret,
  generated, or re-downloadable.
- Commit at the end of each week. `git add -A && git commit -m "uke NN"`.
