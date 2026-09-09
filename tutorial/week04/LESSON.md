# Week 4 — List Comprehensions

**Hutton chapter 5.** Budget: ~40 min reading, ~20 min GHCi, ~90 min exercises.

Last week gave you three ways to write a function. This week gives you one way to
write a *loop* — and it is not a loop.

A list comprehension builds a new list out of an old one. That is the entire idea.
Everything you would have written as a `for` loop with an accumulator in Python
becomes a single expression here, and once your eye adjusts, the comprehension
version says what the loop *meant* rather than how it was carried out.

This chapter is also where the course starts feeling productive: by the end of the
week you will have written the Caesar cipher in nine lines.


## The short version

The whole week in ordinary language, before any of the detail.

- **A comprehension reads like set notation from maths:** take each x from this list,
  keep the ones that pass this test, build this out of them.
- **With two generators the rightmost is the inner loop** — it runs all the way through
  for each single step of the one to its left.
- **`[1..0]` is the empty list, not an error,** so awkward edge cases often handle
  themselves and you get base cases for free.
- **A pattern on the left of `<-` filters as well as binds:** anything that does not fit
  the shape is skipped silently rather than crashing.
- **`zip` stops at the shorter list,** and two very common idioms depend on exactly that.

---

## 1. The notation, and where it comes from

In mathematics you write the set of squares of the numbers 1 to 5 as

> { x² | x ∈ {1..5} }

Haskell writes it almost identically:

```haskell
ghci> [x^2 | x <- [1..5]]
[1,4,9,16,25]
```

Read `|` as **"such that"** and `<-` as **"drawn from"**. So: *the list of `x^2`,
such that `x` is drawn from `[1..5]`.*

Three parts, and it is worth naming them because the chapter's vocabulary depends
on it:

```haskell
[  x^2    |    x <- [1..5]  ,  even x  ]
--  ^          ^^^^^^^^^^^^    ^^^^^^
--  output      generator       guard
```

- The **output expression** is evaluated once per result and can be anything.
- A **generator** binds a variable to each element of a list in turn.
- A **guard** is a `Bool`; results that fail it are dropped.

The comprehension is an *expression* like any other. It has a type, it can be
nested, passed to a function, or returned. It is not a statement and it does not
execute — it denotes a list.

---

## 2. Several generators

Add a comma and a second generator:

```haskell
ghci> [(x,y) | x <- [1,2], y <- [3,4]]
[(1,3),(1,4),(2,3),(2,4)]
```

**The later generator changes faster.** It behaves exactly like nested loops, with
the last generator as the innermost loop. Swap them and you get the same four pairs
in a different order — and a different list, because a list is ordered:

```haskell
ghci> [(x,y) | y <- [1,2], x <- [3,4]]
[(3,1),(4,1),(3,2),(4,2)]
```

Exercise 2 (`grid`) tests exactly this, so get the order right by thinking about
which coordinate should sweep.

### Dependent generators

A generator can mention variables bound by *earlier* generators:

```haskell
ghci> [(x,y) | x <- [1..3], y <- [x..3]]
[(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
```

`y <- [x..3]` starts wherever `x` currently is, so the pairs come out with `x <= y`
and every unordered pair appears once. This is how you avoid generating duplicates
in the first place instead of filtering them out afterwards — worth remembering for
`pyths`, though that exercise deliberately wants both orders.

---

## 3. Guards

A guard is a `Bool` sitting in the comma-separated list, and it filters:

```haskell
ghci> [x | x <- [1..20], even x, x > 10]
[12,14,16,18,20]
```

Guards may use anything bound to their left. The classic use is divisibility, which
is exercise 6:

```haskell
factors :: Int -> [Int]
factors n = [x | x <- [1..n], n `mod` x == 0]

ghci> factors 15
[1,3,5,15]
```

And from that, a two-line primality test:

```haskell
prime :: Int -> Bool
prime n = factors n == [1,n]
```

> **This is not as wasteful as it looks.** `prime 15` does *not* compute all of
> `factors 15` before deciding. `==` on lists compares left to right, so as soon as
> `3` shows up where `15` was expected the answer is `False` and the rest is never
> built. Laziness turns a naive definition into an efficient one for free. You get
> the full story in week 9 — for now, just notice that the obvious definition was
> also the right one.

---

## 4. Generators you use only for their length

Sometimes you don't want the value, only the repetition:

```haskell
replicate' n x = [x | _ <- [1..n]]
```

The output expression ignores the generator entirely. `_` is the same wildcard you
met in patterns last week, and it means the same thing: *something goes here, I am
not going to name it.* Using `_` rather than an unused `i` is not a style quibble —
GHC warns about unused bindings, and the wildcard says the omission was deliberate.

Notice also what happens when `n` is 0 or negative: `[1..0]` is `[]`, the
comprehension produces nothing, and you get `[]` without writing a base case. Empty
ranges do this everywhere in the chapter; exercise 1 gets its `n = 0` case free the
same way.

---

## 5. Patterns on the left of `<-`

A generator's variable can be a **pattern**, which lets you take pairs apart as they
arrive:

```haskell
square n = [(x,y) | (x,y) <- grid n n, x /= y]
```

Here `(x,y) <- grid n n` draws a pair from the grid and immediately binds both
halves, so the guard can compare them. Without it you would be stuck writing
`fst p /= snd p`, which is noise.

A pattern that *fails* to match is not an error — the element is silently skipped:

```haskell
ghci> [x | (1,x) <- [(1,'a'),(2,'b'),(1,'c')]]
"ac"
```

The pair `(2,'b')` doesn't match `(1,x)`, so it drops out. This is a genuinely
different behaviour from pattern matching in a function definition, where a failed
match falls through to the next equation or crashes. In a comprehension, failure
means *filter*.

---

## 6. `zip`, and the two idioms worth memorising

`zip` pairs up two lists and stops at the shorter one:

```haskell
ghci> zip "abc" [1,2,3,4]
[('a',1),('b',2),('c',3)]
```

That truncating behaviour is the whole reason the following two idioms work. Learn
both — they come up in every exam paper this course has ever set.

**Adjacent pairs: zip a list with its own tail.**

```haskell
pairs xs = zip xs (tail xs)

ghci> pairs [1,2,3,4]
[(1,2),(2,3),(3,4)]
```

The tail is one shorter, so `zip` stops exactly where it should. Now "is this list
sorted" becomes a statement about adjacent pairs, which is what sortedness actually
*means*:

```haskell
sorted xs = and [x <= y | (x,y) <- pairs xs]
```

**Indices: zip a list with `[0..]`.**

```haskell
ghci> zip "abc" [0..]
[('a',0),('b',1),('c',2)]
```

`[0..]` is **infinite**. It works because `zip` stops at the shorter list and
because Haskell never evaluates what it doesn't need — the infinite list is only
ever produced as far as the finite one demands. This is your first real encounter
with laziness doing something useful, and it is exercise 8.

Coming from Python, the habit to unlearn is `xs !! i` inside a loop over indices.
Zip the index on instead.

---

## 7. Strings are lists, so comprehensions work on them

`String` is `[Char]`, as promised in week 2, so nothing new is needed:

```haskell
ghci> [c | c <- "Haskell", c /= 'l']
"Haske"

ghci> length [c | c <- "Mississippi", c == 's']
4
```

That second one is the standard "count occurrences" idiom: generate, guard, take
the length.

---

## 8. The Caesar cipher

The chapter's worked example, and exercise 10. Shift each letter forward by `n`
places, wrapping `z` round to `a`.

The design is worth studying, because it is how a Haskell program is usually built:
four tiny functions, each doing one obvious thing, composed at the end.

```haskell
let2int :: Char -> Int      -- 'a'..'z'  ->  0..25
int2let :: Int -> Char      -- 0..25     ->  'a'..'z'
shift   :: Int -> Char -> Char
encode  :: Int -> String -> String
```

`let2int` and `int2let` exist to turn letters into numbers, because numbers can be
added and letters cannot. `ord` and `chr` (from `Data.Char`) convert between a
character and its Unicode code point; subtracting `ord 'a'` moves the alphabet to
start at 0, which is what makes `mod 26` do the wrapping.

Two things to notice when you write it:

**Non-letters must pass through untouched.** Guard on `isLower` and return the
character unchanged otherwise. Test with a space.

**You do not need a `decode`.** Haskell's `mod` returns a non-negative result for a
positive divisor, so `(0 - 3) mod 26` is `23`, not `-3`. That means `encode (-n)`
decodes, and the cipher round-trips with no new code. Confirm it in GHCi:

```haskell
ghci> (-3) `mod` 26
23
```

> **Stretch, not required.** Hutton goes on to *crack* the cipher by comparing
> letter frequencies against known English frequencies with a chi-square statistic
> (`freqs`, `chisqr`, `rotate`, `crack`). It is the best-value hour in the chapter
> and it is not in this week's tests. Do it if you have time; exercise 5.10 —
> extending the cipher to uppercase — is a smaller and equally good stretch.

---

## 9. Paper exercises

No computer. Write the answers out, *then* check in GHCi.

**P1.** (Hutton 5.7) Show how

```haskell
[(x,y) | x <- [1,2], y <- [3,4]]
```

can be re-expressed using **two** comprehensions, one nested inside the other, with
single generators. You will need `concat`.

**P2.** Give the exact value, in order, of each:

```haskell
[(x,y) | x <- [1,2], y <- [3,4]]
[(x,y) | y <- [1,2], x <- [3,4]]
```

Why are they different lists, given that they contain the same pairs?

**P3.** Give the value of

```haskell
[(x,y) | x <- [1..3], y <- [x..3]]
```

and say in one sentence what changes if `[x..3]` is replaced by `[1..3]`.

**P4.** `positions` zips against the infinite list `[0..]`. Explain in two or three
sentences why this terminates. What is the value of `take 3 [x*2 | x <- [1..]]`?

**P5.** These all return a value rather than an error. Give each value and say what
the four have in common:

```haskell
and []
or []
sum []
product []
```

Answers in `../solutions/week04/PAPER.md`.

---

## 10. Coding exercises

```bash
./check.sh 4
```

50 checks. Every one of them has a one-line answer — if a definition is growing a
`where` clause and three cases, you have wandered into week 5's material early.

Three worth slowing down on:

- **Exercise 3** (`square`) must reuse `grid`. Building it from scratch passes the
  tests and misses the point: comprehensions compose, and a comprehension drawing
  from another comprehension is completely ordinary.
- **Exercise 7** (`pairs`, `sorted`). Write `pairs` first and check it in GHCi
  before touching `sorted`. Then work out for yourself why `sorted []` is `True`
  without you handling the empty case — that's P5.
- **Exercise 10** (Caesar). Build it bottom-up and test each piece in GHCi as you
  go: `let2int 'a'`, then `int2let 0`, then `shift 3 'z'`, then `encode`. Do not
  write all four and then debug.

---

## 11. Checklist

- [ ] I can read `[e | x <- xs, p]` aloud as "the list of e such that x drawn from xs, such that p"
- [ ] I know the last generator is the inner loop, and can predict the output order
- [ ] I can use a variable from one generator in a later generator
- [ ] I know `[1..0]` is empty, and that this gives me base cases for free
- [ ] I can pattern-match on the left of `<-`, and I know a failed match filters
- [ ] I know `zip` stops at the shorter list, and both idioms that depend on it
- [ ] I can zip against `[0..]` to get indices, and explain why it terminates
- [ ] I wrote the Caesar cipher and know why `encode (-n)` decodes
- [ ] All 50 checks pass

**Next week:** recursion — the first of the three named learning outcomes, and the
chapter where you stop borrowing the standard library and start building it.
