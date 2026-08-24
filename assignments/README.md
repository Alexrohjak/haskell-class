# Obligatoriske oppgåver

**Must be approved before you may sit the exam.** That makes them a gate, not a
grade — but a missed one costs you the whole semester, so they come first.

Nothing is recorded here yet. Run `python src/canvas_sync.py`; every assignment
Mitt UiB publishes, with its deadline, lands in `docs/canvas/course.md` and the
week records. Check that rather than trusting this file.

## How to file one

One folder per assignment, named for what it is:

```
assignments/
  oblig1-recursion/
    Oblig1.hs          what you submit
    NOTES.md           what you were asked to do, and any decision you made
```

Keep the task text with the code. When oblig 3 asks you to build on oblig 1 and
Mitt UiB has since been reorganised, the copy in `NOTES.md` is the only record
of what was actually required.

## Before you submit

```bash
cd tutorial && ./check.sh <week>     # the week's tests still pass
ghc -Wall -fno-code path/to/Oblig1.hs   # no warnings, no compile
```

`-Wall` catches the two things that cost easy marks: non-exhaustive patterns and
unused bindings. Then ask me for an idiom review — the tests cannot tell you
that your five-line recursion wanted to be a `foldr`, and that is most of the
distance between a pass and a good grade.
