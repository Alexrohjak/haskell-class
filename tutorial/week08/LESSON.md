# Week 8 — Interactive Programming

**Hutton chapter 10.** Budget: ~40 min reading, ~25 min GHCi, ~95 min exercises.

Seven weeks ago you were told a Haskell program is an expression, that `=` is a
definition, and that `sum [1,2,3]` is *always* 6. Reading the keyboard breaks all of
that: `getLine` gives a different answer every time you run it.

This chapter is how the language has it both ways. The resolution is genuinely elegant,
and it is a favourite exam question precisely because it is the place where the
paradigm has to justify itself.

---

## 1. The problem, stated properly

A pure function's result depends **only** on its arguments. That is what makes
`sum [1,2,3]` replaceable by `6` anywhere it appears — referential transparency, from
week 1.

Now consider a hypothetical `readKey :: Char`. It takes no arguments, so it must always
be the same `Char`. Useless. Give it a dummy argument, `readKey :: () -> Char`, and it
is still a function from one argument to one result, so it must still always give the
same answer. The type system will happily let you replace both calls in
`(readKey (), readKey ())` with a single shared value, and any optimiser is entitled to
do so.

**Side effects and referential transparency cannot coexist in the same function type.**
That is not a Haskell quirk; it is arithmetic.

---

## 2. The resolution: an action is a value

```haskell
IO a    -- an ACTION which, when performed, may do input/output
        -- and then produces a value of type a
```

The trick is one step of indirection. `getLine` is not a function that reads a line. It
is a **value** that *describes* reading a line:

```haskell
getChar :: IO Char
getLine :: IO String
putStr  :: String -> IO ()
```

And `getLine` really is always the same value — the same description — every time. It is
*performing* it that produces different strings, and performing only happens when the
action is reached by `main`. Purity survives, because building a description of an
effect is not an effect.

An analogy that holds up: `getLine` is a **recipe**, not a **cake**. Two copies of the
same recipe are equal. Two cakes baked from it are not the same cake. Haskell lets you
pass recipes around freely and is very strict about who is allowed to bake.

### `()`, the unit type

```haskell
putChar :: Char -> IO ()
```

`()` is a type with exactly one value, also written `()`. `IO ()` therefore means "an
action whose result carries no information" — you run it for its **effect**. It is the
Haskell equivalent of `void`, except it is an ordinary type with nothing special about
it.

### The boundary is visible in the type

This is the part worth taking to the exam:

| Type | Can it do IO? |
|---|---|
| `String -> String` | **No.** Guaranteed, by the compiler. |
| `String -> IO String` | Yes |
| `IO (String -> String)` | It does IO to *produce* a function; the function itself is pure |

A function whose type has no `IO` in it **cannot** read a file, print, or read the
clock. Not "shouldn't" — *cannot*. That guarantee is worth a lot, and no mainstream
imperative language can make it.

---

## 3. `do` notation

Sequencing actions:

```haskell
greet :: IO ()
greet = do
  putStr "Name: "
  name <- getLine
  putStrLn ("hei, " ++ name)
```

Three rules and you have it:

**`<-` is not assignment.** It *performs* the action on the right and names its result.
`name <- getLine` means "run `getLine`, call the resulting String `name`". Compare
`let name = getLine`, which names the *action itself* and reads nothing.

**Layout matters.** Every statement in a `do` block starts in the same column.

**The last statement's type is the block's type.** `greet` ends with a `putStrLn`, so
`greet :: IO ()`.

You can mix in pure bindings with `let` (no `in`, inside a `do`):

```haskell
  let shouted = map toUpper name
```

Use `<-` for actions, `let` for pure values. Getting these two straight is most of what
`do` notation is.

---

## 4. `return` does not return

The single most misleading name in the language.

```haskell
return :: a -> IO a
```

It **does not exit the function**, does not jump anywhere, and does not end the block.
It takes a plain value and wraps it into an action that does no IO at all and yields
that value. It is the identity element of the IO world, in the same sense that `0` is
for `(+)`.

```haskell
addThem :: IO Int
addThem = do
  a <- readLn
  b <- readLn
  return (a + b)          -- a + b is a plain Int; we need an IO Int
```

The `return` is there because the block must end with something of type `IO Int`, and
`a + b` is an `Int`. Nothing more.

Two consequences that catch people:

```haskell
do
  return 5                -- computes an action, DISCARDS it, carries on
  putStrLn "still here"   -- this runs
```

`return 5` in the middle of a block does precisely nothing. And this is a type error,
not a shortcut:

```haskell
countChars :: String -> IO Int
countChars s = length s        -- ERROR: Int is not IO Int
```

Exercise 1's `sequenceIO` is where this lands. Its base case is `return []`, **not**
`[]`, because every branch must produce an *action*.

---

## 5. Derived primitives, and `mapM_`

Almost everything in `System.IO` is built from `getChar`, `putChar` and `return`:

```haskell
putStr' :: String -> IO ()
putStr' []     = return ()
putStr' (c:cs) = do putChar c
                    putStr' cs
```

Recognise the shape — it is week 5's list recursion, with `return ()` as the base case
because that is the identity for "do nothing". Which means it is also a fold, and the
library has the fold already:

```haskell
putStr' = mapM_ putChar
```

`mapM_` runs an action for each element and throws the results away; `mapM` (and
`sequence`) keep them. Exercise 2 asks for both versions so you can see they are the
same function.

---

## 6. The design rule that actually matters

Here is the practical lesson of the chapter, and it is why this week's exercises look
the way they do.

> **Put the thinking in pure functions. Leave `IO` as a thin shell that reads, calls
> them, and prints.**

Hutton's Nim prints the board as it walks it. That is shorter, and it means the display
logic can only be checked by a human staring at a terminal. Exercise 4 asks you to build
the **string** instead, and let the caller print it. Exercise 5 goes further: `playMoves`
runs an entire game of Nim as a pure function.

The payoff is immediate and you can see it in the test file: this week has **76
automatic checks** over interactive programs, which is only possible because almost none
of the code is interactive. The IO shell that remains is four lines and obviously
correct.

This is also the honest answer to "why is the harness not testing my `putStrLn'`?" —
because printing to a screen has no value to compare. The response is not a better test
harness. It is less code inside `IO`.

Take this to the **oblig**. A cabal project you can only test by running it is a project
you will debug by guessing.

---

## 7. Paper exercises

No computer.

**P1.** For each type, say whether a value of that type can perform input/output, and in
one clause why:

```haskell
Int -> Int
Int -> IO Int
IO (Int -> Int)
[IO Int]
IO ()
```

**P2.** Explain the difference between these two, and say what `x` is in each:

```haskell
do x <- getLine
   putStrLn x

do let x = getLine
   putStrLn x
```

One of them is a type error. Which, and what does GHC complain about?

**P3.** Why is `return` a badly chosen name? Give a two-sentence answer, and state what
`return 5` does when it appears in the *middle* of a `do` block.

**P4.** Trace `playMoves [5,4,3,2,1] [(1,2),(9,1),(2,4)]` by hand, one move per line,
saying what happens to each. Rows are numbered from 1.

**P5.** (Essay drill — the emneplan asks you to *discuss* the paradigms.) In about 150
words, explain how Haskell reconciles referential transparency with reading the
keyboard, and what a `String -> String` type guarantees that the equivalent Java
signature does not.

Answers in `../solutions/week08/PAPER.md`.

---

## 8. Coding exercises

```bash
./check.sh 8              # your code
./check.sh 8 --repl       # GHCi with your code loaded
```

**76 checks.** Exercise 2 has **no automatic checks** — it prints, so run it in the REPL
and look at the screen. Everything else is pure and tested hard.

Order: 1 first, and read §4 before you start it — `sequenceIO`'s base case is the whole
exercise. 2 is quick, and worth doing both ways. 3 to 5 build Nim from rules to whole
game; do them in order and note that by exercise 5 you have a complete playable game
with no `IO` in it anywhere. 6 and 7 are short. 8 is Life — do `wrap` first and test it
at all four edges before anything else, because every later function depends on it.

The off-by-one to decide once, in exercise 3: **rows are numbered from 1**, lists index
from 0. Pick where the `- 1` lives and put it in exactly one place.

When all 76 are green, ask for an **idiom review**, and specifically ask whether any of
your `IO` actions still contain logic that could have been pulled out into a pure
function. That is the reviewable thing this week.

---

## 9. Checklist

- [ ] I can explain why `readKey :: () -> Char` cannot work
- [ ] I know `IO a` is a description of an action, not the act of doing it
- [ ] I can say what `()` is and why `IO ()` means "run me for the effect"
- [ ] I know `String -> String` *cannot* do IO, and why that is a guarantee
- [ ] I know `<-` performs an action and `let` binds a pure value
- [ ] I can explain why `return` is misnamed and what it actually does
- [ ] I know why `sequenceIO`'s base case is `return []` and not `[]`
- [ ] I can state the pure-core / IO-shell rule and say what it buys
- [ ] All 76 checks pass (exercise 2 excepted — run that by hand)

**Next week:** lazy evaluation — the last chapter of pensum, and the one that explains
why `take 5 [1..]` terminates, why `foldr` works on infinite lists, and what your
`iterateU` from week 6 was really doing.
