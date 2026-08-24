# INF122 — Funksjonell programmering

UiB, autumn 2026, 10 ECTS. Everything for this subject lives here.

Mitt UiB: https://mitt.uib.no/courses/59171 · Emneplan: https://www.uib.no/emne/INF122

## Start working

```bash
cd ~/code/haskell-class
python src/week.py             # what week is it, what is filed
cd tutorial && ./check.sh 2    # work this week's tutorial
```

Verify the toolchain: `python src/check_setup.py`. It runs week 1's tests
against the reference solution, so a green result means GHC, the harness and the
runner all work — not just that the binaries exist.

The Python side is only for the scripts in `src/`:

```bash
source .venv/bin/activate      # needed for canvas_sync.py and find.py
```

Nothing in Haskell needs it.

## Semester plan

**Provisional.** ISO week numbers, matching Mitt UiB. The topics are not filled
in yet — run the sync and update `PLAN` in `src/week.py` to match what Mitt UiB
says. Mitt UiB is the source of truth; where this table disagrees with it, this
table is wrong.

| Uke | Dates | Tema | Tutorial | Folder |
|-----|-------|------|----------|--------|
| 34 | 17.–23. aug | *(TBA)* | [week01](tutorial/week01/) | [`uke34`](weeks/uke34/) |
| 35 | 24.–30. aug | *(TBA)* | [week02](tutorial/week02/) | [`uke35`](weeks/uke35/) |
| 36 | 31. aug–6. sep | *(TBA)* | [week03](tutorial/week03/) | [`uke36`](weeks/uke36/) |
| 37 | 7.–13. sep | *(TBA)* | week04 | [`uke37`](weeks/uke37/) |
| 38 | 14.–20. sep | *(TBA)* | week05 | [`uke38`](weeks/uke38/) |
| 39 | 21.–27. sep | *(TBA)* | week06 | [`uke39`](weeks/uke39/) |
| 40 | 28. sep–4. okt | *(TBA)* | week07 | [`uke40`](weeks/uke40/) |
| 41 | 5.–11. okt | *(TBA)* | week08 | [`uke41`](weeks/uke41/) |
| 42 | 12.–18. okt | *(TBA)* | week09 | [`uke42`](weeks/uke42/) |
| 43 | 19.–25. okt | *(TBA)* | week10 | [`uke43`](weeks/uke43/) |
| 44 | 26. okt–1. nov | *(TBA)* | week11 | [`uke44`](weeks/uke44/) |
| 45 | 2.–8. nov | *(TBA)* | week12 | [`uke45`](weeks/uke45/) |
| 46 | 9.–15. nov | *(TBA)* | — | [`uke46`](weeks/uke46/) |
| 47 | 16.–22. nov | *(TBA)* | — | [`uke47`](weeks/uke47/) |
| — | *(TBA)* | **Eksamen — 3t skriftleg, ingen hjelpemiddel** | — | [`exam/`](exam/) |

The tutorial column is a guess: week 1 of the tutorial against the first
teaching week, and so on. Real lectures never keep that pace exactly — once the
lecture plan is synced, re-map it in `src/week.py`.

**Obligatoriske oppgåver must be approved** before you can sit the exam. See
[`assignments/`](assignments/).

## Two tracks, one repo

This repo holds two different things, and keeping them apart is the point.

- **[`weeks/ukeNN/`](weeks/)** — the course. What the *lecturer* published, plus
  the code you wrote in class. The `README.md` in each is **generated** by the
  sync: it records what was posted. Don't hand-edit it.
- **[`tutorial/`](tutorial/)** — the 12-week self-study track, aligned to Hutton
  ch. 1–10 and 15, with tests. Runs *alongside* lectures at 2–3 h/week. Yours to
  edit, and the only place with a feedback loop that tells you when you're right.

Weeks 1–3 of the tutorial are built (week 3 still needs its `LESSON.md`);
4–12 are planned. See [`tutorial/README.md`](tutorial/README.md).

## Where things go

| I have… | It goes in… |
|---|---|
| A lecture slide deck | `weeks/ukeNN/slides/` — or just re-run the sync |
| Code I wrote in class | `weeks/ukeNN/code/` |
| A weekly exercise sheet | `weeks/ukeNN/exercises/` |
| My answers to the tutorial | `tutorial/weekNN/Exercises.hs` |
| An obligatorisk oppgåve | `assignments/` |
| A useful link | `resources/links.md` |
| Revision material | `exam/` |
| A half-formed idea | `scratch/` — no rules there |

## Finding things

```bash
python src/find.py foldr             # where is this covered?
python src/find.py --sources         # what is indexed
```

Searches the week records, the Mitt UiB mirror, every lesson, every exercise
and test file, your own Haskell, and any slide deck or textbook PDF you have
filed — and reports the page or line, so you can go straight there. `grep` only
reads the text files; lecture material arrives as PDF, which is exactly what you
want during revision.

**Solutions are excluded by default.** Pass `--solutions` when you mean it —
searching for an answer you haven't earned yet feels like learning and isn't.

First run extracts and caches. After that it is instant until a file changes.
The cache lives in `.searchcache/`, is gitignored, and can be deleted any time.

## Syncing from Mitt UiB

Mitt UiB is the source of truth, and it changes weekly. `src/canvas_sync.py`
mirrors it into this repo — read-only, GETs only. It never submits an
assignment, marks a module complete, or changes a single setting.

```bash
python src/canvas_sync.py                # refresh, and pull new files into weeks/*/slides/
python src/canvas_sync.py --no-download  # text only, skip the files
```

Needs an API token in `.env` (gitignored — see `.env.example`). Generate one at
*Account → Settings → + New Access Token*, and revoke it when the course ends.

Output lands in [`docs/canvas/course.md`](docs/canvas/) — a flattened mirror of
every page, announcement and assignment — plus a generated `README.md` in each
week folder and every off-Canvas link in `resources/canvas-links.md`.
**Don't edit any of those by hand**; re-run the script.

Two known limits, both Canvas permission boundaries rather than bugs. Students
usually cannot enumerate the course Files area, so the script finds files by
scanning page links — an uploaded-but-unlinked file stays invisible. And LTI
external tools (Panopto, Zoom, Pensum/Litteratur) are unreachable through the
API; open those in a browser.

## Reference material

`reference/` is gitignored — everything in it is public and re-downloadable, so
it is not this repo's job to version it. Put Hutton's chapter code there (the
zip is linked from his book page in [`resources/links.md`](resources/links.md)),
along with any PDF you want `find.py` to index.

> **A warning.** Hutton's archive contains worked code for the exercises.
> Reading it before you have struggled with the problem feels like learning and
> is not — which is also why `find.py` skips `tutorial/solutions/` unless you
> pass `--solutions`.

## Environment

GHC 9.10.3, cabal 3.16.1, stack 3.11.1, all via GHCup. Reinstall on a new
machine with:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

The tutorial harness deliberately needs **no packages beyond `base`** — no
cabal project, no stack project, just `runghc`. If you ever need a real build
for an obligatorisk oppgåve, `cabal init` inside that assignment's folder and
keep it local to that folder.

In GHCi: `:r` reload, `:t expr` type of, `:i` info, `:q` quit. The one habit
worth building above all others is asking GHCi for the type — everything in this
language falls out of the types.

## Repo rules

- **Private repo.** Lecture slides are the lecturer's copyright. Don't make it
  public, and don't push anything you'd be uncomfortable sharing.
- `.env`, `.venv/`, `.searchcache/` and `reference/` are gitignored — secret,
  generated, or re-downloadable.
- Commit at the end of each week. `git add -A && git commit -m "uke NN"`.
