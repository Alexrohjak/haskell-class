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
cd tutorial && ./check.sh 8    # work this week's tutorial
```

Verify the toolchain: `.venv/bin/python src/check_setup.py`. It runs week 1's
tests against the reference solution, so a green result means GHC, the harness
and the runner all work — not just that the binaries exist.

The tutorial is the only track with a test harness. The lecturer's weekly sheets
ship with nothing, and checking your answers to those — with GHCi, with the
sheet's own examples, and with QuickCheck, which is what his week-1 slide
introduces it for — is its own skill:
[`docs/checking-your-work.md`](docs/checking-your-work.md).

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
says so outright. Both get done: each tutorial week carries the book's exercises
in `Exercises.hs` and the lecturer's sheet in `Oppgaver.hs`.

## Semester plan

His "tentativ framdriftsplan", verbatim, in ISO weeks. Mitt UiB is the source of
truth — re-run the sync and update `PLAN` in `src/week.py` when it changes.

| Uke | Dates | Tema | Tutorial | Folder |
|-----|-------|------|----------|--------|
| 34 | 17.–23. aug | kap. 1–2 (15) | [week01](tutorial/week01/) | [`uke34`](weeks/uke34/) |
| 35 | 24.–30. aug | kap. 3–4 | [week02](tutorial/week02/) | [`uke35`](weeks/uke35/) |
| 36 | 31. aug–6. sep | kap. 4–5 † | [week03](tutorial/week03/) | [`uke36`](weeks/uke36/) |
| 37 | 7.–13. sep | kap. 5–8 | [week04](tutorial/week04/) | [`uke37`](weeks/uke37/) |
| 38 | 14.–20. sep | kap. 5–8 | [week05](tutorial/week05/) | [`uke38`](weeks/uke38/) |
| 39 | 21.–27. sep | kap. 5–8 | [week06](tutorial/week06/) | [`uke39`](weeks/uke39/) |
| 40 | 28. sep–4. okt | kap. 10 (IO) ‡ | [week07](tutorial/week07/) | [`uke40`](weeks/uke40/) |
| 41 | 5.–11. okt | grammatikk · enkel parsing ‡ | [week08](tutorial/week08/) | [`uke41`](weeks/uke41/) |
| 42 | 12.–18. okt | unifikasjon · typeinferens · **Oblig kunngjøres** ‡ | [week09](tutorial/week09/) | [`uke42`](weeks/uke42/) |
| 43 | 19.–25. okt | typeinferens ‡ | week10 | [`uke43`](weeks/uke43/) |
| 44 | 26. okt–1. nov | typeinferens · Oblig | week11 | [`uke44`](weeks/uke44/) |
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

‡ From uke 40 the table follows what he published instead of the tentative
plan. His IO notes (`7-IO-hand.pdf`) are course week 7 and the grammar and
parsing notes (`8-grammatikk-hand.pdf`) are week 8, so parsing arrived a week
earlier than planned. His announcement of 27 September says the two to three
weeks after IO are grammars and parsing, the unification algorithm, and type
inference, and that the oblig is expected to be announced around mid-October.
The unification and type-inference notes (`9-unifi+HiMi-hand.pdf`, course week
9) followed on 5 October and are filed under uke 42.
The tutorial column did not move: sheet *N* still lives in tutorial week *N*,
so the book chapter in a tutorial week now trails the lectures.

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
- **[`tutorial/`](tutorial/)** — where the weekly work gets done, with tests.
  Each week holds the book's exercises (`Exercises.hs`) *and* the lecturer's
  sheet for that week (`Oppgaver.hs`), and `./check.sh N` runs both. Yours to
  edit, and the only place with a feedback loop that tells you when you're right.

## Where things go

| I have… | It goes in… |
|---|---|
| A lecture note or slide deck | `weeks/ukeNN/slides/` — or just re-run the sync |
| The week's exercise sheet (original) | `weeks/ukeNN/exercises/` — the sync files these too |
| Code I wrote in class | `weeks/ukeNN/code/` |
| My answers to the lecturer's sheet | `tutorial/weekNN/Oppgaver.hs` |
| My answers to the book exercises | `tutorial/weekNN/Exercises.hs` |
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
**QuickCheck 2.18** (his notes use it from week 1) and **HLS 2.14**. The tutorial
harness still needs **nothing beyond `base`** — no project file, just `runghc`.

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

## Editing

**VS Code** is set up for this repo — `code ~/code/haskell-class` and open a
week's `Exercises.hs`. The `haskell.haskell` extension drives HLS 2.14 against
the ghcup toolchain already here, so you get types on hover (the Prelude's too,
which is half the hint in most exercises) and live error squiggles that match
what `check.sh` prints.

| | |
|---|---|
| hover a name | its type |
| `Ctrl+Shift+B` | run `check.sh` for the week that owns the open file |
| *Tasks: Run Task* → GHCi | that week's REPL, loaded |
| `Shift+Alt+F` | format — deliberately **not** on save |
| `Ctrl+K Ctrl+/` | fold every comment block, when the file feels wordy |

The explorer is cut down to the two files you type into — `tutorial/weekNN/Exercises.hs`
for the book track and `tutorial/weekNN/Oppgaver.hs` for the lecturer's — with
`LESSON.md` and `Tests.hs` nested under each `Exercises.hs`, and `OppgaverTests.hs`
under each `Oppgaver.hs`. The sheet's own text stays visible in
`weeks/ukeNN/exercises/`. That is a display setting in `.vscode/settings.json`; hidden
files still compile, still load, still show in git, and still open by path
(`code exam/README.md`). The reading material is meant to be read in the
browser; the editor is the workbench.

> **This bit was wrong until 14 September.** The block hid `weeks/` outright.
> It was written before the second track existed and nobody revisited it when
> the sheets arrived, so `uke1.txt`–`uke4.txt` sat in the repo and never
> appeared in the sidebar. If you are ever sure you filed something and cannot
> find it, check `files.exclude` before you check your memory.

Two pieces of plumbing make this work, and neither is a build system you run:
`hie.yaml` and `inf122-tutorial.cabal` exist **only** so the language server can
load the code, because every week defines a module called `Exercises` and they
cannot share a unit. `check.sh` is still plain `runghc`. Full reasoning, and the
one cosmetic startup error you can ignore, in
[`docs/setup-notes.md`](docs/setup-notes.md).


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
