# Week 5 — Recursive Functions

**Hutton chapter 6.** Budget: ~40 min reading, ~20 min GHCi, ~100 min exercises.

> **This is learning outcome #1.** The emneplan names three things you must be able to
> do — *rekursjon, høgre ordens funksjonar, ikkje-muterbare datastrukturar* — and this
> is the first. Everything in weeks 6 to 9 is built on top of it. If you only have time
> to do one week of this tutorial properly, do this one.


## The short version

The whole week in ordinary language, before any of the detail.

- **Recursion here is not a technique, it is the only loop there is.**
- **Every recursive function has the same two parts:** a base case that answers outright,
  and a step that calls itself on something smaller.
- **"Smaller" is what makes it stop.** If the recursive call is not on a smaller input,
  you have written a program that runs forever.
- **On lists, the shape writes itself:** one equation for `[]`, one for `(x:xs)`, and the
  recursive call is almost always on `xs`.
- **This is learning outcome #1,** and weeks 6–9 are all built on top of it.

---

## 1. Recursion is not a technique here. It is the only loop.

In Python you have `for` and `while`, and recursion is an exotic alternative you use
for trees. In Haskell there are no loops at all — no `for`, no `while`, no mutable
counter to increment. There is nothing to increment.

So recursion is not the clever option. It is **the** option, and it stops feeling
exotic about two hours from now.

```haskell
fac :: Int -> Int
fac 0 = 1
fac n = n * fac (n - 1)
```

Read that as a *definition*, not as a procedure — the way you read `n! = n × (n−1)!`
in a maths textbook. It is not a machine stepping through states. It is a claim about
what `fac n` equals, in terms of a smaller instance of the same problem. The
evaluation is the machine's business:

```
  fac 3
= 3 * fac 2
= 3 * (2 * fac 1)
= 3 * (2 * (1 * fac 0))
= 3 * (2 * (1 * 1))
= 6
```

Write that expansion out by hand for `fac 4` before you go on. It takes ninety seconds
and it is the mental model you'll use all semester.

---

## 2. The two cases

Every recursive definition has at least one of each:

- a **base case**, which gives an answer directly, and
- a **recursive case**, which gives an answer in terms of a *smaller* input.

Both halves have a failure mode, and they are the two bugs you will actually write:

| Missing | Symptom |
|---|---|
| No base case, or one that is never reached | The program hangs, or blows the stack |
| No progress toward the base case | Same |
| Base case wrong | Silent wrong answers, usually off by the identity element |

Exercise 1 is the first of those, deliberately. Hutton's `fac` above is fine for `3`
and never terminates for `-1`: it counts 0, −1, −2, … and never matches `fac 0`. The
base case exists but is **unreachable** from where you started. Add a guard, and note
what you learned — *"is there a base case?"* is the wrong question. The question is
*"is the base case reachable from every input?"*

---

## 3. Hutton's five-step recipe

Section 6.6 of the book, and the most immediately useful page in it. When you don't
know how to start, do these in order, on paper.

**Step 1 — write down the type.** Not optional and not last. The type tells you how
many cases you need and what shape they are.

```haskell
drop' :: Int -> [a] -> [a]
```

**Step 2 — enumerate the cases.** One per shape the arguments can take. Two arguments,
a number and a list, so:

```haskell
drop' 0 []     = ...
drop' 0 (x:xs) = ...
drop' n []     = ...
drop' n (x:xs) = ...
```

**Step 3 — define the simple (base) cases.** The ones that need no recursion:

```haskell
drop' 0 []     = []
drop' 0 (x:xs) = x:xs
drop' n []     = []
drop' n (x:xs) = ...
```

**Step 4 — define the remaining cases**, in terms of a smaller problem:

```haskell
drop' n (x:xs) = drop' (n - 1) xs
```

**Step 5 — generalise and simplify.** Now look for cases that agree, arguments you
never used, and a more general type:

```haskell
drop' :: Int -> [a] -> [a]
drop' 0 xs     = xs        -- the first two cases collapsed
drop' _ []     = []        -- x and xs were never used, so use _
drop' n (_:xs) = drop' (n - 1) xs
```

That last step is where the marks are. Step 4 gets you a correct answer; step 5 gets
you the answer a Haskell programmer would have written. Run the recipe on paper for
exercises 5 and 8 even though you can see the answers — the habit is what you're
installing, and you want it available on 2 December when you can't see the answer.

---

## 4. Recursion on lists

A list is either `[]` or `x : xs`. That is not a fact about lists so much as the
*definition* of one — and it hands you your two cases for free. Almost every list
function in this chapter has exactly this skeleton:

```haskell
f []     = <the answer for the empty list>
f (x:xs) = <combine x with (f xs)>
```

```haskell
product' :: [Int] -> Int
product' []     = 1
product' (x:xs) = x * product' xs

length' :: [a] -> Int
length' []     = 0
length' (_:xs) = 1 + length' xs

reverse' :: [a] -> [a]
reverse' []     = []
reverse' (x:xs) = reverse' xs ++ [x]
```

### The base case is an identity element, and this matters

Look at those three base cases: `1`, `0`, `[]`. They are not arbitrary "empty" answers
— each is the **identity** for the operation the recursive case uses. `1` for `*`, `0`
for `+`, `[]` for `++`.

That is the principle that answers the question exercise 5 sets you:

> `and' [] == True`. Why not `False`?

Because `True` is the identity for `&&`, and because it is the only choice that keeps

```haskell
and' (xs ++ ys) == and' xs && and' ys
```

true for *every* `xs` and `ys` — including when one of them is empty. "All of no
conditions hold" is vacuously true, and the arithmetic agrees with the English. The
same argument gives `sum' [] = 0` and `product' [] = 1`, which is also why `sum []` is
0 rather than an error.

When you are stuck on a base case, ask: **what value would leave the recursive step
unchanged?**

---

## 5. Two arguments, and recursing on both

Some functions step through two things at once. `zip` runs out when *either* list does:

```haskell
zip' :: [a] -> [b] -> [(a,b)]
zip' [] _          = []
zip' _ []          = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys
```

Two base cases, because there are two ways to finish. Exercise 8's `take'` is the same
shape with a number in place of the second list, and exercise 6's `merge` is the same
shape again — but there, crucially, **the two base cases do different things**:

```haskell
merge [] ys = ys       -- the rest of ys still has to come out
merge xs [] = xs
```

Return `[]` from either and you silently lose half your data. `msort` will still
produce a *sorted* list, just a shorter one — the kind of bug that passes a careless
eyeball test. This is why exercise 6's checks include `merge [] [1,2]`.

---

## 6. Multiple recursion

A definition may call itself more than once:

```haskell
fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib n = fib (n - 2) + fib (n - 1)
```

Two base cases here because the recursive case reaches back two steps; with only
`fib 0` defined, `fib 1` would go to `fib (-1)` and never stop.

And the one you already met in week 1:

```haskell
qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
  where smaller = [a | a <- xs, a <= x]
        larger  = [b | b <- xs, b >  x]
```

Exercise 7's `msort` is the other classic of this shape. Both split the problem in
two, recurse on each half, and combine — but they divide the labour differently, and
that difference is a good exam answer:

| | Splits by | Combines with |
|---|---|---|
| `qsort` | **value** (the comprehensions do the work) | `++`, which is trivial |
| `msort` | **position** (`halve` is trivial) | `merge`, which does the work |

One of them does the thinking on the way down, the other on the way back up.

> **The `msort` trap.** You need *both* `msort [] = []` and `msort [x] = [x]`. Without
> the second, `halve [x]` gives `([], [x])`, so `msort [x]` calls `msort [x]` — forever.
> If `./check.sh 5` hangs instead of failing, press Ctrl-C and come back to this
> paragraph.

---

## 7. Mutual recursion

Two functions defined in terms of each other:

```haskell
even' :: Int -> Bool
even' 0 = True
even' n = odd' (n - 1)

odd' :: Int -> Bool
odd' 0 = False
odd' n = even' (n - 1)
```

Neither is recursive on its own; together they are. Exercise 9 does this for
`evens`/`odds` on lists, and it is worth comparing against how week 4 would have
attacked the same problem:

```haskell
-- the week-4 style: describe it, with a comprehension and an index
evens xs = [x | (x,i) <- zip xs [0..], even i]

-- week 5, mutually recursive
evens []     = []
evens (x:xs) = x : odds xs
odds  []     = []
odds  (_:xs) = evens xs
```

The second doesn't compute an index at all. It doesn't need to — "every other element"
is expressed by *alternating which function is in charge*. Week 4's `positions` had to
reach for `zip xs [0..]` to get at positions; this needs nothing of the kind. That is a genuinely
different idea about the same problem, and noticing it is worth more than either
definition.

This is also exercise 4 on the lecturer's `uke1.txt` sheet. You now have two answers
to it and a real reason to prefer one.

---

## 8. Paper exercises

No computer. Write them out, then check.

**P1.** Expand by hand, one step per line, all the way to a value:

```haskell
fac 4
sumdown 3
```

**P2.** (Hutton 6.5) Given

```haskell
(^) :: Int -> Int -> Int
x ^ 0 = 1
x ^ n = x * (x ^ (n - 1))
```

show how `2 ^ 3` is evaluated, one step per line. How many multiplications happen, in
terms of `n`?

**P3.** Explain in two or three sentences why `and' [] = True` and `product' [] = 1`
are the right base cases, and what would break if they were `False` and `0`.

**P4.** Run Hutton's five-step recipe on paper for

```haskell
elem' :: Eq a => a -> [a] -> Bool
```

Write out all five steps, including the ones that feel too obvious to write.

**P5.** For each of these, say whether it terminates for **every** `Int` input, and if
not, give an input where it doesn't:

```haskell
f 0 = 0
f n = f (n - 1)

g 0 = 0
g n = g (n - 2)

h n | n <= 0    = 0
    | otherwise = h (n - 1)

k n = k n
```

Answers in `../solutions/week05/PAPER.md`.

---

## 9. Coding exercises

```bash
./check.sh 5              # your code
./check.sh 5 --repl       # GHCi with your code loaded
```

**63 checks**, the biggest week so far. Two rules for this one:

> **No list comprehensions.** Week 4 was about *describing* a list; week 5 is about
> *building* one. Several exercises here would fall to a one-line comprehension, and
> reaching for one skips the entire chapter.

> **If it hangs, you have a base-case bug.** Ctrl-C, then ask which input fails to
> reach a base case. That question has answered every hang in this chapter for every
> student who ever took it.

Order: 1–4 are number recursion and go quickly. 5 and 8 are the list-recursion drill —
eight small functions with the same skeleton, and doing them in a row is what makes the
skeleton automatic. 6 and 7 are the real work; do `merge` properly before starting
`msort`, and test `merge` on the empty cases first. 9 is a five-minute finish.

When all 63 are green, ask for an **idiom review** — this is the week where it pays
most, because there are usually two or three definitions where a case can be collapsed
or an argument replaced by `_`. That is step 5 of the recipe, and the tests cannot see
it.

---

## 10. Checklist

- [ ] I can expand `fac 4` on paper without hesitating
- [ ] I can state Hutton's five steps from memory
- [ ] I know the question is "is the base case *reachable*", not "does one exist"
- [ ] I can explain why `and' [] = True` in terms of identity elements
- [ ] I know why `merge` needs two *different* base cases
- [ ] I can say how `qsort` and `msort` divide the work differently
- [ ] I know why `msort` needs the `[x]` case
- [ ] I can write a mutually recursive pair and say what makes it terminate
- [ ] All 63 checks pass

**Next week:** higher-order functions — **learning outcome #2**. `map`, `filter`,
`foldr`, and the discovery that most of the recursion you just wrote by hand was three
patterns wearing different hats.
