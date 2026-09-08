# How to check your work

This repo holds two kinds of exercise, and they have completely different answers to
"is this right?". Knowing which one you're holding is most of the battle.

| What you're working on | Where it lives | How you check it |
|---|---|---|
| Tutorial exercises | `tutorial/weekNN/Exercises.hs` | `./check.sh NN` — tests ship with them |
| The lecturer's weekly sheets | `weeks/ukeNN/exercises/` | **No tests exist.** You write the checks. This doc is about that. |
| Hutton's book exercises | the book | Same as the weekly sheets |
| The oblig | `assignments/` | Read the spec twice, then the same techniques as below |

The tutorial is the only track with a feedback loop built in. That is deliberate — it
is the track designed for self-study. The other three are the ones that count, and for
those, **being able to check your own answer is part of the skill being examined.**

---

## 1. The tutorial: `check.sh`

```bash
cd tutorial
./check.sh 3              # run week 3's tests against YOUR Exercises.hs
./check.sh 3 --repl       # GHCi with your week-3 code loaded
./check.sh 3 --solution   # run them against the reference answers
```

You'll see three outcomes per check:

```
  PASS  halve [1..6]
  todo  thirdPat [1,2,3,4]          -- still 'undefined'; not a failure
  FAIL  grade 60
          expected 'D', got 'E'
```

`todo` means the stub is untouched, so you can work one exercise at a time and watch
the count climb. Exit status is 0 only when everything passes, which is what makes
`./check.sh 4 && echo done` work.

Two things it deliberately does **not** tell you:

- **Whether your answer is idiomatic.** A five-line recursion and a one-line `foldr`
  both go green. Closing that gap is what the idiom review in §5 is for.
- **Anything about the weekly sheets.** `check.sh` only knows about `tutorial/`.

If `check.sh` misbehaves rather than your code, run `.venv/bin/python src/check_setup.py`. It
runs week 1's tests against the reference solution, so a green result proves GHC, the
harness and the runner all work end to end — not merely that the binaries are on
`PATH`.

---

## 2. The weekly sheets: nothing ships with them

Open `weeks/uke34/exercises/uke1.txt` and you'll find five problems, a type signature
each, and an example or two. No tests, no `Tests.hs`, and none coming — the gruppetimar
serve no solutions either, by the lecturer's own rule.

So you build the loop yourself, in four layers, cheapest first.

### Layer 0 — write the type down and let GHC check it

The sheet gives you the signature. **Type it in first, before the body.**

```haskell
plu :: [Int] -> Int -> [Int]
plu = undefined
```

Load it (`ghci Uke1.hs`) and you have already caught a whole class of error for free.
Once the body is written, GHC checking it against the signature you declared is your
first and cheapest test. If you leave the signature off, GHC infers something —
possibly more general than you meant — and silently agrees with you.

Then interrogate it:

```
ghci> :t plu
ghci> :t plu [1,2,3]        -- partial application: what's left?
ghci> :r                    -- after every edit
```

`:t` on a partial application is the single most useful habit in this course.

### Layer 1 — the sheet's own examples are test cases

Read `uke1.txt` again with this in mind. It hands you these, verbatim:

```
plu [1,2,5] 4 = [5,6,9]
hjuster 6 "word" = "  word"
vjuster 6 "word" = "word  "
evens "abcde" = "ace"
odds "abcde" = "bd"
evensOdds xs = (evens xs, odds xs)
```

Every one of those is an assertion. Paste them into GHCi and compare, or — better —
put them in the file so they survive:

```haskell
-- in weeks/uke34/code/Uke1.hs
examples :: [Bool]
examples =
  [ plu [1,2,5] 4  == [5,6,9]
  , evens "abcde"  == "ace"
  , odds  "abcde"  == "bd"
  ]

ghci> and examples
True
```

Ten seconds of typing, and now the examples re-run every time you reload. This is the
minimum acceptable amount of checking, and it costs nothing.

### Layer 2 — QuickCheck, which is what the lecturer taught you for exactly this

His week-1 slide `weeks/uke34/slides/1QuickCheck.pdf` exists for this reason and no
other. He introduces `quickCheck` in the *first week*, before recursion, before
higher-order functions — that is not an accident of ordering.

It is already installed (QuickCheck 2.18) and works with plain `runghc`. No project
file, no cabal:

```haskell
import Test.QuickCheck
```

The idea: instead of one example, state a **property** that must hold for *every*
input, and let the machine generate hundreds of inputs looking for a counterexample.

```haskell
prop_plu_length :: [Int] -> Int -> Bool
prop_plu_length xs k = length (plu xs k) == length xs

prop_plu_zero :: [Int] -> Bool
prop_plu_zero xs = plu xs 0 == xs

prop_plu_twice :: [Int] -> Int -> Int -> Bool
prop_plu_twice xs j k = plu (plu xs j) k == plu xs (j + k)
```

```
ghci> quickCheck prop_plu_length
+++ OK, passed 100 tests.
```

Notice what those three properties are: an **invariant** (length is preserved), an
**identity** (adding zero changes nothing), and a **composition law** (adding j then k
is adding j+k). Between them they pin `plu` down far more tightly than the single
example on the sheet — and none of them is the implementation.

**And it answers the questions the sheet asks you.** Exercise 3 asks, in Norwegian,
what your `hjuster`/`vjuster` should do when the input is *longer* than the requested
width. Write the obvious property —

```haskell
prop_hjuster_len :: Int -> String -> Bool
prop_hjuster_len n s = length (hjuster n s) == n
```

— and QuickCheck will hand you the smallest input where your first attempt gets it
wrong, before you had thought to look. That is the sheet's own question, answered by a
machine, in one line.

Exercise 5 is even more direct. The sheet *states* the specification:

```
evensOdds xs = (evens xs, odds xs)
```

and then asks you to implement it in a single traversal. That sentence **is** the
property:

```haskell
prop_evensOdds_spec :: [Int] -> Bool
prop_evensOdds_spec xs = evensOdds xs == (evens xs, odds xs)
```

Write your fast one-pass version, check it against the slow obvious one, done. This
pattern — **a simple reference implementation as the oracle for a clever one** — is the
most valuable property style there is, and it will serve you again in the oblig.

### Layer 3 — the group session

Bring what you couldn't settle to gruppetimen (torsdag 10:15, fredag 10:15 or 12:15).
The rule is that you must have attempted the problem first, which the three layers
above make easy to demonstrate: turn up with your properties and the counterexample you
don't understand.

---

## 3. A file to copy

Put this in `weeks/ukeNN/code/UkeN.hs` and run it with `runghc`:

```haskell
module Main where

import Test.QuickCheck

-- ---- answers -------------------------------------------------------------

plu :: [Int] -> Int -> [Int]
plu = undefined

-- ---- examples from the sheet ---------------------------------------------

examples :: [Bool]
examples =
  [ plu [1,2,5] 4 == [5,6,9]
  ]

-- ---- properties ----------------------------------------------------------

prop_plu_length :: [Int] -> Int -> Bool
prop_plu_length xs k = length (plu xs k) == length xs

-- ---- the loop ------------------------------------------------------------

main :: IO ()
main = do
  print (and examples)
  quickCheck prop_plu_length
```

```bash
runghc weeks/uke35/code/Uke2.hs
```

Nothing to install, nothing to configure. `weeks/ukeNN/code/` is yours — the generated
`README.md` next to it is not, so don't edit that.

---

## 4. QuickCheck: the five things that will bite you

**1. A property must be monomorphic.** This is the big one.

```haskell
quickCheck (\xs -> reverse (reverse xs) == xs)
```

In a **file** that is a compile error — `Ambiguous type variable 'a0' … prevents the
constraint '(Arbitrary a0)' from being solved`. QuickCheck has to know what type to
generate, and `a` doesn't say.

In **GHCi** it is far worse, because GHCi's extended defaulting quietly picks `()`:

```
ghci> quickCheck (\xs -> reverse xs == xs)
+++ OK, passed 100 tests.
```

That property claims **every list is a palindrome**, which is plainly false —
`reverse [1,2]` is `[2,1]`. It "passed" because GHCi defaulted `a` to `()`, and every
list of `()` *is* a palindrome. A green result that means nothing is worse than a red
one.

> **Rule: always give your properties a top-level type signature**, with concrete types
> — `[Int]`, `String`, `Int`. Then a file and GHCi agree, and defaulting can't lie to
> you. This is the same discipline as Layer 0, for the same reason.

**2. Read the shrunk counterexample, it's the whole point.** When a property fails,
QuickCheck doesn't just report the random input that broke it — it repeatedly
simplifies it and reports the smallest failure it can find:

```
*** Failed! Falsified (after 4 tests and 2 shrinks):
[0,1]
```

`[0,1]`, not some 30-element list of six-digit numbers. That is usually enough to see
the bug without a debugger. Arguments are printed one per line, in order.

**3. `==>` filters, and can starve.** To restrict a property to some inputs:

```haskell
prop_nonempty :: [Int] -> Property
prop_nonempty xs = not (null xs) ==> head (evens xs) == head xs
```

Note the return type changes from `Bool` to `Property`. Generated inputs that fail the
condition are **discarded**, and you'll see `passed 100 tests; 18 discarded`. If the
condition is rare, QuickCheck gives up with `Gave up! Passed only 43 tests` — that's a
signal to generate the right shape of input directly rather than filtering for it.

**4. Passing is evidence, not proof.** 100 random inputs is a good night's sleep, not a
theorem. Well-chosen examples for the edge cases (`[]`, `0`, negative numbers,
one-element lists) still earn their place — keep both layers. And on the exam you will
be asked to reason about correctness on paper, where neither is available.

**5. `runghc` warns about `tail` and `head`.** GHC 9.10 flags them as partial:

```
warning: [GHC-63394] [-Wx-partial] In the use of 'tail'
```

It's a warning, not an error, and your code runs. The tutorial harness passes
`-Wno-x-partial` to keep its output clean; add the same flag if it bothers you:

```bash
runghc -Wno-x-partial weeks/uke35/code/Uke2.hs
```

Don't switch it off reflexively, though — on the oblig it is worth listening to.

---

## 5. The check the machine can't do

When your examples pass and your properties pass, you know the answer is **correct**.
You do not yet know it is **good**, and in this course that gap is most of the
distance between a C and an A.

That is what I'm for, and the repo README sets the boundary: ask for an **idiom review
after your tests are green**, not an answer before you've fought for it. Paste the code
and I'll tell you where a `foldr` was hiding in your recursion, where a section would
have removed a lambda, where a `where` clause would have removed a repetition.

Ask *before* you've tried and you get a correct answer you didn't earn — which is worth
exactly nothing on 2 December, when you'll have three hours, a pen, and no aids. The
lecturer's own first slide says it more bluntly:

> *NB! AI kan løse problemer på dette nivå: vil du lære så bruker du den ikke.*

---

## 6. Quick reference

```bash
# tutorial
cd tutorial && ./check.sh 4          # test one week
./check.sh 4 --repl                  # GHCi with your code loaded
./check.sh 4 --solution              # test the reference answers

# weekly sheets
runghc weeks/uke35/code/Uke2.hs      # examples + properties
ghci weeks/uke35/code/Uke2.hs        # poke at it by hand

# the toolchain itself  (no bare `python` on this machine -- use the venv)
.venv/bin/python src/check_setup.py  # is GHC + harness actually working?
.venv/bin/python src/week.py         # what week is it, what's filed
.venv/bin/python src/find.py foldr   # where is this covered, incl. the PDFs
```

In GHCi: `:r` reload · `:t expr` type of · `:i` info · `:q` quit.

### Property patterns worth memorising

| Pattern | Shape | Example |
|---|---|---|
| Invariant | some measure is preserved | `length (plu xs k) == length xs` |
| Identity | a neutral input changes nothing | `plu xs 0 == xs` |
| Inverse | one function undoes another | `encode (-n) (encode n s) == s` |
| Idempotence | doing it twice is doing it once | `sort (sort xs) == sort xs` |
| Composition | two steps equal one bigger step | `plu (plu xs j) k == plu xs (j+k)` |
| **Oracle** | a clever version agrees with an obvious one | `evensOdds xs == (evens xs, odds xs)` |

The oracle pattern is the one to reach for first whenever the sheet asks you to make
something *faster* or *single-pass*. Write the slow obvious version, keep it, and make
it the specification.
