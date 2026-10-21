# Oblig H-2026 — parser + Hindley-Milner

The task: [`oblig.pdf`](oblig.pdf) (2 pages, published 16 October). Your file:
[`Oblig.hs`](Oblig.hs). Tests: `./tutorial/check.sh oblig`.

| | |
|---|---|
| **Frist** | **fredag 6. november 2026, kl. 16:00**. Late submissions are not assessed. |
| Second attempt | **None.** The first submission must be approved, or no exam. |
| Submit | one runnable `.hs` file under *Oppgaver/Oblig* on Mitt UiB |
| File must | start with a comment naming who submits it; load in GHCi; keep every type the PDF specifies unchanged |
| Help | the groups, 22.10 to 6.11. There are no lectures until Monday 16 November. |
| Afterwards | a short interview where you explain details of your solution (or a sample of students, if time is short) |
| Partner | allowed, at most two people (three only by arrangement) |

Canvas lists the assignment as due 8 November 23:59. The PDF says 6 November
16:00. **Go by the PDF**: it is the earlier date, and it is what the lecturer wrote.

## The rules on code

The PDF says: you may reuse code from the lectures, the book and the exercise
sheets. You may not duplicate code from anywhere else. And it says outright:
**"skal man ikke bruke KI til å programmere."**

What that means here:

- Your own `tutorial/week08/Oppgaver.hs` (parser) and `tutorial/week09/Oppgaver.hs`
  (`occursIn`, `unify`) count as exercise-sheet code. You can reuse them.
- **`tutorial/week0{7,8,9}/Svar.hs` are AI-written.** Don't copy anything from
  them into `Oblig.hs`. That is exactly what the rule forbids, and in the
  interview you would be asked to explain it.
- The lecturer's own material is fair game: `weeks/uke41/slides/8-grammatikk-hand.pdf`,
  `weeks/uke42/slides/9-unifi+HiMi-hand.pdf`, and his answers to sheet 9 del I in
  `weeks/uke42/exercises/uke9+fasit-typing.txt` (new on Mitt UiB, 12 October).
- I won't write any of `Oblig.hs`. I'll help with the repo, the tests, and
  questions about the lecture material.

## What the tests can and can't see

The PDF names the Ast constructors but not their arguments, and it names only
one Type constructor (`NumT`). So the tests can't build an Ast or a Type of
their own. They check only:

- `typeOf` on every example the PDF gives a result for (14 checks). Types are
  compared through your `Show`, the way the PDF prints them. Spacing, extra
  brackets and type-variable names don't matter.
- `main` with `t`, `f` and `q` fed in on stdin (3 checks).

`tokenise`, `parse`, `occursIn` and `unify` show up only through `typeOf`. So
the count stays at 0 until the whole pipeline works, and then it jumps. Check
each piece in GHCi on the way: `./tutorial/check.sh oblig --repl`.

## The route

The pipeline is `tokenise → parse → generateEqns → unify`, and `typeOf` chains
them. Build it bottom-up and check each piece in GHCi, since the suite only
goes green at the end.

**Phase 0: read (21 Oct)**
- [ ] Read `oblig.pdf` from start to finish, then the typing rules in `9-unifi+HiMi-hand.pdf`
- [ ] Settle the open questions below

**Phase 1: Sheet 9 Part II first (21–23 Oct)**
- [ ] `./tutorial/check.sh 09` green: `Show Type`, `subst`, `occursIn`, `unify`
- [ ] Port to §2. Changes: `Type` gets `NumT`; `unify`'s second argument is a `Type`, not a `String`; add the §2.1 name list

**Phase 2: parser, §1 (24–27 Oct)**
- [ ] `data Ast`: decide the argument types, write the choice under Decisions
- [ ] `tokenise`: what's new compared with Sheet 8 is multi-digit numbers, `->` as a token (not `-`), and `|`, `[`, `]`
- [ ] `parse`: one function per grammar level (Expr, Expr1, Value), the same pattern as Sheet 8.
      Application takes two *Values*; a lambda body extends as far right as it can
- [ ] Checkpoint: parse every §3.3 string in GHCi and read the trees off by hand

**Phase 3: `generateEqns`, §3.1–3.2 (28–31 Oct)**
- [ ] One case per Ast constructor. For each, find the matching line in your
      Sheet 9 Part I derivations (`weeks/uke42/exercises/uke9+fasit-typing.txt`)
- [ ] Operators: hard-coded or through `initialContext`. Write down which, and why
- [ ] Thread the fresh-name supply the way the parser threads leftover tokens
- [ ] Checkpoint: print the equations for `|x -> x` and compare with the paper version

**Phase 4: `typeOf` (1 Nov)**
- [ ] Connect the pieces; most of the 14 `typeOf` checks should turn green together

**Phase 5: `main`, §4 (2–3 Nov)**
- [ ] A `getLine` loop with `t`, `f`, `q`; `f` uses `readFile` and `lines`
- [ ] 17/17

**Phase 6: buffer (4–5 Nov)**
- [ ] The "Before submitting" checklist below. **Submit Thursday 5 Nov**, leaving Friday as margin

## Things to settle by reading, or at a group

- [ ] `:` in the grammar. Which Ast constructor does it become? Compare the
      operator list in 1.1 with the one in 3.1.
- [ ] Type-variable names. 2.1 says `"t1", "t2", ...`, but the examples print
      `t0`. Does the printed name have to match? (The tests don't care.)

## Before submitting

- [ ] `./tutorial/check.sh oblig`: 17/17
- [ ] `ghci -Wall assignments/oblig/Oblig.hs`: no warnings worth having
- [ ] Line 1 is the name comment, with your partner's name too if you have one
- [ ] Delete the scaffold's "Slett denne blokken" comment
- [ ] Types of `tokenise`, `parse`, `occursIn`, `unify` and `typeOf` are as in the PDF
- [ ] Try `main` by hand in GHCi: `t`, `f` on a file of your own, then `q`
- [ ] Explain every function aloud, as you would in the interview
- [ ] Upload, then download it again and load *that* copy in GHCi

## Decisions

Write down each choice the PDF leaves to you, with one line on why: the Ast
argument types, the Type constructors, Show by hand or derived, error messages.
This is your interview prep.

-
