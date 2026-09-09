# Week 1 — The Functional Mindset, GHCi, First Steps

**Hutton chapters 1–2.** Budget: ~30 min reading, ~30 min GHCi play, ~90 min exercises.


## The short version

The whole week in ordinary language, before any of the detail.

- **`=` does not mean "store this".** It means "this name *is* this thing", permanently.
  Nothing is ever a box, so nothing ever changes.
- **A space means "apply".** `f x` is f applied to x, and that binds tighter than any
  operator — so `f x + 1` is `(f x) + 1`.
- **There are no loops,** because loops need a counter that changes. A function calls
  itself on a smaller input instead.
- **Nothing is computed until someone needs it,** which is why an infinite list is a
  perfectly reasonable thing to write down.
- **`:t` is the command you will use most.** When you are confused, ask for the type.

---

## 1. Why this language feels wrong at first

You know imperative programming. There, a program is a *sequence of commands that
change memory*:

```python
total = 0
for x in [1,2,3,4]:
    total = total + x     # total is a box; we keep overwriting it
```

`total` means something different on every line. To know what the program does you
have to simulate it in your head, tracking state through time.

Haskell deletes that whole idea. There are no commands and no boxes. A program is
an **expression**, and running it means **reducing the expression to a value**:

```haskell
sum [1,2,3,4]
```

The `=` sign is not assignment. It is a *definition*, in the mathematical sense.
When you write `x = 5`, you are not putting 5 into x; you are saying that `x` and
`5` are two names for the same thing, permanently. This is why you cannot write
`x = x + 1` in Haskell — read as a definition, it's nonsense.

The payoff has a name: **referential transparency**. Any expression can be replaced
by its value without changing the program's meaning. `sum [1,2,3]` is *always* `6`,
in every context, forever. That is what makes the equational reasoning in Hutton
ch. 16 possible, and it is what your exam will keep leaning on.

> **Exam framing.** INF122's stated learning outcomes name three things:
> *rekursjon, høgre ordens funksjonar, ikkje-muterbare datastrukturar* —
> recursion, higher-order functions, immutable data structures. Everything in
> these twelve weeks is in service of those three, plus being able to *discuss*
> the imperative/functional split. That last one is an essay question waiting to
> happen; the paragraph above is your answer to it.

---

## 2. GHCi: your primary tool

You already have GHC 9.10.3 installed. Open the REPL from the repo root:

```bash
ghci
```

You get a `ghci>` prompt. Type expressions, get values:

```haskell
ghci> 2 + 3
5
ghci> sum [1..100]
5050
ghci> reverse "haskell"
"lleksah"
```

The commands you will use constantly — **memorise these four**:

| Command | Short | Does |
|---|---|---|
| `:load Foo.hs` | `:l` | Load a file |
| `:reload` | `:r` | Reload after editing — you will hit this hundreds of times |
| `:type expr` | `:t` | Show the type of an expression **without evaluating it** |
| `:quit` | `:q` | Leave |

`:type` is the single most useful thing in the language. When you are confused,
ask GHCi what type something has. Try these now and read every answer:

```haskell
ghci> :t True
ghci> :t 'a'
ghci> :t "abc"
ghci> :t reverse
ghci> :t (+)
ghci> :t sum
```

Two of those will surprise you. `:t "abc"` says `[Char]` — a String *is* a list of
characters, not a separate type. And `:t (+)` says
`(+) :: Num a => a -> a -> a`, which has a `=>` in it. Park that; it's week 2.

### The `it` variable and multi-line input

GHCi binds the last result to `it`, which is handy for poking at a value:

```haskell
ghci> qsort [3,1,2]
[1,2,3]
ghci> length it
3
```

For definitions spanning several lines, wrap them in `:{` and `:}`:

```haskell
ghci> :{
ghci| double :: Int -> Int
ghci| double n = n * 2
ghci| :}
```

In practice you'll write definitions in a `.hs` file and `:r` instead.

---

## 3. Function application: the syntax that trips everyone

In maths and in most languages you write `f(x)` and `g(x, y)`. In Haskell you write:

```haskell
f x
g x y
```

Juxtaposition *is* application. No parentheses, no commas. Parentheses are only for
grouping. This has consequences that catch every beginner:

```haskell
f a + b        -- means (f a) + b        NOT f (a + b)
f a b          -- means (f a) b          two arguments
f (g x)        -- parens needed: apply g to x first, then f to that
f g x          -- means (f g) x          passes g ITSELF to f -- probably not what you meant
```

**Function application binds tighter than every operator.** Burn that in. It is the
single most common source of confusing type errors in your first month.

A worked comparison, from Hutton p. 9:

| Maths | Haskell |
|---|---|
| f(x) | `f x` |
| f(x, y) | `f x y` |
| f(g(x)) | `f (g x)` |
| f(x, g(y)) | `f x (g y)` |
| f(x) g(y) | `f x * g y` |

### Backticks and sections

Any two-argument function can be written infix with backticks, and any operator can
be written prefix with parentheses:

```haskell
ghci> div 7 2
3
ghci> 7 `div` 2      -- same thing, often reads better
3
ghci> (+) 1 2        -- operator used prefix
3
```

---

## 4. The Prelude list toolkit

These are in scope automatically. Play with each one in GHCi *right now* — don't
just read them. Try each on `[1,2,3,4,5]` and on `"haskell"`.

```haskell
head [1,2,3]        -- 1          first element
tail [1,2,3]        -- [2,3]      everything after the first
take 2 [1,2,3]      -- [1,2]      first n
drop 2 [1,2,3]      -- [3]        all but first n
length [1,2,3]      -- 3
sum [1,2,3]         -- 6
product [1,2,3]     -- 6
[1,2] ++ [3,4]      -- [1,2,3,4]  append
reverse [1,2,3]     -- [3,2,1]
[1,2,3] !! 1        -- 2          index, ZERO-based
null []             -- True       is it empty?
elem 2 [1,2,3]      -- True       membership
minimum [3,1,2]     -- 1
maximum [3,1,2]     -- 3
```

### A warning you will see, and what it means

`head` and `tail` **crash on the empty list**. GHC 9.10 now warns about this
(`-Wx-partial`) because they are *partial functions* — undefined for some inputs.
Hutton uses them freely in early chapters, and so do the week-1 exercises, so the
tutorial's test runner silences that warning. But note the idea now: a total
function that returns `Maybe a` is the grown-up alternative, and you'll build it in
week 4. If you see this warning in your own lecture code, it isn't an error.

---

## 5. Writing and loading a script

Create a file, say `tutorial/scratch.hs`:

```haskell
double :: Int -> Int
double n = n * 2

quadruple :: Int -> Int
quadruple n = double (double n)
```

Load it: `ghci tutorial/scratch.hs`, then call `quadruple 5`. Edit the file, type
`:r`, call it again. **That edit → `:r` → test loop is your whole workflow.**

### Naming rules — not stylistic, enforced by the compiler

- Function and variable names **must start with a lowercase letter**.
  `myList`, `x'`, `f2` are fine. `MyList` is not — capitalised names are reserved
  for types and constructors.
- After the first character: letters, digits, underscores, and the apostrophe `'`.
  `x'` is pronounced "x prime" and conventionally means "a modified version of x".
- Lists conventionally get an `s` suffix: `xs` is a list of `x`, `xss` a list of
  lists.

### The layout rule

Haskell uses indentation to group definitions, like Python:

```haskell
a = b + c
  where
    b = 1
    c = 2
```

`b` and `c` must be indented **the same amount**. If one is indented further than
the other, you get a parse error. **Use spaces, never tabs** — mixing them produces
errors that are genuinely hard to see.

### Comments

```haskell
-- single line, to end of line

{- multi
   line -}
```

---

## 6. Read Hutton's quicksort properly

This is in your exercise file. It's five lines and it's the best advertisement the
language has:

```haskell
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
  where
    smaller = [a | a <- xs, a <= x]
    larger  = [b | b <- xs, b >  x]
```

Read it aloud as a *specification*, not as instructions:

- Sorting nothing gives nothing.
- Sorting a list whose head is `x` and rest is `xs` gives: the sorted things
  smaller than `x`, then `x`, then the sorted things bigger than `x`.

That's the definition of quicksort, and it *is* the program. No indices, no swaps,
no temporary buffer, no off-by-one. Notice three things you'll meet properly later:

1. **Pattern matching** — `[]` and `(x:xs)` split the input by shape (week 3).
2. **List comprehensions** — `[a | a <- xs, a <= x]` (week 4).
3. **`Ord a =>`** — "for any type `a` that can be ordered" (week 2).

Trace `qsort [3,1,4,2]` by hand on paper. Genuinely do this; write out every
recursive call and what it returns. Ten minutes here saves you hours in week 5.

---

## 7. Paper exercises

Your exam is **3 hours, written, no aids**. You will be writing Haskell with a pen.
Start now — do these without a computer, then check in GHCi.

**P1.** Parenthesise these to show the order of application/precedence, then
evaluate:
```
2 ^ 3 * 4
2 * 3 + 4 * 5
2 + 3 * 4 ^ 5
```

**P2.** This script has three separate errors. Find them by reading, then fix it
(Hutton ex. 2.3):
```haskell
N = a 'div' length xs
   where
      a = 10
     xs = [1,2,3,4,5]
```

**P3.** What is the value of `take 3 (reverse [1,2,3,4,5])`? Work it out on paper
before running it.

**P4.** Explain in two sentences, as if to a classmate taking INF100, why
`x = x + 1` is valid Python but meaningless Haskell. This is exam-essay practice.

Answers are in `../solutions/week01/PAPER.md` — but write yours down first.

---

## 8. Coding exercises

Open `Exercises.hs`. Replace each `undefined`. From the `tutorial/` directory:

```bash
./check.sh 1              # run the tests
./check.sh 1 --repl       # open GHCi with your code loaded
./check.sh 1 --solution   # run tests against the reference answers
```

Unimplemented stubs show as `todo`, not as failures, so you can work through them
one at a time. Aim to get all 19 checks green.

When they pass, ask me for an **idiom review** — paste your `Exercises.hs` and I'll
critique style, not just correctness. Getting the right answer is half the skill in
this course; writing it the way a Haskell programmer would is the other half.

---

## 9. Checklist before week 2

- [ ] I can open GHCi, load a file, edit it, and `:r`
- [ ] I use `:t` reflexively when confused
- [ ] I can say why `f a + b` is not `f (a + b)`
- [ ] I traced `qsort [3,1,4,2]` on paper
- [ ] All 19 checks in week 1 pass
- [ ] I can explain referential transparency without notes

**Next week:** types and classes — what `Ord a =>` actually means, and why
Haskell's type system is the thing that makes the rest of this course work.
