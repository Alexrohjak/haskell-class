# Revision — uke 34 and uke 35

*Written 31 August 2026, the Monday of uke 36. Point-in-time: it describes the
two weeks behind us, and does not update itself.*

Four lecture hours are behind you (uke 34: 17.–23. aug, uke 35: 24.–30. aug) and
none of the practice attached to them has been started. That is the whole status
in one sentence, and the rest of this file is a route out of it.

---

## What he actually taught

Page numbers are the handout pages, so you can go straight there.

### uke 34 — [`1krav-plan+intro.pdf`](../weeks/uke34/slides/) (21 s.)

| s. | Topic | Where it lands |
|:--:|---|---|
| 2 | Pensum and the framdriftsplan | Hutton 1–8, 10, 15 + all notes |
| 3–8 | FP principles: expressions not statements, no side effects, referential transparency, imperative vs functional | **Essay question in waiting** |
| 9–10 | GHCi, `.hs` files, `:load` | Done — your toolchain is green |
| 11–12 | First functions; `let … in`, `where` | Hutton 1–2 |
| **13** | **Lazy evaluation, call-by-need, outside-in** | **Hutton 15** — taught in week 1 |
| 14–15 | Naming, `f a b` ≠ `f(a,b)`, indentation rules | Every exam answer depends on this |
| 16–18 | No loops, only recursion; `fact`, `fib`; lists and patterns | Hutton 2, and forward to 6 |
| 19 | Central list functions | `head`, `tail`, `init`, `last`, `++`, `length`, `reverse` |
| 20–21 | Worked `like`, worked `qs` (quicksort) | The canonical first recursion |

Plus [`1QuickCheck.pdf`](../weeks/uke34/slides/) — property testing a sort
function. QuickCheck 2.18 is installed, so this one runs as written.

### uke 35 — [`2typer-handout.pdf`](../weeks/uke35/slides/) (20 s.)

| s. | Topic | Where it lands |
|:--:|---|---|
| 1 | QuickCheck again | Repeat from uke 34 |
| 2 | Types as sets of values | Hutton 3 |
| 3–4 | Type errors vs run-time errors; `last []` | Why partial functions bite |
| 5 | Type inference exists, deferred to later | Foreshadows the **typeinferens** notes |
| 6–8 | Base types and their operators | `Int`, `Integer`, `Bool`, `Char`, `Float` |
| **9** | **Type classes: `Show`, `Read`, `Eq`, `Ord`, `Num`** | **Hutton 8.1–8.5** — taught in week 2 |
| 10 | `1 :: Num t => t` and friends — defaulting | The classic confusion |
| 11–13 | Type constructors: `[T]`, `(T,T)`, `T -> T`; the grammar for type expressions | Directly drilled by `uke2.txt` |
| 14, 18 | Worked "what is the type of…" examples | **The exam-style question** |
| 15–17 | Function types, lambdas, the full type summary | Hutton 3 |
| 19 | **Currying** — `div 7 2` vs `` 7 `div` 2 ``, `curry`/`uncurry` | Hutton 3.6 |
| 20 | Teaser: user-defined types | Hutton 8 |

### The pace

His tentative plan said kap. 3–4 for both uke 35 and uke 36. What he is actually
doing is a chapter ahead of that, and he has already reached into two chapters
the plan puts much later — **kap. 15** (lazy evaluation, uke 34 s.13) and **kap.
8.1–8.5** (type classes, uke 35 s.9). Today's notes are titled *[kap.4–5]*.

Nothing has left the pensum. The order changed, so don't treat the plan's week
column as a promise about what a lecture will contain.

---

## The practice that exists, and is untouched

| Source | Work | State |
|---|---|:--:|
| [`weeks/uke34/exercises/uke1.txt`](../weeks/uke34/exercises/) | 5 tasks — `plu`, `pali`, `hjuster`/`vjuster`, `evens`/`odds`, `evensOdds` | not started |
| [`weeks/uke35/exercises/uke2.txt`](../weeks/uke35/exercises/) | 5 tasks — all type-reading and type-counting | not started |
| [`tutorial/week01/`](../tutorial/week01/) | Hutton 1–2 · 19 checks | 0/19 |
| [`tutorial/week02/`](../tutorial/week02/) | Hutton 3 · 31 checks | 0/31 |
| [`tutorial/week03/`](../tutorial/week03/) | Hutton 4 · 42 checks | 0/42 |
| Hutton kap. 1–3, chapter exercises | Pensum point (C) — "antas løst" | not started |

Answers to the weekly sheets go in `weeks/ukeNN/code/`; answers to the tutorial
go in `tutorial/weekNN/Exercises.hs`.

---

## A route through it

Roughly six hours, in this order. The order matters: `uke2.txt` is pure type
reading, which is the one thing both lectures built toward and the one thing
that costs nothing to practise on paper.

**1 — `uke2.txt`, on paper, no computer (≈90 min).**
All five tasks. Task 5 is the counting one — the hint gives you b^a, and getting
`(Bool -> Bool) -> Bool` right means you have understood function types. Only
when the paper is full, check yourself in GHCi with `:t`. Every disagreement
between your paper and GHCi is a revision note.

**2 — tutorial week 2 (≈60 min).** `./tutorial/check.sh 2`. Hutton 3, the
same material as step 1 but mechanically checked. 31 checks.

**3 — `uke1.txt` (≈90 min).** Five list functions. Task 5 — `evensOdds` in one
traversal — is the interesting one; the other four are warm-up. Write them into
`weeks/uke34/code/`.

**4 — tutorial week 1 (≈45 min).** 19 checks, Hutton 1–2. Fast after step 3.

**5 — tutorial week 3 (≈90 min).** 42 checks, Hutton 4 — guards, pattern
matching, lambdas, sections. This is *today's* lecture, so it is revision and
preparation at once.

That leaves tutorial week 4 (Hutton 5, list comprehensions, 50 checks) as the
thing today's lecture opens up. It is already built and waiting.

---

## Traps his own slides point at

Worth a second look before you write anything by hand:

- **Indentation is syntax.** Definitions must start in the same column (uke 34 s.15).
- **`f a b` is not `f(a,b)`** (uke 34 s.14). Currying, not tuples — and uke 35 s.19 is the same point from the other side.
- **`- -1` is an error**, `-(-1)` is not (uke 35 s.10).
- **`last []` type-checks and then explodes** (uke 35 s.4). A total type signature does not mean a total function.
- **`1 :: Num t => t`, not `Int`** (uke 35 s.8, s.10). Numeric literals are polymorphic until something forces them.
- **`if` always needs `else`** (uke 36 s.1, and he says it in capitals).
- **First matching pattern wins** in Haskell; other FP languages forbid overlap (uke 36 s.2).

---

## How to check yourself

All three run from the repo root:

```bash
./tutorial/check.sh 2                  # your code, mechanically
./tutorial/check.sh 2 --repl           # GHCi with it loaded
.venv/bin/python src/find.py currying  # where is this covered, including the PDFs
```

The tests prove correctness and nothing else. When a week is green, that is the
moment to ask for an **idiom review** — the tests cannot tell you that your
five-line recursion wanted to be a `foldr`. Before green, don't ask, and don't
open `tutorial/solutions/`: the lecturer's first slide is explicit that using AI
to solve problems at this level means not learning them, and the groups serve no
solutions to anyone who hasn't attempted the problem first.
