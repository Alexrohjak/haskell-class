# Week 9 — Lazy Evaluation

**Hutton chapter 15.** Budget: ~45 min reading, ~25 min GHCi, ~95 min exercises.

The last chapter of pensum, and the one that retroactively explains five weeks of
things you have been using without knowing why they worked:

- week 4's `zip xs [0..]`, which pairs a list with an infinite one and terminates
- week 6's `iterateU`, which produces a list that never ends
- `take 5 [1..]`, which you have typed a dozen times

None of these should work. This chapter is why they do — and, just as importantly, when
laziness turns round and costs you.

---

## 1. Redexes, and the freedom to choose

An expression may contain several **reducible expressions** — *redexes* — and you can
work on them in any order:

```haskell
(1 + 2) * (2 + 3)
```

Two redexes here, `1+2` and `2+3`. Two obvious strategies:

- **Innermost**: reduce the leftmost innermost redex first. Arguments are evaluated
  before the function that uses them — "call by value", what Java and Python do.
- **Outermost**: reduce the leftmost outermost redex first. Functions are applied
  before their arguments are evaluated — "call by name".

For that expression both give 9. The question the chapter answers is whether the choice
*ever* matters. It does, in three ways: **termination**, **number of steps**, and
**what you can express at all**.

---

## 2. Termination is not a matter of taste

```haskell
inf :: Int
inf = 1 + inf
```

Now evaluate `fst (0, inf)`.

**Innermost** must evaluate both components of the pair before applying `fst`. So it
reduces `inf` to `1 + inf` to `1 + (1 + inf)` and never stops.

**Outermost** applies `fst` first, which selects the `0` and discards the second
component unexamined. Answer: `0`, in one step.

That is not an optimisation. It is the difference between a program that works and one
that hangs. And it generalises to a theorem worth knowing:

> If **any** evaluation strategy terminates, outermost evaluation terminates, and gives
> the same value.

Innermost has no such guarantee. This is why `&&`, `||` and `if` can short-circuit in
Haskell without being special syntax — they are ordinary functions, and outermost
evaluation gives them their laziness for free. It is also why exercise 5's `anyInf`
works on an infinite list.

---

## 3. Sharing, and why outermost isn't automatically slower

Naive outermost evaluation has a real cost. Consider `square (1+2)` with
`square n = n * n`:

```
  square (1+2)
= (1+2) * (1+2)        -- the argument got DUPLICATED
= 3 * (1+2)
= 3 * 3
= 9
```

`1+2` is evaluated twice. Innermost would have done it once. If that were the whole
story, laziness would be a bad trade.

The fix is **sharing**: GHC does not copy the argument, it keeps a *pointer* to a single
shared expression. Reduce it once and both uses see the result.

```
  square (1+2)          -- one arrow pointing at (1+2), used twice
= 3 * 3                 -- reduced once, shared
= 9
```

This is called **graph reduction**, and it gives the definition to remember:

> **Lazy evaluation = outermost evaluation + sharing.**

Which delivers the guarantee that makes it practical: lazy evaluation never takes more
steps than innermost, and sometimes takes infinitely fewer.

One consequence you should be able to state: **an argument is evaluated at most once,
and only if it is actually needed.** Not zero times, not twice.

---

## 4. Infinite structures

This is where the chapter stops being about efficiency and starts being about
expressiveness.

```haskell
ones :: [Int]
ones = 1 : ones
```

No base case. Under innermost evaluation this is a hang. Under lazy evaluation:

```
  take 3 ones
= take 3 (1 : ones)
= 1 : take 2 ones
= 1 : 1 : take 1 ones
= 1 : 1 : 1 : take 0 ones
= [1,1,1]
```

**Nothing infinite is ever built.** `(:)` hands back its head without inspecting its
tail, so exactly as much of `ones` exists as somebody demanded. The right slogan is not
"Haskell handles infinite lists" but:

> Only ever *as much as is needed* is computed.

Now compare the definition that does hang, and which exercise 1 asks you to think about:

```haskell
ones = ones ++ [1]      -- HANGS
```

`++` must reduce its **left** argument far enough to know whether it is `[]` or `x:xs`
before it can produce anything at all. That left argument is `ones`, which is this same
expression. No first element can ever be produced. The difference between the two is not
"infinity" — both are infinite — it is whether the outermost step **produces something**
before recursing. `:` does; `++` does not.

That test is the one to carry: **does the outermost constructor appear before the
recursive call?**

### `fibs`, the one worth staring at

```haskell
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
```

Defined in terms of itself *and its own tail*, and not circular. By the time anything
asks for element n, elements n−1 and n−2 have already been produced and shared, so every
demand is satisfiable when it arrives. Sharing is doing essential work here: without it
each element would be recomputed and the whole thing would be exponential.

---

## 5. Modular programming: generate and select

Hughes' argument, and the practical reason to care. Laziness lets you write a
**generator** that knows nothing about termination, and a **selector** that knows nothing
about generation, then glue them together:

```haskell
primes = sieve [2..]
  where sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

primesBelow n = takeWhile (< n) primes
take 8 primes
```

`primes` has no idea how many primes anyone wants. `primesBelow` has no idea how primes
are made. In a strict language these must be fused into one function with the stopping
condition threaded through the generator — which is why sieve implementations in Python
take a limit as an argument.

**Exercise 4's trap, and it is the exercise:** use `takeWhile`, not `filter`.
`takeWhile (< n)` stops at the first failure. `filter (< n)` must keep scanning, because
it cannot know that no later element will match — on an infinite list it never returns.
Same predicate, one terminates.

Exercise 7 makes the same point one dimension up: `repeatT` builds an infinite tree,
`takeT` cuts it to size, and `replicateT = takeT n . repeatT` composes them. Neither half
knows about the other.

---

## 6. When laziness costs you: `seq`

Laziness is not free, and this is the part that shows up in real code and on the oblig.

```haskell
foldl (+) 0 [1..1000000]
```

`foldl` builds its accumulator lazily, so before adding anything it constructs

```
((((0 + 1) + 2) + 3) + ... + 1000000)
```

a million-deep chain of unevaluated additions — *thunks* — held in memory. Then it
collapses the lot. It is correct, and it can exhaust the stack.

`seq` forces evaluation:

```haskell
seq :: a -> b -> b
```

`x `seq` y` evaluates `x` to weak head normal form, then returns `y`. Exercise 6:

```haskell
sumStrict = go 0
  where go acc []     = acc
        go acc (x:xs) = acc `seq` go (acc + x) xs
```

Now the accumulator is a number at every step, never a growing chain. Constant space.

The library versions are `($!)` for strict application and **`foldl'`** from `Data.List`
— which is what you should actually reach for, and which is worth remembering by name:
if a `foldl` over a long list is slow or blows up, `foldl'` is usually the answer.

Note what the tests *cannot* see here: `sumStrict [1..100000]` and `sum [1..100000]` give
the same number. The difference is space, and no `check` will ever catch it. Try both on
`[1..10000000]` in the REPL if you want to feel it.

> **Weak head normal form** means "reduced far enough to see the outermost constructor".
> `seq` on a list forces it to `[]` or `x:xs` — it does **not** force the elements. That
> catches people who expect `seq` to deep-evaluate.

---

## 7. Paper exercises

No computer.

**P1.** (Hutton 15.1) Identify the redexes in each, and say which the innermost and
outermost strategies would reduce first:

```haskell
1 + 2
(1 + 2) * (2 + 3)
fst (1 + 2, 2 + 3)
(\x -> 1 + 2) 0
```

**P2.** (Hutton 15.2) Show the full reduction of `fst (1+2, 2+3)` under innermost and
under outermost evaluation, one step per line. Count the steps in each and say what
outermost avoided doing.

**P3.** (Hutton 15.3) Given `mult = \x -> (\y -> x * y)`, show how `mult 3 4` is
evaluated, one step per line.

**P4.** `ones = 1 : ones` works and `ones = ones ++ [1]` hangs. Explain the difference in
two or three sentences, in terms of what each outermost step produces.

**P5.** Explain why `foldl (+) 0 [1..1000000]` can exhaust memory when `sumStrict` does
not, given that both compute the same number. What exactly is in memory in the first
case? Name the library function you would use instead.

Answers in `../solutions/week09/PAPER.md`.

---

## 8. Coding exercises

```bash
./check.sh 9              # your code
./check.sh 9 --repl       # GHCi with your code loaded
```

**56 checks.** Every test truncates its infinite structure, so a correct answer always
terminates.

> **If it hangs rather than fails**, Ctrl-C and find the definition whose outermost step
> recurses *before* producing a constructor. That is the `ones ++ [1]` bug, and it is the
> only way to hang this week.

Order: 1 first, and write `ones` before anything else — everything after it is a
variation. 2 and 3 are short once `ones` has landed; give `fibs` the full minute it
deserves. 4 is the highlight of the chapter. 5 is quick and makes the short-circuit point
concrete. 6 is the counterweight — the week's only exercise where laziness is the
problem. 7 lifts it all to trees.

When all 56 are green, ask for an **idiom review**. Ask specifically whether any of your
definitions accidentally force more than they need — that is the reviewable property this
week, and it is invisible to the tests.

---

## 9. Checklist

- [ ] I can define a redex and describe innermost and outermost evaluation
- [ ] I can give an expression where innermost hangs and outermost terminates
- [ ] I can state the theorem: if any strategy terminates, outermost does
- [ ] I can explain sharing and why outermost alone would be wasteful
- [ ] I can say "lazy = outermost + sharing" and mean it
- [ ] I can explain why `ones = 1 : ones` works and `ones = ones ++ [1]` does not
- [ ] I can explain why `fibs` is not circular
- [ ] I know why `primesBelow` needs `takeWhile` and not `filter`
- [ ] I can say what `seq` does, and what weak head normal form means
- [ ] I know `foldl'` exists and when to reach for it
- [ ] All 56 checks pass

---

**That is the whole of Hutton in pensum: chapters 1–8, 10 and 15.**

What is left is the two topics that appear in **no chapter of the book** — *enkel
parsing* and *typeinferens* — which the lecturer flags twice with "kun
forelesningsnotater!". His notes arrive in uke 42–44, and tutorial weeks 10 and 11 can
only be written once they do. Until then, `weeks/uke42/` onward is the place to watch,
and `python src/find.py parsing` will search inside the PDFs the moment they land.
