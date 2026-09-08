# Week 5 — Paper exercise answers

## P1 — Expansions

```
  fac 4
= 4 * fac 3
= 4 * (3 * fac 2)
= 4 * (3 * (2 * fac 1))
= 4 * (3 * (2 * (1 * fac 0)))
= 4 * (3 * (2 * (1 * 1)))
= 24
```

```
  sumdown 3
= 3 + sumdown 2
= 3 + (2 + sumdown 1)
= 3 + (2 + (1 + sumdown 0))
= 3 + (2 + (1 + 0))
= 6
```

Note the shape: the recursion goes all the way *down* to the base case before any
arithmetic happens, then the answers come back *up*. Nothing is added until `sumdown 0`
returns. That growing left-hand column of pending multiplications is a real thing in
memory — it is why a very deep non-tail recursion can exhaust the stack, and it is what
week 9's lazy evaluation chapter will let you talk about properly.

## P2 — `2 ^ 3` (Hutton 6.5)

```
  2 ^ 3
= 2 * (2 ^ 2)
= 2 * (2 * (2 ^ 1))
= 2 * (2 * (2 * (2 ^ 0)))
= 2 * (2 * (2 * 1))
= 8
```

**Multiplications: n.** One per recursive step, and there are `n` steps before the base
case `x ^ 0 = 1` is reached. The base case itself performs none — it returns a literal.

Worth adding for full marks: this is the *naive* definition. Repeated squaring
(`x^n = (x^(n `div` 2))^2` for even `n`) gets the same answer in `log n`
multiplications, which is what a library implementation does.

## P3 — Why `and' [] = True` and `product' [] = 1`

> Each base case is the **identity element** of the operation used in the recursive
> case — `True` for `&&`, `1` for `*` — so it contributes nothing to the result of a
> non-empty list. Choosing anything else breaks the law that splitting a list and
> combining the parts gives the same answer: with `and' [] = False`, the identity
> `and' (xs ++ ys) == and' xs && and' ys` would fail for `ys = []`, and `and' [True]`
> would come out `False`. With `product' [] = 0`, every product would be 0, since the
> final step always multiplies by the base case.

The English agrees with the algebra: "all of no conditions hold" is vacuously true, and
"the product of no numbers" is the number that changes nothing when you multiply by it.

## P4 — The five-step recipe for `elem'`

**Step 1 — the type.**

```haskell
elem' :: Eq a => a -> [a] -> Bool
```

`Eq a` because we must compare, and week 2 told us we may only use `==` if we have
promised the caller we would.

**Step 2 — enumerate the cases.** The second argument is a list, so two shapes. The
first argument is an arbitrary `a` with no structure to match on, so it stays a
variable.

```haskell
elem' x []     = ...
elem' x (y:ys) = ...
```

**Step 3 — the base case.** Nothing is an element of the empty list:

```haskell
elem' x []     = False
```

**Step 4 — the recursive case.** Either it is the head, or it is somewhere in the tail:

```haskell
elem' x (y:ys) = x == y || elem' x ys
```

**Step 5 — generalise and simplify.** `x` is unused in the base case, so `_`:

```haskell
elem' :: Eq a => a -> [a] -> Bool
elem' _ []     = False
elem' x (y:ys) = x == y || elem' x ys
```

Also worth noticing at step 5: because `||` is lazy in its second argument, this stops
at the first match rather than scanning the whole list. You get the early exit for
free, without writing it.

## P5 — Which terminate?

```haskell
f 0 = 0
f n = f (n - 1)
```

**No.** Terminates for `n >= 0`, runs forever for any negative `n` — it counts away
from the base case. Counterexample: `f (-1)`.

```haskell
g 0 = 0
g n = g (n - 2)
```

**No**, and worse than `f`. It fails for every negative input *and* for every odd
positive one, because stepping by 2 from an odd number skips 0 entirely. Counterexample:
`g 3`, which goes 3, 1, −1, −3, …

```haskell
h n | n <= 0    = 0
    | otherwise = h (n - 1)
```

**Yes**, for every `Int`. The guard `n <= 0` catches everything at or below zero, so the
base case is reachable from both directions. This is exercise 1's fix, and the
difference between it and `f` is the whole lesson: a base case is only useful if every
input can *reach* it.

```haskell
k n = k n
```

**No**, for any input. There is no base case and no progress — the argument never
changes. It is the purest form of the bug.

The general test to apply on the exam: find a quantity that **strictly decreases** on
every recursive call and is **bounded below** by the base case. `h` has one (`n`, floored
at 0). `f` and `g` have a decreasing quantity with no floor. `k` has none at all.
