# Week 6 — Higher-Order Functions

**Hutton chapter 7.** Budget: ~45 min reading, ~25 min GHCi, ~100 min exercises.

> **This is learning outcome #2.** *Høgre ordens funksjonar*, named in the emneplan
> alongside recursion. It is also the week that changes how your code looks.

Last week you wrote a dozen list recursions by hand. This week you discover that nearly
all of them were **three patterns** wearing different clothes, that those three patterns
have names, and that once you can see them you stop writing the recursion at all.

---

## 1. What "higher-order" means, and why it costs nothing

A **higher-order function** takes a function as an argument, or returns one. That's it.

```haskell
twice :: (a -> a) -> a -> a
twice f x = f (f x)
```

```
ghci> twice (+3) 1
7
ghci> twice reverse [1,2,3]
[1,2,3]
```

Note the parentheses in the type: `(a -> a) -> a -> a`. Week 2's rule said `->`
associates right, so those parentheses are **not** redundant — they are what makes the
first argument a function rather than two separate values.

Here is the thing worth appreciating: Haskell needs no special mechanism for this.
Because every function is curried (week 2), *every* multi-argument function already
returns a function. `add 1` was a higher-order result before you knew the term. Taking
functions as arguments is the other half of the same coin, and it is free.

Why it earns its keep:

- Common programming idioms become **library functions**, defined once.
- Domain-specific languages are just a set of combining functions.
- Properties of higher-order functions can be **proved once**, and then apply
  everywhere they are used. That is chapter 16 territory, and the reason the exam cares.

---

## 2. `map` and `filter`

The two you'll use most.

```haskell
map    :: (a -> b) -> [a] -> [b]      -- change every element
filter :: (a -> Bool) -> [a] -> [a]   -- keep some elements
```

Both are one-liners as comprehensions, and both are one-liners as recursions:

```haskell
map f xs = [f x | x <- xs]

map f []     = []
map f (x:xs) = f x : map f xs
```

Read the **types** for the difference that matters. `map` changes the element type
(`a` becomes `b`) and never changes the length. `filter` keeps the element type and may
change the length. That's the whole contract, and it means you can predict what a
pipeline does before reading a line of its body.

They nest, which is where the type discipline pays off:

```haskell
ghci> map (map (+1)) [[1,2],[3]]
[[2,3],[4]]
```

The inner `map (+1)` has type `[Int] -> [Int]`; the outer `map` therefore needs a list
of lists. If you get that wrong, GHC tells you exactly which layer.

---

## 3. `foldr` — the pattern behind almost everything

Look at the shape of nearly every function you wrote last week:

```haskell
f []     = v
f (x:xs) = x ⊕ f xs
```

`sum` is that with `v = 0` and `⊕ = (+)`. `product` is `1` and `(*)`. `and` is `True`
and `(&&)`. `length` is `0` and "ignore the element, add one". **`foldr` is that
pattern, made into a function:**

```haskell
foldr :: (a -> b -> b) -> b -> [a] -> b

sum     = foldr (+) 0
product = foldr (*) 1
and     = foldr (&&) True
```

### The two questions

When you need a fold, ask these, in this order:

1. **What is the answer for the empty list?** → that's the second argument (`v`).
2. **How do I combine the head with the answer for the tail?** → that's the first
   argument.

That is exercise 3, five times over. Nothing else is required. If you can answer those
two questions you have written the fold, and if you can't, you didn't understand the
function well enough to write the recursion either.

### The deeper way to see it

There is a second reading that makes `foldr` click permanently. Every list is built
from two constructors:

```haskell
[1,2,3]  ==  1 : (2 : (3 : []))
```

**`foldr f v` replaces every `:` with `f`, and the final `[]` with `v`.**

```haskell
foldr (+) 0 [1,2,3]   ==  1 + (2 + (3 + 0))   ==  6
foldr (:) [] [1,2,3]  ==  1 : (2 : (3 : []))  ==  [1,2,3]
```

That second line is worth pausing on: `foldr (:) []` is the identity on lists, because
it replaces the constructors with themselves. Once you see folding as *rebuilding the
list with different constructors*, `mapF` and `filterF` in exercise 4 stop being
puzzles — they rebuild with `:` but do something to the element on the way, or skip it.

The name: it folds from the **r**ight. The bracketing goes right to left, and the base
case sits at the far right.

---

## 4. `foldl`, and when you actually want it

`foldl` works the other way: carry an accumulator from the left.

```haskell
foldl :: (b -> a -> b) -> b -> [a] -> b

foldl (+) 0 [1,2,3]  ==  ((0 + 1) + 2) + 3
foldr (+) 0 [1,2,3]  ==  1 + (2 + (3 + 0))
```

For `(+)` both give 6, because addition is associative and 0 is its identity. For a
non-symmetric operation they differ, and **exercise 5 is the case where only `foldl` is
natural**:

```haskell
dec2int :: [Int] -> Int
dec2int = foldl (\acc d -> 10 * acc + d) 0
```

`[2,3,4,5]` → `0` → `2` → `23` → `234` → `2345`. The accumulator *is* the number so
far, and it grows left to right, which is the direction place-value notation runs.
Write the same thing with `foldr` and you will need to know each digit's position; try
it once so the difficulty is a memory rather than a claim.

The rule of thumb:

| Use | When |
|---|---|
| `foldr` | The natural definition builds a list, or the operator's identity sits on the right. Works on infinite lists (week 9). |
| `foldl` | You are accumulating a running value left to right, like a total or a parse state. |

Watch the argument order — it flips. `foldr` takes `a -> b -> b` (element first,
accumulator second); `foldl` takes `b -> a -> b` (accumulator first). Getting this
backwards is the most common `fold` type error, and GHC's message about it is
unhelpful, so check the order before you debug anything else.

> **A performance aside worth knowing for the oblig.** The `reverseF` you write in
> exercise 3 —
> `foldr (\x xs -> xs ++ [x]) []` — is correct and **quadratic**, because `++` walks
> its left argument every time. `foldl (flip (:)) []` is the same function in linear
> time. Correctness first; but when a list is long, this is why one version crawls.

---

## 5. Composition, and point-free style

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
(f . g) x = f (g x)
```

**It reads right to left.** `f . g` does `g` first. This trips everyone up for about a
day and then never again.

```haskell
odd' = not . even
sumOfSquaresOfEvens = sum . map (^2) . filter even
```

Read that last one right to left: keep the evens, square them, sum them. Now read it
left to right as English: "sum of the squares of the evens". The composition chain
reads in the order you'd *say* it, and executes in the reverse. That's the appeal.

Note what is missing from that definition: **the argument**. `sumOfSquaresOfEvens` is
defined as a *pipeline of functions*, with no `xs` named anywhere. This is **point-free
style** ("point" meaning the argument), and it is what exercise 7 asks for. It works
because of currying: `filter even` is already a function `[Int] -> [Int]`, so there is
nothing to apply it to yet.

Don't overdo it. Point-free is clearer for a short pipeline and much worse for anything
with two arguments used twice. The exam-safe test: if you can read it aloud as a
sentence, keep it; if you can't, name the argument.

---

## 6. The binary string transmitter

The chapter's worked example, and exercise 8. It is the best thing in Hutton 7 because
every part of it is a one-line composition, and it shows the style doing real work.

Bits are **little-endian** — least significant first — which looks backwards and is
exactly what makes the fold nice:

```haskell
type Bit = Int

bin2int :: [Bit] -> Int
bin2int = foldr (\b n -> b + 2 * n) 0
```

Why that works: with weights 1, 2, 4, 8 the value of `[a,b,c,d]` is

```
a + 2b + 4c + 8d  ==  a + 2*(b + 2*(c + 2*(d + 2*0)))
```

which is precisely "this bit, plus twice whatever the rest came to" — one `foldr`, no
powers, no indices. If you write it with `zip bits [0..]` and `2^i` you get the right
answer and miss the lesson; write that version too, then look at both.

The rest is composition:

```haskell
encodeB = concat . map (make8 . int2bin . ord)
decodeB = map (chr . bin2int) . chop8
```

Read `encodeB` right to left: character → code point → bits → padded to 8 → all
concatenated. Six words of English, six functions. And `decodeB . encodeB` is the
identity, which is the first thing to test — a property, in the sense of
`docs/checking-your-work.md`.

---

## 7. `unfold` — a fold run backwards

A fold **consumes** a list. `unfold` **produces** one:

```haskell
unfold :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold p h t x
  | p x       = []
  | otherwise = h x : unfold p h t (t x)
```

Three arguments: when to **stop**, what to **emit**, and how to **step**. It is the
same skeleton as every recursion you wrote last week, with the three varying parts
handed in.

```haskell
mapU f    = unfold null (f . head) tail
iterateU  = unfold (const False) id       -- never stops
```

`iterateU` produces an **infinite** list. That is not a bug and not an error — you take
what you need from the front and the rest is never computed. Week 9 explains why that
works; for now, `take 5 (iterateU (*2) 1)` gives `[1,2,4,8,16]` and terminates.

`chop8` from exercise 8 is also an unfold, which is the real content of Hutton 7.6.
Once you've written it recursively, see if you can spot the three parts.

---

## 8. Paper exercises

No computer.

**P1.** (Hutton 7.1) Show that the comprehension

```haskell
[f x | x <- xs, p x]
```

can be expressed using `map` and `filter`. Then say which order the two must go in, and
why the other order is wrong.

**P2.** Using the "replace the constructors" reading of `foldr`, say what each of these
does, without running it:

```haskell
foldr (:) []
foldr (\x xs -> xs ++ [x]) []
foldr (\_ n -> 1 + n) 0
foldr (\x xs -> if even x then x : xs else xs) []
```

**P3.** Expand both of these completely, one step per line:

```haskell
foldr (-) 0 [1,2,3]
foldl (-) 0 [1,2,3]
```

They give different answers. Say in one sentence what property `(-)` lacks that `(+)`
has, and why that makes the difference.

**P4.** Give the type of each:

```haskell
map map
twice twice
(.) . (.)          -- hard; skip if it fights back
map (map (+1))
filter even . map (*2)
```

**P5.** Rewrite point-free, removing the named argument:

```haskell
f xs = sum (map (*2) xs)
g xs = length (filter odd xs)
h x  = not (even x)
```

Answers in `../solutions/week06/PAPER.md`.

---

## 9. Coding exercises

```bash
./check.sh 6              # your code
./check.sh 6 --repl       # GHCi with your code loaded
```

**81 checks** — the biggest week in the tutorial, because this chapter has the most in
it. The one rule:

> **When an exercise says "using foldr", recursion is banned.** Exercises 1 and 2 are
> deliberately recursive so that you have something to compare against; from exercise 3
> onward, a hand-written recursion is the wrong answer even when the tests go green.

Order: 1 and 2 are last week's technique and go fast. **3 is the important one** —
five folds in a row, and the drill is the point. 4 re-derives `map`/`filter` as folds;
put your exercise 1 and exercise 4 answers side by side afterwards. 5 is the `foldl`
lesson. 6 and 7 are short. 8 is the big one and the most satisfying. 9 and 10 are the
Hutton exercises that most often show up in exam form.

When all 81 are green, ask for an **idiom review**. This week that review is worth more
than any other, because "correct but should have been a fold" is exactly what the tests
cannot see, and exactly what this chapter is assessed on.

---

## 10. Checklist

- [ ] I can say what makes a function higher-order, and why currying makes it free
- [ ] I can state the two `foldr` questions and use them without thinking
- [ ] I can explain `foldr f v` as replacing `:` with `f` and `[]` with `v`
- [ ] I know `foldr (:) []` is the identity, and why
- [ ] I know the argument order differs between `foldr` and `foldl`
- [ ] I can give one problem where `foldl` is the natural choice
- [ ] I know `f . g` applies `g` first
- [ ] I can write a three-stage pipeline point-free
- [ ] I can explain why little-endian bits make `bin2int` a single fold
- [ ] I know `unfold`'s three arguments by role: stop, emit, step
- [ ] All 81 checks pass

**Next week:** declaring types and classes — **learning outcome #3**, your own data
types, and the point at which you stop borrowing the Prelude's vocabulary and define
your own.
