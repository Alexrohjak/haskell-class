# Week 7 — Declaring Types and Classes

**Hutton chapter 8.** Budget: ~45 min reading, ~25 min GHCi, ~110 min exercises.

> **This is learning outcome #3.** *Ikkje-muterbare datastrukturar* — immutable data
> structures. The last of the three the emneplan names.

Six weeks of borrowing the Prelude's vocabulary. This week you get your own. It is the
point at which Haskell stops being a language for pushing lists around and becomes a
language for **modelling a problem** — and it is where the type system finally starts
working for you rather than at you.


## The short version

The whole week in ordinary language, before any of the detail.

- **`type` is a nickname; `data` makes something genuinely new.** Only `data` gives you
  a value the compiler will keep separate from everything else.
- **A `data` declaration lists the ways a value can be built,** and each way gets a name
  you can pattern match on.
- **Types can be recursive,** which is how you get trees — and the code that walks a tree
  looks exactly like the type that describes it.
- **A class is a list of things a type must be able to do;** an instance is one type
  proving it can.
- **This is learning outcome #3 — your own immutable data structures.**

---

## 1. `type` — a new name for an old type

```haskell
type String = [Char]
type Pos    = (Int, Int)
type Board  = [Pos]
```

A **synonym**. It creates no new type, only a shorter way to say an existing one. `Pos`
and `(Int, Int)` are interchangeable everywhere, and GHC will happily accept one where
the other is expected.

Synonyms may take parameters and may nest:

```haskell
type Pair a = (a, a)
type Assoc k v = [(k, v)]
type Subst = Assoc Char Bool      -- built on the one above
```

They may **not** be recursive:

```haskell
type Tree = (Int, [Tree])       -- ERROR: cycle in type synonym declarations
```

There is nothing to stop the expansion — the compiler would substitute forever. For a
recursive shape you need `data`, which is §3.

Use synonyms for documentation: `Subst` says something `[(Char, Bool)]` does not. Just
be clear about what you are getting — a synonym provides **no protection**. If `Pos` and
`Size` are both `(Int, Int)`, nothing stops you passing one where the other belongs.

---

## 2. `data` — a genuinely new type

```haskell
data Bool = False | True                      -- the actual Prelude definition
data Shape = Circle Double | Rect Double Double
```

The `|` is read "**or**". A `Shape` is a `Circle` **or** a `Rect`, never both and never
anything else. That closed-ness is the point: when you write a function over `Shape`,
GHC knows there are exactly two cases and will warn you if you miss one.

This is a **sum type** (a choice between alternatives), and it is the thing most
mainstream languages don't have. In Java or Python you'd model this with a class
hierarchy or a tagged dict, and nothing checks that you handled every case.

### Constructors are functions

```
ghci> :t Circle
Circle :: Double -> Shape
ghci> :t Rect
Rect :: Double -> Double -> Shape
```

Run those, honestly — it is the fastest way for this to click. `Rect` is an ordinary
curried function of two `Double`s that returns a `Shape`, and it can be partially
applied, mapped, and passed around like any other function:

```
ghci> map (Rect 2) [3,4,5]
[Rect 2.0 3.0, Rect 2.0 4.0, Rect 2.0 5.0]
```

What makes a constructor special is only that it can also appear **in a pattern**,
which is how you take the value apart again:

```haskell
area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rect w h) = w * h
```

Constructor names must start with a capital letter. That is how you and the compiler
tell `Circle` (a constructor) from `r` (a variable) inside a pattern.

---

## 3. Parameterised and recursive types

Data declarations take type parameters:

```haskell
data Maybe a = Nothing | Just a
```

That is the whole of `Maybe` — no magic, no special case in the compiler. It is the
answer to every partial function you have written so far. In week 1 you wrote
`thirdHeads` and the comment said "it crashes on short lists, and that's fine for now".
Exercise 3 is *now*:

```haskell
safeThird :: [a] -> Maybe a
```

**Failure has moved from a crash into the return type**, where the type checker forces
the caller to acknowledge it. You cannot accidentally use a `Maybe Int` as an `Int`. In
a language with `null` you can, and that is the difference.

And `data`, unlike `type`, may be **recursive**:

```haskell
data Nat  = Zero | Succ Nat
data Expr = Val Int | Add Expr Expr | Mul Expr Expr
data Tree a = Leaf | Node (Tree a) a (Tree a)
```

### The one idea to take from this chapter

> **The shape of the data dictates the shape of the function.**

`Nat` has two constructors, so `nat2int` has two equations. `Expr` has three, so
`evalE` has three. `Tree` has two, so `flatten` has two. You are not deciding how many
cases to write — the declaration already decided.

Watch it happen on `addNat`, exercise 2:

```haskell
addNat :: Nat -> Nat -> Nat
addNat Zero     n = n
addNat (Succ m) n = Succ (addNat m n)
```

There is **no arithmetic in there at all**. Peel a `Succ` off the first argument, put a
`Succ` back on the result. The recursion *is* the addition. Converting to `Int`,
adding, and converting back also works and teaches you nothing — which is why exercise 2
forbids it.

---

## 4. Two trees are not the same tree

Exercises 4 and 5 both say "tree" and are different types:

```haskell
data Tree  a = Leaf | Node (Tree a) a (Tree a)      -- values at the NODES
data BTree a = BLeaf a | BNode (BTree a) (BTree a)  -- values at the LEAVES
```

Getting used to that is half of what this chapter is for. "Tree" is not a type; it is a
*family* of types, and which one you want depends on the problem. The search tree wants
values at the nodes so it can compare and descend. Hutton's balancing exercises want
values at the leaves so that "number of leaves" is the obvious measure of size.

### `compare`, and why `occurs` uses it

The obvious `occurs`:

```haskell
occurs x (Node l y r)
  | x == y    = True
  | x < y     = occurs x l
  | otherwise = occurs x r
```

is correct and does **up to two comparisons per node**. This does one:

```haskell
occurs x (Node l y r) = case compare x y of
  LT -> occurs x l
  EQ -> True
  GT -> occurs x r
```

`compare :: Ord a => a -> a -> Ordering`, and `Ordering` is just
`data Ordering = LT | EQ | GT` — another plain data type. On a deep tree of expensive
values (long strings, say) that halving is real. This is Hutton 8.2, and it is a
tidy example of a data type replacing repeated work.

---

## 5. Folding your own type

Week 6 taught you `foldr` as "replace `:` with `f` and `[]` with `v`". That reading
is not special to lists: **every** data type has a fold that says what to put in place
of each of its constructors. The lecturer builds one for his `Tre` on slides 85–97 of
`6-typer(kap8).pdf` — read those.

Writing the fold for `Expr`, and then `evalE` and `sizeE` with it, is exercise 6 (and
task 2 of his sheet uke6), so it is not worked here. Two questions to take into it:

- Look at each constructor of `Expr` in turn. What does the fold need to be *given*
  to replace it, and what type must that thing have?
- By the time the function replacing `Add` is called, what does it receive: two
  expressions, or two answers?

The payoff, once it is green: everything over `Expr` becomes an application of one
function that holds the recursion, once. That is the most reusable idea in the
chapter. Worked answers are in `../solutions/week07/`, after yours.

---

## 6. `deriving`, and what it actually writes

```haskell
data Shape = Circle Double | Rect Double Double
  deriving (Eq, Show)
```

GHC writes the instances for you. `Eq` gives structural equality — same constructor,
and all fields equal. `Show` gives a `show` that reproduces the constructor syntax,
which is why the test harness can print `Rect 2.0 2.0` back at you.

The common derivable classes: `Eq`, `Ord`, `Show`, `Read`, `Enum`, `Bounded`. `Ord`
orders by **constructor order first**, then by fields — so in `data Ordering = LT | EQ |
GT`, `LT < GT` because `LT` was declared first. Reorder the constructors and you change
the ordering.

You cannot derive `Eq` for a type containing a function, for exactly the reason week 2
gave: function equality isn't computable. The error names the missing instance rather
than the rule, so recognise it.

---

## 7. Classes and instances

A **class** declares an interface; an **instance** says a particular type provides it.

```haskell
class Pretty a where
  pretty :: a -> String

instance Pretty Bool where
  pretty True  = "yes"
  pretty False = "no"
```

That is exercise 7, and it is deliberately small, because the syntax is the only new
thing — the method bodies are ordinary functions.

Two details that come up in exams:

**Classes can have default definitions.** The real `Eq` defines `/=` in terms of `==`,
so an instance need only supply one of them.

**Classes can extend other classes.** `class Eq a => Ord a where ...` means every `Ord`
type must already be an `Eq` type, which is why week 2's table said `Ord` requires `Eq`.

The distinction to keep straight, because it is a favourite question:

| | is a | says |
|---|---|---|
| `data` | type definition | what values exist |
| `class` | interface | what operations a type must support |
| `instance` | implementation | how *this* type supports them |

A class is **not** a type, and it is not a Java class. `Pretty` cannot be the type of a
value; it can only constrain a type variable, as in `pretty :: Pretty a => a -> String`.

---

## 8. The tautology checker

Exercise 8, and the chapter's showcase. A proposition is data:

```haskell
data Prop = Const Bool | Var Char | Not Prop | And Prop Prop | Imply Prop Prop
```

and the checker is five small functions, each of which is easy alone:

| | does |
|---|---|
| `evalP s p` | the value of `p` under substitution `s` — one equation per constructor |
| `varsP p` | every variable in `p`, duplicates included |
| `boolsP n` | all 2ⁿ lists of `n` Bools |
| `substs p` | every assignment of `p`'s variables |
| `isTaut p` | `and` over all of them |

The interesting one is `boolsP`, which is a recursion that **doubles**:

```haskell
boolsP 0 = [[]]
boolsP n = map (False:) bss ++ map (True:) bss
  where bss = boolsP (n - 1)
```

Note `boolsP 0 = [[]]` — a list containing *one* empty list, not the empty list. There
is exactly one way to assign no variables, and getting this wrong makes everything
downstream come out empty. It is the same identity-element instinct as `and [] = True`.

The other thing to work out before writing it: **`Imply` is False in exactly one case**
— true antecedent, false consequent. So `A → B` is `not A || B`. Students routinely get
this backwards, and one wrong row makes `isTaut` wrong in a way the shape of the code
won't reveal.

---

## 9. Paper exercises

No computer.

**P1.** Give the type of each **constructor**:

```haskell
Circle, Rect, Succ, Just, Node, Val, Add
```

**P2.** When would you use `type` and when `data`? Give one case where `type` is right,
one where it is wrong, and say what goes wrong.

**P3.** Draw the tree produced by `balance [1,2,3,4,5]`, given that `balance` splits at
`length xs `div` 2`. How many leaves does it have? Is it balanced by exercise 5's
definition?

**P4.** Write the truth table for `Imply`, all four rows. Then write `evalP`'s equation
for `Imply` in terms of `not`, `||` and recursive calls, and check it against your table.

**P5.** What does `deriving (Eq, Show)` write for
`data Shape = Circle Double | Rect Double Double`? Give the equations for `==` you would
have had to write by hand. Then say why you could not derive `Eq` for

```haskell
data Handler = Handler String (Int -> Int)
```

Answers in `../solutions/week07/PAPER.md`.

---

## 10. Coding exercises

```bash
./check.sh 7              # your code
./check.sh 7 --repl       # GHCi with your code loaded
```

**89 checks**, the biggest week yet — but the exercises are small and there are a lot of
them, rather than a few hard ones.

Order: 1 is the warm-up; do `:t Circle` in the REPL before anything else. 2 is the
important one — **write `addNat` without touching `Int`** or you have skipped the
chapter's main idea. 3 is short and changes how you'll write code from here. 4 and 5 are
the trees; do them back to back so the difference between them lands. 6 is the most
valuable single exercise in the week. 7 is syntax practice. 8 is the big finish — build
it bottom-up and test each of the five pieces in the REPL before combining them.

When all 89 are green, ask for an **idiom review**. The thing to ask about specifically:
whether any of your functions should have been written with `folde`, and whether your
`case`/guard choices match what the data is telling you.

---

## 11. Checklist

- [ ] I know `type` makes a synonym, `data` makes a new type, and why `type` can't recurse
- [ ] I can give the type of a constructor, and I know constructors are curried functions
- [ ] I can state "the shape of the data dictates the shape of the function"
- [ ] I wrote `addNat` with no arithmetic in it
- [ ] I can explain what `Maybe` buys over a crash, in terms of the type checker
- [ ] I can tell a node-valued tree from a leaf-valued one and say when I'd want each
- [ ] I know why `occurs` uses `compare` rather than three guards
- [ ] I can define a fold for a data type I declared
- [ ] I can say what `deriving (Eq, Show)` generates
- [ ] I know the difference between `data`, `class` and `instance`
- [ ] I know `Imply` is False in exactly one case
- [ ] All 89 checks pass

**Next week:** interactive programming — `IO`, and how a language with no side effects
manages to read the keyboard and write the screen without giving up purity.
