# reference/

Material that is **public, re-downloadable, or not mine to redistribute**. Only
this file is tracked by git — everything you put beside it is ignored, so the
folder is per-machine and you fill it once on each computer you work from.

`find.py` indexes every PDF it finds in here, which is the point: the textbook
and the lecture notes are the two things you most need to search, and `grep`
cannot see inside a PDF.

## What to put here

| File | Where from |
|---|---|
| Hutton's chapter code (`code.zip`) | <https://www.cs.nott.ac.uk/~pszgmh/pih.html> |
| Hutton, *Programming in Haskell* (2nd ed.), as PDF | your own copy — it is not free |
| Anything else you want searchable | wherever you got it |

The book itself is pensum point (A), kap. 1–8, 10 and 15. Nothing in this repo
can substitute for it; the tutorial lessons name the sections they follow and
assume you have it open.

After adding a PDF:

```bash
.venv/bin/python src/find.py --rebuild foldr    # re-extract, then search
.venv/bin/python src/find.py --sources          # confirm it is indexed
```

## One warning

Hutton's archive contains **worked answers to the book's exercises**, which
pensum point (C) assumes you have solved yourself. The lecturer's own first
slide is blunt about it:

> *NB! AI kan løse problemer på dette nivå: vil du lære så bruker du den ikke.*

The same logic applies to a zip file. Reading a solution before you have
struggled with the problem feels like learning and is not — and the exam is
three hours, handwritten, with no aids, so anything you did not build yourself
is worth nothing on the day.

`find.py` hides `tutorial/solutions/` unless you pass `--solutions`. It has no
such protection for what you put in here.
