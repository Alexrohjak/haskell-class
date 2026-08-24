# Week 1 — Paper exercise answers

## P1 — Precedence

The operator precedences that matter here: `^` (8, right-associative) binds tighter
than `*` (7), which binds tighter than `+` (6).

```
2 ^ 3 * 4      =  (2 ^ 3) * 4      =  8 * 4        =  32
2 * 3 + 4 * 5  =  (2 * 3) + (4 * 5) =  6 + 20      =  26
2 + 3 * 4 ^ 5  =  2 + (3 * (4 ^ 5)) =  2 + 3 * 1024 =  3074
```

Check yourself with `ghci> :i (^)` — GHCi prints `infixr 8 ^`, telling you both the
precedence (8) and the associativity (right). Do this whenever you're unsure; you
cannot in the exam, so build the habit of *predicting first*, then confirming.

## P2 — Three errors

```haskell
N = a 'div' length xs
   where
      a = 10
     xs = [1,2,3,4,5]
```

1. **`N` is capitalised.** Function and variable names must begin with a lowercase
   letter; capitalised identifiers are reserved for types and constructors. → `n`
2. **`'div'` uses single quotes.** Single quotes make *character literals*, so
   `'div'` isn't even a well-formed token. Infix use of a named function needs
   **backticks**. → `` `div` ``
3. **The `where` bindings are misaligned.** `a` is indented 6 spaces and `xs` only
   5. Under the layout rule, definitions in the same block must start at exactly
   the same column. → align them.

Corrected:

```haskell
n = a `div` length xs
  where
    a  = 10
    xs = [1,2,3,4,5]
```

`n` evaluates to `10 \`div\` 5` = `2`.

## P3 — `take 3 (reverse [1,2,3,4,5])`

```
reverse [1,2,3,4,5]  ==  [5,4,3,2,1]
take 3 [5,4,3,2,1]   ==  [5,4,3]
```

Answer: **`[5,4,3]`**.

Worth noticing: the parentheses are compulsory. `take 3 reverse [1,2,3,4,5]` would
parse as `((take 3 reverse) [1,2,3,4,5])` — passing the *function* `reverse` as
take's second argument — and fail to typecheck.

## P4 — Why `x = x + 1` is meaningless in Haskell

A model answer, roughly exam length:

> In Python, `=` is an assignment *command*: it overwrites the box named `x` with a
> new value, so `x = x + 1` reads the old contents, adds one, and stores the result
> back. The statement only makes sense because `x` denotes different values at
> different points in time.
>
> In Haskell, `=` introduces a *definition*: it asserts that the name on the left
> and the expression on the right denote the same value, permanently and everywhere.
> So `x = x + 1` asserts that some number equals itself plus one, which is false for
> every number. There is no time dimension and no box to overwrite, so the statement
> has no sensible reading. (Haskell will actually accept the line and then loop
> forever if you evaluate `x`, because it treats it as a recursive definition — but
> the *meaning* is still "x is a number equal to x + 1", which has no solution.)

The examiner is looking for the words **assignment vs. definition**, **mutable
state**, and ideally **referential transparency**.
