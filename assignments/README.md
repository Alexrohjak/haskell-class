# Obligatorisk oppgåve

**Published 16 October. Frist: fredag 6. november 2026, kl. 16:00.** This is the
one hard deadline in the semester. It is pass/fail with **no second attempt**,
and approval is the only requirement for sitting the exam.

Everything for it is in [`oblig/`](oblig/):

| File | What |
|---|---|
| [`oblig/oblig.pdf`](oblig/oblig.pdf) | the task, as published on Mitt UiB |
| [`oblig/Oblig.hs`](oblig/Oblig.hs) | the file you submit: the task text as comments, with stubs |
| [`oblig/ObligTests.hs`](oblig/ObligTests.hs) | 17 checks: the PDF's own examples for `typeOf`, plus `main` |
| [`oblig/NOTES.md`](oblig/NOTES.md) | the rules, open questions, the submit checklist, your decisions |

```bash
./tutorial/check.sh oblig            # the tests
./tutorial/check.sh oblig --repl     # GHCi with Oblig.hs loaded
```

In VS Code, `Ctrl+Shift+B` from `Oblig.hs` runs the same tests.

The PDF asks for a **single `.hs` file that loads in GHCi**. That's why there is
no cabal project here, even though this README once expected one. The
`oblig-tests` component in `inf122-tutorial.cabal` is only there so the editor
can load the file.

**On AI:** the PDF itself says *"skal man ikke bruke KI til å programmere"*, and
after submitting you may be called to an interview to explain your code. The
`Svar.hs` files in the tutorial are AI-written, so keep them out of this file.
See `oblig/NOTES.md`.
