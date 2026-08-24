# Obligatorisk oppgåve

**One** larger obligatorisk oppgåve, October/November, **deadline around 10
November**. Godkjent/ikke-godkjent, no part-grade — and the lecturer warns
there will probably be **no time to fix a rejected submission**:

> *det blir neppe tid til å rette på en ikke-godkjent innlevering!*
> — `weeks/uke34/slides/1krav-plan+intro.pdf`, p.1

Approval is the only academic requirement for sitting the exam. So this is the
one hard deadline in the semester, and it has no second attempt built in. Start
it the week it opens (uke 44), not the week it's due.

Nothing is published yet. Run `python src/canvas_sync.py`; the task and its real
deadline land in `docs/canvas/course.md` and the week records. Check that rather
than trusting this file.

## How to file it

```
assignments/
  oblig/
    NOTES.md           what you were asked to do, and every decision you made
    *.hs               the code
    oblig.cabal        cabal is what the course expects for the bigger tasks
```

Keep the task text with the code. Mitt UiB gets reorganised, and access
disappears when the course ends; the copy in `NOTES.md` is then the only record
of what was actually required.

`cabal init` inside `assignments/oblig/` — keep the project local to that folder
so the tutorial harness stays dependency-free.

## Before you submit

```bash
cabal build                              # it compiles as a project, not just a file
ghc -Wall -fno-code path/to/Oblig.hs     # no warnings
cabal install --lib QuickCheck           # if you're property-testing it
```

`-Wall` catches the two things that cost easy marks: non-exhaustive patterns and
unused bindings. Then ask me for an idiom review — the tests can't tell you that
your five-line recursion wanted to be a `foldr`, and that is most of the distance
between a pass and good work.
