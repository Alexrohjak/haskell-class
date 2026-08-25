# Week 3 — Defining Functions

**Hutton chapter 4.** Budget: ~40 min reading, ~20 min GHCi, ~90 min exercises.

Weeks 1 and 2 were about how to *think* in this language. This week is about how to
*write* it. Chapter 4 introduces no new ideas — it gives you four or five new ways
to say things you can already say.

That sounds like the least important chapter in the book. It is the opposite, for
one reason: **the exam is handwritten**, and it likes asking you to rewrite the same
function using guards, or using pattern matching, or as a lambda. You are not being
tested on whether you can solve the problem — you already solved it — but on whether
you can move fluently between the forms. That is drill, and drill is this week.

---

## 1. New from old

The chapter opens with the least glamorous and most used technique in Haskell:
build new functions by gluing existing ones together.

```haskell
even :: Integral a => a -> Bool
even n = n `mod` 2 == 0

splitAt :: Int -> [a] -> ([a], [a])
splitAt n xs = (take n xs, drop n xs)
```

Note the backticks. Any function of two arguments can be written **infix** by
wrapping its name in backticks, and it usually reads better:

```haskell
mod n 2      -- prefix, legal, ugly
n `mod` 2    -- infix, same thing, how everyone writes it
```

The reverse also works: any operator becomes prefix by wrapping it in parentheses.

```haskell
ghci> (+) 3 4
7
ghci> :t (+)
(+) :: Num a => a -> a -> a
```

That trick — `(+)` to talk *about* an operator rather than use it — comes back
constantly from week 6 onward, when you start passing operators to `foldr`.

---

## 2. Conditional expressions

```haskell
abs :: Int -> Int
abs n = if n >= 0 then n else -n
```

One rule, and it catches every newcomer: **the `else` is not optional.**

```haskell
f x = if x > 0 then 1        -- ERROR: parse error
```

In an imperative language `if` is a *statement* — it does something, or doesn't.
In Haskell `if` is an **expression**: it must produce a value, and it must produce
one on every path, or the program has no meaning. `if x > 0 then 1` would have no
value when `x` is negative, and "no value" isn't a thing an expression can be.

Both branches must also have the **same type**, for the same reason: the whole
expression has one type, and GHC has to know it before anything runs.

```haskell
ghci> if True then 1 else "no"
<interactive>: error: No instance for (Num String)
```

Nested conditionals are legal but get ugly fast:

```haskell
signum n = if n < 0 then -1 else if n == 0 then 0 else 1
```

Which is exactly the motivation for the next section.

---

## 3. Guarded equations

Same function, no nesting:

```haskell
signum n
  | n < 0     = -1
  | n == 0    = 0
  | otherwise = 1
```

Read `|` as "such that". The guards are **tried top to bottom, and the first one
that is `True` wins.** Everything below it is never evaluated.

`otherwise` is not a keyword. It is a plain function defined in the standard
library as

```haskell
otherwise :: Bool
otherwise = True
```

which is why it always matches, and why it has to come last — put it first and
nothing else can ever fire. Using it is a convention, not a requirement; it exists
purely to make the final catch-all read as English.

> **The bug this creates.** Guard order is a *silent* logic error, not a type
> error. Write `grade` (exercise 8) with `s >= 50` at the top and every score above
> 50 gets an `E`. It compiles, it runs, it's wrong. Type errors are caught for you;
> ordering errors are not. Exam questions exploit this — when you are asked "what
> does this print", check the guard order first.

If no guard matches and there is no `otherwise`, you get a runtime crash:
`Non-exhaustive guards in function ...`. GHC will warn you at compile time if you
ask it to (`-Wincomplete-patterns`), and the tutorial harness has warnings on.

---

## 4. Pattern matching

The third form, and the one that makes Haskell look like Haskell. Instead of
*asking* what shape the argument has, you write one equation per shape and let the
compiler dispatch.

```haskell
not :: Bool -> Bool
not False = True
not True  = False
```

Like guards, equations are tried **top to bottom, first match wins**.

### The kinds of pattern

| Pattern | Matches | Example |
|---|---|---|
| literal | exactly that value | `f 0 = ...` |
| variable | anything, and **binds** the name | `f x = ...` |
| wildcard `_` | anything, binds nothing | `f _ = ...` |
| tuple | a tuple of that size | `f (x, y) = ...` |
| list (fixed) | a list of exactly that length | `f [x, y] = ...` |
| cons `(x:xs)` | a **non-empty** list | `f (x:xs) = ...` |

The wildcard is not laziness — it is documentation. `f _ = 0` says *I looked at
this argument and it genuinely does not matter*, which is a stronger and more
useful claim than binding a name you never use.

### The cons pattern

`(x:xs)` is the workhorse of the entire course:

```haskell
head :: [a] -> a
head (x:_) = x

tail :: [a] -> [a]
tail (_:xs) = xs
```

Three things about it:

- It matches **only non-empty** lists. `head []` crashes because no equation
  matches — this is exactly what exercise 3's `safetail` is fixing.
- The parentheses are **required**. `f x:xs = ...` parses as `(f x) : xs`, which is
  not what you meant and usually not even legal.
- The names are conventional: `x` for the head, `xs` ("exes") for the tail. Follow
  the convention; every Haskell reader on earth expects it.

Patterns nest, which is how exercise 2 works:

```haskell
third (_:_:x:_) = x       -- skip two, name the third, ignore the rest
```

### The one rule people break

A variable may appear **at most once** in a pattern. This is illegal:

```haskell
sameTwice (x, x) = True   -- ERROR: Conflicting definitions for 'x'
```

It looks like it should mean "a pair whose halves are equal", and in some languages
it does. Haskell refuses, because deciding equality requires `Eq`, and patterns are
supposed to work by shape alone, for every type. Write it with a guard instead:

```haskell
sameTwice (x, y) | x == y = True
```

Note that this version needs `Eq a =>` in its type, which is precisely the
information the pattern version was trying to hide.

---

## 5. Lambda expressions

A function with no name:

```haskell
ghci> (\x -> x + 1) 5
6
```

The backslash is meant to look like a Greek λ. Read `\x -> e` as "the function that
takes `x` and returns `e`".

You will use lambdas properly from week 6, when you start passing functions to other
functions. Right now they matter for one reason: **they make currying visible.**
These two definitions are the same definition:

```haskell
mult x y z = x * y * z
mult = \x -> \y -> \z -> x * y * z
```

The first is *sugar* for the second. Every function you have written all semester
has secretly been the second form. That is what "every function takes exactly one
argument" from week 2 actually means, spelled out — and writing it by hand once
(exercise 6) is the fastest way to make it stop being a slogan.

Lambdas also let you say something you otherwise can't: return a function without
naming it.

```haskell
add :: Int -> (Int -> Int)
add x = \y -> x + y
```

This signature *tells the truth* about what `add` does, in a way `add :: Int -> Int
-> Int` technically also does but visually hides.

---

## 6. Operator sections

Partially apply an operator by parenthesising it with one side missing:

```haskell
(1+)     ==  \x -> 1 + x
(+1)     ==  \x -> x + 1
(1/)     ==  \x -> 1 / x        -- one divided by x
(/2)     ==  \x -> x / 2        -- x divided by two
(2^)     ==  \x -> 2 ^ x        -- powers of two
(^2)     ==  \x -> x ^ 2        -- squares
```

For `+` and `*` the two sides agree, so the distinction never bites. For `-`, `/`
and `^` it absolutely does. `(2^) 10` is 1024; `(^2) 10` is 100.

Sections are how you write `map (*2) xs` in week 6 without inventing a name for
`\x -> x * 2`. Get comfortable now.

### The subtraction trap

```haskell
ghci> (-3)
-3                    -- negative three, NOT the section \x -> x - 3
```

`-` is the one operator that is also unary negation, and negation wins. The section
you wanted is written:

```haskell
subtract 3            -- \x -> x - 3
(+ (-3))              -- same thing, uglier
```

`(3-)` still works and means `\x -> 3 - x`, because there is no ambiguity on that
side. This is a favourite exam trick question.

---

## 7. `where`, briefly

You have seen it in the solutions and will want it this week:

```haskell
luhnDouble x
  | d > 9     = d - 9
  | otherwise = d
  where d = 2 * x
```

`where` attaches local definitions to **the whole equation**, so `d` is visible from
every guard — which is exactly why it beats writing `2 * x` three times. It is not
an expression and cannot be used mid-expression; that's what `let ... in ...` is
for. The distinction is worth exactly one sentence of your attention right now:
`where` per equation, `let` per expression.

---

## 8. Paper exercises

No computer. Write the answers out, *then* check with GHCi.

**P1.** Rewrite each of these in the other two forms — conditional, guards, pattern
matching — so you end up with three versions of each:

```haskell
isZero n = if n == 0 then True else False
```

**P2.** Which of these are legal patterns? For the illegal ones, say why and write
a legal version that means the same thing.

```haskell
f (x, x)     = True
g [x, y]     = x
h (x:_:y)    = y
k 0 (y:ys)   = y
m (x + 1)    = x
```

**P3.** Give the value of each section applied to `10`:

```haskell
(2^) 10      (^2) 10      (/2) 10      (2/) 10
(10-) 10     subtract 10 10
```

Then give the *type* of `(2^)` and of `(^2)`.

**P4.** This compiles and is wrong. What does `grade 95` return, and why?

```haskell
grade s
  | s >= 50   = 'E'
  | s >= 90   = 'A'
  | otherwise = 'F'
```

**P5.** `head` is defined as `head (x:_) = x` — a single equation, no `[]` case.
What happens at `head []`, at what point (compile time or run time), and what would
you have to change about the *type* of `head` to make the problem go away?

Answers in `../solutions/week03/PAPER.md`.

---

## 9. Coding exercises

```bash
./check.sh 3
```

42 checks. Several exercises deliberately ask for the same function more than once
in different styles — that repetition *is* the exercise, so don't shortcut it by
defining one in terms of another.

Two to slow down on:

- **Exercise 5** (`myAnd` with a single conditional). If you find yourself wanting
  four cases, you have missed the trick. Ask what the answer is when the first
  argument is `True` — the answer is not a constant.
- **Exercise 8** (`grade`). Write it with the guards in the wrong order first, run
  it, watch it lie to you. Then fix it. That five minutes is worth more than the
  exercise.

---

## 10. Checklist

- [ ] I know why `if` must always have an `else`
- [ ] I can convert between conditionals, guards and pattern matching in both directions
- [ ] I know guards and equations are tried top to bottom, first match wins
- [ ] I know `otherwise` is just `True`
- [ ] I know `(x:xs)` matches only non-empty lists, and needs its parentheses
- [ ] I know a variable can appear only once in a pattern, and why
- [ ] I can write `f x y = ...` as a chain of lambdas without thinking about it
- [ ] I know `(-3)` is not a section, and what to write instead
- [ ] All 42 checks pass

**Next week:** list comprehensions — generators, guards, and the Caesar cipher.
