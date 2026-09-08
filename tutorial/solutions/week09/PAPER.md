# Week 9 — Paper exercise answers

## P1 — Redexes (Hutton 15.1)

```haskell
1 + 2
```
**One redex:** `1 + 2` itself. It is simultaneously the innermost and the outermost one,
so both strategies do the same thing.

```haskell
(1 + 2) * (2 + 3)
```
**Two redexes:** `1 + 2` and `2 + 3`. The multiplication is *not* yet a redex — `*`
cannot fire until both its arguments are numbers. Both redexes are innermost; the
leftmost innermost is `1 + 2`, so that is what innermost evaluation picks. Outermost also
has to pick one of these two, since there is no enclosing redex, and takes the leftmost
for the same reason. Here the strategies agree.

```haskell
fst (1 + 2, 2 + 3)
```
**Three redexes:** `1 + 2`, `2 + 3`, and `fst (1+2, 2+3)` itself. The last one *is* a
redex even though its argument is not fully evaluated, because `fst` only needs to see
the pair constructor, which is already there.

- innermost picks `1 + 2` (leftmost innermost)
- outermost picks `fst (1+2, 2+3)` (the enclosing one)

This is the interesting case, and it is what P2 makes precise.

```haskell
(\x -> 1 + 2) 0
```
**Two redexes syntactically:** the application `(\x -> 1+2) 0`, and `1 + 2` inside the
lambda body. But Haskell **does not reduce inside a lambda body** — a lambda is already a
value, and its body waits until the function is applied. So only the outer application is
reduced by either strategy, and the innermost/outermost distinction does not arise.

That convention is worth stating explicitly in an exam answer; it is the point of
Hutton's fourth example.

## P2 — `fst (1+2, 2+3)` both ways (Hutton 15.2)

**Innermost** — arguments before the function:

```
  fst (1 + 2, 2 + 3)
= fst (3, 2 + 3)
= fst (3, 5)
= 3
```
**Three steps.**

**Outermost** — the function before its arguments:

```
  fst (1 + 2, 2 + 3)
= 1 + 2
= 3
```
**Two steps.**

**What outermost avoided:** evaluating `2 + 3` at all. `fst` discards the second
component, so the work innermost did on it was wasted — it computed a value that nothing
ever looked at.

The general principle: an argument that is never used is never evaluated. In this example
it saves one addition. When the discarded component is `inf = 1 + inf`, it saves the
difference between an answer and a hang, and that is the same mechanism.

## P3 — `mult 3 4` (Hutton 15.3)

```haskell
mult = \x -> (\y -> x * y)
```

```
  mult 3 4
= (\x -> (\y -> x * y)) 3 4
= (\y -> 3 * y) 4
= 3 * 4
= 12
```

**Three reduction steps** after unfolding `mult`. Each application peels off exactly one
lambda, which is week 2's currying and week 3's lambda-desugaring made visible as
*evaluation* rather than as typing. Note that after the first step the body `\y -> 3 * y`
is a value: the `3 * y` inside is not reduced, because reduction does not happen inside a
lambda body until it is applied.

## P4 — Why `1 : ones` works and `ones ++ [1]` does not

> `1 : ones` has `(:)` as its outermost step, and `(:)` builds a value from its head
> without ever inspecting its tail. So the first element is available immediately, and
> the recursive part is only expanded if someone demands more — `take 3` demands three
> and stops.
>
> `ones ++ [1]` has `(++)` as its outermost step, and `(++)` must reduce its **left**
> argument far enough to tell whether it is `[]` or `x:xs` before it can produce anything
> at all. That left argument is `ones`, which is this same expression, so the reduction
> recurses without ever emitting a constructor and never terminates.

The general test, which is the useful thing to carry out of this question:

> **Does the outermost step produce a constructor before it recurses?**

Both definitions describe an infinite list; infinity is not the problem. `:` is
*productive* and `++` in this position is not. The same test explains why `cycle' xs = xs
++ cycle' xs` is fine — there, the left argument of `++` is the finite `xs`, so each round
emits real elements before recursing.

## P5 — `foldl (+) 0 [1..1000000]` versus `sumStrict`

> Both compute 500000500000, but `foldl` builds its accumulator lazily. Because nothing
> demands the running total until the very end, the additions are never performed as it
> goes — instead each step wraps the previous accumulator in another pending addition. By
> the time the list is exhausted, memory holds a million-deep chain of unevaluated
> additions, `((((0 + 1) + 2) + 3) + ...)`, and collapsing it can exhaust the stack.
>
> `sumStrict` uses `` acc `seq` `` to force the accumulator at every step, so it is
> always a fully evaluated number and never a chain. That runs in constant space.

**What is in memory in the first case:** a million *thunks* — unevaluated expressions,
each holding a pointer to the previous one and to the next element. Each is larger than
the `Int` it will eventually become, which is why it is worse than merely slow.

**The library function to use:** **`foldl'`**, from `Data.List`. It is `foldl` with
exactly this forcing built in, and it is the standard answer whenever a left fold over a
long list is slow or runs out of memory. `foldr` is not the fix here — it has its own
stack behaviour on long lists, and is the right choice for a different reason (it works
on infinite lists, which `foldl` never can).
