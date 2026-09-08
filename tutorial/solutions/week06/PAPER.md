# Week 6 — Paper exercise answers

## P1 — Comprehension as `map` and `filter` (Hutton 7.1)

```haskell
[f x | x <- xs, p x]  ==  map f (filter p xs)
```

**`filter` must come first, and the order is not a style choice — the other order does
not typecheck.**

Look at the types. Given `f :: a -> b` and `p :: a -> Bool`:

- `filter p xs` keeps some of the `a`s, giving `[a]`. `map f` then turns those into
  `[b]`. Types line up.
- `filter p (map f xs)` would hand `p` a `b`, but `p` demands an `a`. GHC rejects it
  unless `a` and `b` happen to be the same type — and even then it is **wrong**,
  because it tests the transformed values rather than the originals.

Concretely, `[x*2 | x <- [1,2,3], odd x]` is `[2,6]`. Filtering after doubling would
test `2, 4, 6` for oddness and give `[]`. Same two functions, different answer.

The general lesson: in a comprehension the guard sees the **generator variable**, not
the output expression, so `filter` sits closest to the source list.

## P2 — `foldr` as constructor replacement

`foldr f v` replaces every `:` with `f` and the final `[]` with `v`.

```haskell
foldr (:) []                                   -- id (on lists)
foldr (\x xs -> xs ++ [x]) []                  -- reverse
foldr (\_ n -> 1 + n) 0                        -- length
foldr (\x xs -> if even x then x : xs else xs) []   -- filter even
```

Taking them in turn:

**`foldr (:) []`** replaces the constructors *with themselves*, so it rebuilds the
list unchanged. This is the identity, and it is the single clearest demonstration that
`foldr` is about reconstruction rather than accumulation.

**`foldr (\x xs -> xs ++ [x]) []`** puts each element after everything that came from
the tail, so the list comes out backwards. Correct, and quadratic — `++` traverses its
left argument every time, so this walks an ever-growing list on each step.

**`foldr (\_ n -> 1 + n) 0`** ignores the element (hence `_`) and counts the `:`
constructors. That is `length`, and the `_` is the giveaway — a fold whose combining
function discards the element can only be measuring the *shape*.

**`foldr (\x xs -> if even x then x : xs else xs) []`** rebuilds with `:` when the
element passes, and skips it otherwise. That is `filter even`, and it is exactly the
`filterF` of exercise 4.

## P3 — `foldr` versus `foldl` with a non-associative operator

```
  foldr (-) 0 [1,2,3]
= 1 - (2 - (3 - 0))
= 1 - (2 - 3)
= 1 - (-1)
= 2
```

```
  foldl (-) 0 [1,2,3]
= ((0 - 1) - 2) - 3
= (-1 - 2) - 3
= -3 - 3
= -6
```

**The property `(-)` lacks is associativity** — `(a - b) - c` is not `a - (b - c)`.
Addition has it, so `foldr (+) 0` and `foldl (+) 0` agree; subtraction does not, so the
bracketing that `foldr` and `foldl` impose gives different answers.

The full condition for the two folds to agree on every list is that the operator is
associative **and** the starting value is its identity. `(+)` with `0` and `(*)` with
`1` qualify; `(-)` with `0` fails the first test, and `(++)` with `"x"` would fail the
second.

Notice the starting value also lands in a different place: `foldr` puts it at the
far **right** end of the expression, `foldl` at the far **left**.

## P4 — Types

```haskell
map map                  :: [a -> b] -> [[a] -> [b]]
twice twice              :: (a -> a) -> a -> a
(.) . (.)                :: (b -> c) -> (a1 -> a2 -> b) -> a1 -> a2 -> c
map (map (+1))           :: Num b => [[b]] -> [[b]]
filter even . map (*2)   :: Integral a => [a] -> [a]
```

**`map map`** — the outer `map` expects a function `a -> b`, and is handed `map`
itself, whose type is `(x -> y) -> ([x] -> [y])`. So `a` is `x -> y` and `b` is
`[x] -> [y]`. The result maps a list of functions to a list of *lifted* functions.

**`twice twice`** — `twice` needs a first argument of type `t -> t`. Supplying `twice`
means `t` is `a -> a`, giving `(a -> a) -> (a -> a)`, which is `(a -> a) -> a -> a` once
you drop the redundant parentheses. It applies its function four times.

**`(.) . (.)`** — the classic. It composes a one-argument function with a *two*-argument
one: the result takes two arguments, feeds them to the second function, then applies the
first to the answer. Don't memorise it; do notice that composing composition generalises
`(.)` to more arguments.

**`filter even . map (*2)`** — `Integral` rather than `Num`, because `even` is
`Integral a => a -> Bool` and that is the stronger constraint. GHC always reports the
most demanding one. (This composition is also, of course, `id` on the doubled list —
everything `map (*2)` produces is even — which is a nice illustration of why P1's
ordering matters.)

## P5 — Point-free

```haskell
f xs = sum (map (*2) xs)        -->  f = sum . map (*2)
g xs = length (filter odd xs)   -->  g = length . filter odd
h x  = not (even x)             -->  h = not . even
```

The mechanical rule: when a definition ends in `... (g x)` and the argument `x` appears
**exactly once, at the very end**, you can drop it from both sides and join what remains
with `.`. That is η-reduction, and it is why these three collapse so neatly.

It stops being mechanical when the argument appears twice or in the middle —
`k xs = zip xs (tail xs)` has no comparably readable point-free form, and forcing one
produces something nobody can read. `h` is also just `odd`, which is a reminder that the
best simplification is often to find the function that already exists.
