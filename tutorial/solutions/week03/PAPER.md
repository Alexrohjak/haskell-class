# Week 3 — Paper exercise answers

## P1 — The same function three ways

```haskell
-- conditional (given)
isZero n = if n == 0 then True else False

-- guarded equations
isZero n
  | n == 0    = True
  | otherwise = False

-- pattern matching
isZero 0 = True
isZero _ = False
```

All three need `Eq a => a -> Bool` — or `(Eq a, Num a) => a -> Bool`, since `0` is
a numeric literal. The pattern version's `0` is a **literal pattern**, and literal
patterns compare with `==`, so it carries the same constraint the other two do. The
constraint never disappears; it just moves.

Now the part that matters more than the exercise. Look at the first version:

```haskell
if n == 0 then True else False
```

`n == 0` is *already* a `Bool`. The whole conditional maps `True` to `True` and
`False` to `False` — it does nothing. The honest definition is:

```haskell
isZero n = n == 0
```

`if p then True else False` is the most common piece of redundant code written by
people arriving from imperative languages, and it is worth learning to see. Same
for its mirror image `if p then False else True`, which is `not p`.

## P2 — Legal patterns

```haskell
f (x, x)     = True     -- ILLEGAL
g [x, y]     = x        -- legal
h (x:_:y)    = y        -- legal
k 0 (y:ys)   = y        -- legal
m (x + 1)    = x        -- ILLEGAL
```

**`f (x, x)`** — a variable may appear at most once in a pattern. GHC:

```
error: [GHC-10498] Conflicting definitions for 'x'
```

The legal version needs a guard, and with it an `Eq` constraint:

```haskell
f :: Eq a => (a, a) -> Bool
f (x, y) | x == y = True
```

**`g [x, y]`** — legal. `[x, y]` is a fixed-length list pattern: it matches lists of
*exactly* two elements and nothing else. Partial, so `g [1,2,3]` crashes.

**`h (x:_:y)`** — legal, and worth reading carefully. `:` is right-associative, so
this is `x : (_ : y)`: `x` is the first element, `_` the second, and **`y` is the
rest of the list** — a list, not an element. It matches anything of length ≥ 2.
Naming a tail `y` rather than `ys` is legal and misleading; don't.

**`k 0 (y:ys)`** — legal. Two arguments, a literal pattern and a cons pattern, which
is the standard shape of a recursive definition with a base case. Partial in both
arguments.

**`m (x + 1)`** — illegal in modern Haskell:

```
error: [GHC-07626] Parse error in pattern: x + 1
```

These are **n+k patterns**. They existed in Haskell 98, were removed in Haskell
2010, and Hutton's 2nd edition drops them accordingly. If you meet one in an old
book or an old exam paper, that is why. Write it with arithmetic:

```haskell
m y = y - 1
```

## P3 — Sections

```haskell
(2^) 10       ==  1024        -- 2 to the power 10
(^2) 10       ==  100         -- 10 squared
(/2) 10       ==  5.0         -- ten divided by two
(2/) 10       ==  0.2         -- two divided by ten
(10-) 10      ==  0
subtract 10 10 ==  0
```

The two `/` results are the point: `(/2)` and `(2/)` are different functions, and
only one of them is "halve". Likewise `(2^)` is powers-of-two while `(^2)` is
squares. `(-)` is the odd one out — `(-10)` would be negative ten, not a section,
which is why `subtract` exists.

Types, straight from GHCi:

```haskell
(2^) :: (Integral b, Num a) => b -> a
(^2) :: Num a => a -> a
```

`(^) :: (Num a, Integral b) => a -> b -> a` — the base is any `Num`, the exponent
must be `Integral` (you cannot raise to a fractional power with `^`). Fixing the
base leaves `b -> a` with both constraints. Fixing the *exponent* to the literal `2`
resolves `b` by defaulting it to `Integer`, so only `Num a` survives in the printed
type.

## P4 — Guard order

```haskell
grade 95  ==  'E'
```

Guards are tried top to bottom and the **first** one that is `True` wins. `95 >= 50`
is `True`, so `'E'` is returned and the `s >= 90` line is never reached. In fact it
is unreachable for *every* input: any `s` that satisfies `s >= 90` satisfies
`s >= 50` first, so the `'A'` case is dead code.

The dangerous part is what GHC says about it: **nothing**. Overlapping guards are
not an error and not a warning — the code compiles clean and returns a plausible
wrong letter. Contrast this with a type error, which the compiler catches for you.
Guard order is one of the few places in Haskell where you are entirely on your own,
which is why it makes such good exam material.

Rule of thumb: order guards from **most specific to most general**, and `otherwise`
last because it matches everything.

## P5 — `head []`

It is a **runtime** error, not a compile-time one:

```
Prelude.head: empty list
```

The type `head :: [a] -> a` promises a value of type `a` for *every* list, and `[a]`
does not distinguish empty lists from non-empty ones. So the promise is a lie for
exactly one input, and the only way to keep the program type-correct is to crash
when that input arrives. `head` is a **partial function**: defined on some of its
domain, not all of it.

GHC 9.8 and later do warn on it — this is the `-Wx-partial` warning you would see
without the flag `check.sh` passes:

```
warning: [GHC-63394] [-Wx-partial] In the use of 'head'
    "This is a partial function, it throws an error on empty lists..."
```

but a warning about the *use site* is not the same as the type catching it.

To fix it in the type, you have two honest options:

```haskell
head' :: [a] -> Maybe a          -- return Nothing for []
head' []    = Nothing
head' (x:_) = Just x
```

Move the failure into the **result** type. Now every list has an answer and the
caller is forced by the compiler to handle the empty case. You meet `Maybe` properly
in week 7.

```haskell
head'' :: NonEmpty a -> a        -- Data.List.NonEmpty
```

Or move it into the **argument** type: use a type that cannot be empty, so the bad
input can't be constructed. Nothing to handle at all, because nothing can go wrong.

The general lesson, and it is one of the biggest ideas in the language: *when a
function can fail, say so in its type.* Everything you write this semester that
pattern-matches on `(x:xs)` without an `[]` equation has this same hole in it.
