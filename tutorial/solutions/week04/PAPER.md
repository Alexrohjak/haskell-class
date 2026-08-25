# Week 4 — Paper exercise answers

## P1 — One comprehension as two (Hutton 5.7)

```haskell
[(x,y) | x <- [1,2], y <- [3,4]]
  ==
concat [[(x,y) | y <- [3,4]] | x <- [1,2]]
```

Both are `[(1,3),(1,4),(2,3),(2,4)]`.

Read the right-hand side from the inside out. The inner comprehension
`[(x,y) | y <- [3,4]]` has a *free* `x` — it is not bound inside, so it comes from
the enclosing scope. The outer comprehension binds `x` to 1 and then 2, producing

```haskell
[ [(1,3),(1,4)], [(2,3),(2,4)] ]
```

a list of lists, one per value of `x`. `concat` flattens it.

This is the exercise's real content: **a comprehension with two generators is
exactly a nested comprehension plus `concat`**. The comma is sugar. When you meet
the monad laws for lists in a later course, this identity is what they are built on;
for INF122 it is enough to see that the nesting was always there.

## P2 — Generator order

```haskell
[(x,y) | x <- [1,2], y <- [3,4]]  ==  [(1,3),(1,4),(2,3),(2,4)]
[(x,y) | y <- [1,2], x <- [3,4]]  ==  [(3,1),(4,1),(3,2),(4,2)]
```

Careful with the second one — it is not the first with the tuples flipped. The
output expression is still `(x,y)`, so `x` (drawn from `[3,4]`) stays in the first
position; what changed is which variable sweeps fastest.

They are different **lists** because a list is an ordered sequence, not a set.
`[(1,3),(1,4)]` and `[(1,4),(1,3)]` contain the same elements and are not equal:

```haskell
ghci> [(1,3),(1,4)] == [(1,4),(1,3)]
False
```

The rule to carry into the exam: the **last generator is the innermost loop** and
therefore changes fastest, exactly as with nested `for` loops.

## P3 — A dependent generator

```haskell
[(x,y) | x <- [1..3], y <- [x..3]]  ==  [(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)]
```

Six pairs, every one with `x <= y`. The second generator starts at whatever `x`
currently is, so as `x` climbs, the inner range shortens.

Replacing `[x..3]` with `[1..3]` makes the generators independent and gives all
**nine** pairs, including `(2,1)` and `(3,1)` where `x > y`. In other words, the
dependent version generates the "upper triangle" directly rather than producing
everything and filtering with a guard — the same answer for less work, which is why
Hutton bothers to introduce dependency at all.

## P4 — Why zipping against an infinite list terminates

```haskell
positions x xs = [i | (x',i) <- zip xs [0..], x == x']
```

`[0..]` is infinite, but nothing ever demands all of it. Two things combine:

1. **`zip` stops at the shorter list.** Once `xs` runs out, `zip` returns `[]` and
   asks `[0..]` for nothing further.
2. **Haskell is lazy.** `[0..]` is not a data structure that gets built and then
   consumed; it is a recipe that produces its next element only when something asks.
   `zip` asks exactly `length xs` times.

So the infinite list is only ever produced as far as the finite one demands. Writing
`[0 .. length xs - 1]` would work too, and is strictly worse: it traverses `xs` an
extra time to compute the length, and it has an off-by-one waiting to happen.

```haskell
take 3 [x*2 | x <- [1..]]  ==  [2,4,6]
```

Same principle: `take 3` demands three elements, so three are produced. This is week
9's material arriving early, and it is the single biggest behavioural difference
between Haskell and every language you already know.

## P5 — Empty lists and identity elements

```haskell
and []      ==  True
or []       ==  False
sum []      ==  0
product []  ==  1
```

Each returns the **identity element** of its operation — the value that leaves the
operation unchanged:

| Function | Operation | Identity | Why that one |
|---|---|---|---|
| `and` | `&&` | `True` | `True && x == x` |
| `or` | `\|\|` | `False` | `False \|\| x == x` |
| `sum` | `+` | `0` | `0 + x == x` |
| `product` | `*` | `1` | `1 * x == x` |

This is not an arbitrary convention chosen to avoid an error. It is the only choice
that makes the functions behave sensibly under splitting: for any lists `xs` and
`ys`, `sum (xs ++ ys) == sum xs + sum ys`. Put `ys = []` in that and you are forced
to `sum [] == 0`. The same argument fixes all four.

The practical payoff shows up in exercise 7:

```haskell
sorted xs = and [x <= y | (x,y) <- pairs xs]
```

`sorted []` and `sorted [1]` both give `True` with no special case, because `pairs`
returns `[]` and `and []` is `True`. An empty list *is* sorted and a one-element
list *is* sorted, so the identity element hands you the mathematically right answer
for free. When you meet `foldr` in week 6, this identity element is the argument you
pass it — the connection is not a coincidence.
