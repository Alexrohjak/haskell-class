# Week 8 — Paper exercise answers

## P1 — Which types can perform IO?

```haskell
Int -> Int          -- NO
Int -> IO Int       -- yes
IO (Int -> Int)     -- yes, but see below
[IO Int]            -- no, not by itself
IO ()               -- yes
```

**`Int -> Int`** — no, and this is a compiler-enforced guarantee, not a convention.
There is no `IO` in the type, so nothing in the body can perform one; anything that
tried would fail to typecheck.

**`Int -> IO Int`** — yes. Applying it to an `Int` gives you an action, which does the
IO when performed.

**`IO (Int -> Int)`** — yes, and the distinction is worth stating: the IO happens while
*producing* the function (reading a configuration value, say). The `Int -> Int` it hands
back is pure, and calling it does nothing.

**`[IO Int]`** — a *list of actions*. The list itself is an ordinary pure value; you can
build it, reverse it, take its length, all without anything happening. It performs IO
only when something runs its elements — which is exactly what `sequenceIO` in exercise 1
does. This is the clearest illustration that actions are values.

**`IO ()`** — yes. The result type `()` carries no information, so such an action exists
purely for its effect.

## P2 — `<-` versus `let`

```haskell
do x <- getLine        -- x :: String   -- runs getLine, names the result
   putStrLn x          -- fine

do let x = getLine     -- x :: IO String -- names the ACTION; reads nothing
   putStrLn x          -- TYPE ERROR
```

**The second is the type error**, and GHC says:

```
• Couldn't match type: IO String
                 with: [Char]
  Expected: String
    Actual: IO String
• In the first argument of 'putStrLn', namely 'x'
```

`putStrLn` wants a `String`; `x` is an `IO String`, an unperformed description of
reading a line. Nothing was read, and nothing will be — the `let` just gave the recipe a
name.

The one-line summary worth memorising: **`<-` performs, `let` names.** Use `<-` for
actions, `let` for pure values.

## P3 — Why `return` is a bad name

> In an imperative language `return` transfers control: it ends the current function and
> hands back a value. Haskell's `return` does none of that — it is an ordinary function,
> `return :: a -> IO a`, that wraps a plain value into an action which performs no
> input/output and simply yields that value.

**`return 5` in the middle of a `do` block does nothing at all.** It builds an action,
the block discards it because nothing binds it with `<-`, and execution carries straight
on to the next statement. Anyone reading it as "stop here and give back 5" has it exactly
backwards.

The name survives for historical reasons; in later Haskell it is a synonym for `pure`,
which is the better name and says what it does — it makes a *pure* value into an action.
The place you genuinely need it is at the end of a `do` block whose last computed value
is pure, as in exercise 1's `return (x : xs)`, and as the base case `return []`, which
must be an action even though the list is empty.

## P4 — `playMoves [5,4,3,2,1] [(1,2),(9,1),(2,4)]`

| move | valid? | why | board after |
|---|---|---|---|
| start | — | — | `[5,4,3,2,1]` |
| `(1,2)` | yes | row 1 holds 5, and 2 ≥ 1 | `[3,4,3,2,1]` |
| `(9,1)` | **no** | there is no row 9 — the board has 5 rows | `[3,4,3,2,1]` (unchanged) |
| `(2,4)` | yes | row 2 holds 4, taking all 4 is allowed | `[3,0,3,2,1]` |

**Result: `[3,0,3,2,1]`.**

Two things the trace is designed to expose. The invalid move is **skipped, not fatal** —
play continues with the board untouched, which is what a real game does when you mistype.
And the range check in `valid` must be tested *before* indexing: `board !! 8` on a
five-element list raises an exception, so a `valid` that checks the star count first will
crash rather than return `False`. Order of guards is doing real work here.

## P5 — Purity and the keyboard (essay drill)

> Haskell keeps referential transparency by never giving you a function that reads the
> keyboard. Instead it gives you *values* of type `IO a`, which are descriptions of
> actions. `getLine :: IO String` is the same value every time it is mentioned — the same
> description — so replacing one occurrence with another changes nothing, and the
> transparency law holds. What varies is the result of *performing* that description, and
> performing only happens where an action is reached from `main`. Building a description
> of an effect is not itself an effect, so effects can be first-class values in a
> language that has none.
>
> The practical consequence is in the types. A Haskell function typed `String -> String`
> is guaranteed by the compiler not to read a file, print, consult the clock, or mutate
> anything: there is no `IO` in its type, so no such operation typechecks in its body. The
> equivalent Java signature `String f(String)` guarantees nothing — it may write to disk,
> open a socket, or change global state, and the only way to find out is to read the body
> and everything it calls. Haskell has moved a whole class of question from *inspection*
> to *type checking*.

Worth adding if you have room: this is also why the pure-core / IO-shell split is
practical rather than merely tasteful. Logic outside `IO` can be tested by comparing
values — which is how this week has 76 automatic checks over two interactive games.
