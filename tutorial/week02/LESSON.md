# Week 2 — Types and Classes

**Hutton chapter 3.** Budget: ~40 min reading, ~20 min GHCi, ~90 min exercises.

Last week you learned the syntax. This week you learn the thing that actually makes
Haskell Haskell. **If you understand types, the rest of this course is downhill.**


## The short version

The whole week in ordinary language, before any of the detail.

- **A type is just the set of values something is allowed to be,** and the compiler
  checks it before your program runs at all.
- **Lists are any length but all one type; tuples are a fixed length but mixed types.**
  Two differences at once, which is why they feel similar and are not.
- **Every function really takes one argument** and hands back a function waiting for the
  next. That is why you can supply half the arguments and get something useful.
- **A lowercase letter in a type means "any type",** and because the function knows
  nothing about it, there is very little it can legally do — the type tells you a lot.
- **`Ord a =>` is a requirement, not an argument.** It says "works for any `a`, provided
  that `a` can be ordered".

---

## 1. What a type is, and when it's checked

A type is *a name for a collection of related values*. `Bool` is the collection
`{False, True}`. `Char` is the collection of all single characters.

The notation `e :: T` reads "**`e` has type `T`**". You'll see it two ways:

```haskell
False :: Bool          -- in writing, a claim about a value
ghci> :t False
False :: Bool          -- in GHCi, a question answered
```

The crucial property: **every expression's type is worked out before the program
runs**, by *type inference*. GHC reads `1 + False` and rejects it without executing
anything:

```
ghci> 1 + False
<interactive>:1:1: error: [GHC-39999]
    No instance for 'Num Bool' arising from a use of '+'
```

This is the deal Haskell offers: accept some up-front friction, and a whole species
of runtime bug — the one where a value turns out not to be what you assumed — stops
existing. In INF100 terms: the errors move from 3 a.m. in production to right now in
your editor.

---

## 2. The basic types

| Type | Values | Note |
|---|---|---|
| `Bool` | `False`, `True` | |
| `Char` | `'a'`, `'Å'`, `'\n'` | **single** quotes |
| `String` | `"abc"` | **double** quotes; a synonym for `[Char]` |
| `Int` | 64-bit integer | **wraps around** on overflow |
| `Integer` | arbitrary precision | slower, never overflows |
| `Float` | single-precision | |
| `Double` | double-precision | use this, not `Float` |

Two of these deserve a warning.

**`String` is literally `[Char]`.** Not "like" a list — it *is* one. Every list
function works on strings, which is why `reverse "haskell"` works and why
`myLast "abc"` in week 1 gave you `'c'`.

**`Int` vs `Integer` will bite you.** `Int` is fixed-width and silently wraps:

```haskell
ghci> 2^63 :: Int
-9223372036854775808        -- overflowed to negative!
ghci> 2^63 :: Integer
9223372036854775808         -- correct
```

Try both in GHCi right now. When a factorial exercise gives you a negative answer,
this is why.

---

## 3. List and tuple types — the difference that matters

```haskell
[False, True]       :: [Bool]        -- list:  any LENGTH, ONE type
(False, 'a', 1)     :: (Bool, Char, Int)  -- tuple: FIXED length, MIXED types
```

Read that table until it sticks, because it's the most common early confusion:

|  | Length | Element types |
|---|---|---|
| **List** `[a]` | any, including 0 | all the same |
| **Tuple** `(a,b,c)` | fixed by the type | may differ |

So `[1, 'a']` is a type error (mixed types in a list), while `(1, 'a')` is fine.
And `(Bool, Char)` and `(Bool, Char, Int)` are **completely different types** — you
cannot write a function that accepts either.

Nesting works as you'd expect, and the exam likes asking about it:

```haskell
['a','b','c']            :: [Char]              -- also written String
('a','b','c')            :: (Char, Char, Char)
[(False,'0'),(True,'1')] :: [(Bool, Char)]      -- list of pairs
([False,True],['0','1']) :: ([Bool], [Char])    -- pair of lists
```

The last two look almost identical and mean entirely different things. Squint at the
outermost bracket: `[...]` on the outside means list-of, `(...)` means tuple-of.

---

## 4. Function types and currying

A function type is written with an arrow:

```haskell
not     :: Bool -> Bool
even    :: Int -> Bool
length  :: [a] -> Int
```

Now the bit that confuses everyone. What is the type of a two-argument function?

```haskell
add :: Int -> Int -> Int
```

There is no comma, and that's not sloppiness. `->` is **right-associative**, so this
actually means:

```haskell
add :: Int -> (Int -> Int)
```

Read it as: *`add` takes an `Int`, and returns **a function** that takes an `Int` and
returns an `Int`.* Every Haskell function takes exactly one argument. Multi-argument
functions are a stack of nested one-argument functions. This is **currying**, after
Haskell Curry — who also lent the language its first name.

Why care? Because it means **partial application** just works:

```haskell
ghci> :t add 1
add 1 :: Int -> Int      -- supplied one argument, got a function back
ghci> let inc = add 1
ghci> inc 5
6
```

Try this in GHCi with your `add3` from exercise 2. Ask `:t add3 1` and `:t add3 1 2`
and watch the arrows disappear one at a time. This is the foundation of everything in
week 6.

Two rules to memorise, because they are the two halves of the same idea:

- **`->` associates to the right:** `a -> b -> c` means `a -> (b -> c)`
- **application associates to the left:** `f x y` means `(f x) y`

They fit together exactly. `(add 1) 2` peels one arrow off `Int -> (Int -> Int)`.

---

## 5. Polymorphic types

```haskell
length :: [a] -> Int
```

That lowercase `a` is a **type variable**: `length` works for a list of *any* type.
Type variables must be lowercase — that's how you tell them from concrete types like
`Int`.

Here's the deep part, and it's worth ten minutes of thought. Consider:

```haskell
mystery :: a -> a
```

What can `mystery` possibly do? It must work for *every* type `a`, and it knows
*nothing* about `a` — it can't add to it, compare it, or print it, because those
operations don't exist for all types. The only thing it can do is **return its
argument unchanged**. The type alone determines the implementation.

This is **parametricity**, and it's why Haskell types are so informative. Compare
with exercise 3:

```haskell
copy :: a -> (a, a)      -- must be \x -> (x, x). Nothing else typechecks.
apply :: (a -> b) -> a -> b   -- must apply the function to the argument.
```

A useful exam habit: before writing a polymorphic function, ask *"what does the type
permit me to do?"* Usually the answer is "almost nothing", and that narrows it to one
answer.

---

## 6. Type classes — what `Ord a =>` finally means

You met this in week 1's `qsort`:

```haskell
qsort :: Ord a => [a] -> [a]
```

The part before `=>` is a **class constraint**. Read the whole thing as:

> for any type `a` **that is an instance of the class `Ord`**, `qsort` maps a list of
> `a` to a list of `a`.

A **class** is a collection of types that support a common set of operations. `Ord`
is the class of types you can order; being in it means `(<)`, `(<=)`, `(>)`, `(>=)`,
`min`, `max` are available.

Why does `qsort` need it? Because the body writes `a <= x`. You may only use `<=` if
you have promised the caller that `a` supports it. Delete the constraint and GHC
says:

```
No instance for 'Ord a' arising from a use of '<='
```

**That error message is telling you to add a constraint.** You will see it a hundred
times; recognise it instantly.

### The five classes you must know

| Class | Gives you | Types outside it |
|---|---|---|
| `Eq` | `==`, `/=` | function types |
| `Ord` | `<`, `<=`, `>`, `>=`, `min`, `max` | — (`Ord` requires `Eq`) |
| `Show` | `show :: a -> String` | function types |
| `Read` | `read :: String -> a` | function types |
| `Num` | `+`, `-`, `*`, `negate`, `abs`, `signum` | **no division!** |

Two things students get wrong on exams:

**`Num` has no division.** Integer division is `div` (in `Integral`), and `/` lives
in `Fractional`. That's why week 1's `average` needed `fromIntegral` — you had to
climb from `Integral` into `Fractional`.

**Function types are in none of `Eq`, `Show`, `Read`.** Try `ghci> (+1) == (+1)` and
read the error. Deciding whether two functions are equal means checking they agree on
every possible input — undecidable in general, infinite work at best. So Haskell
simply doesn't provide it. (This is Hutton exercise 3.5, and it's a classic exam
question.)

### Multiple constraints

Put them in a tuple:

```haskell
describe :: (Show a, Ord a) => a -> a -> String
```

Read: for any `a` that is both showable and orderable.

### `read` and why it sometimes can't decide

```haskell
ghci> read "3"
<interactive>: error: Ambiguous type variable ...
```

`read :: Read a => String -> a`. The result type appears *only* in the output, so
nothing tells GHC what to parse into. Fix it by annotating:

```haskell
ghci> read "3" :: Int
3
```

Exercise 7 (`roundTrip = read . show`) works precisely because the signature's shared
`a` pins the type down.

---

## 7. Paper exercises

No computer. Write the answers out, *then* check with `:t`.

**P1.** (Hutton 3.1) Give the types of:
```haskell
['a','b','c']
('a','b','c')
[(False,'0'),(True,'1')]
([False,True],['0','1'])
[tail, init, reverse]
```
The last one is the interesting one — think about what all three have in common.

**P2.** (Hutton 3.4) Why is it not feasible in general for function types to be
instances of `Eq`? Two or three sentences.

**P3.** Fully parenthesise these types, making the right-associativity of `->`
explicit:
```haskell
a -> b -> c -> d
(a -> b) -> c
a -> (b -> c) -> d
```

**P4.** Given `f :: Int -> Bool -> Char -> String`, what are the types of
`f 1`, `f 1 True`, and `f 1 True 'x'`?

**P5.** Which of these are type errors, and why?
```haskell
[1, 2, 'a']
(1, 2, 'a')
[[1,2],[3]]
[[1,2],['a']]
```

Answers in `../solutions/week02/PAPER.md`.

---

## 8. Coding exercises

```bash
./check.sh 2
```

31 checks. Exercise 1 is a warm-up; exercises 3, 4 and 5 are where the real learning
is — for each one, **write out the type in words** before you write any code.

For exercise 6, deliberately delete the `Ord a =>` constraint at some point and read
the error GHC gives you. That error is a friend you'll meet all semester.

---

## 9. Checklist

- [ ] I can state the difference between a list and a tuple without hesitating
- [ ] I can explain why `add :: Int -> Int -> Int` has no comma
- [ ] I know that `->` is right-associative and application is left-associative
- [ ] I can say what `Ord a =>` does and why `qsort` needs it
- [ ] I know why function types aren't in `Eq`
- [ ] I know `Num` has no division
- [ ] All 31 checks pass

**Next week:** defining functions — guards, pattern matching, lambdas, and sections.
Where the code starts looking like real Haskell.
