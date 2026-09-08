# Week 7 — Paper exercise answers

## P1 — Constructor types

```haskell
Circle :: Double -> Shape
Rect   :: Double -> Double -> Shape
Succ   :: Nat -> Nat
Just   :: a -> Maybe a
Node   :: Tree a -> a -> Tree a -> Tree a
Val    :: Int -> Expr
Add    :: Expr -> Expr -> Expr
```

Two things worth stating explicitly, because both are exam-shaped:

**Constructors are curried, like every other function.** `Rect :: Double -> Double ->
Shape` has no comma, for the reason week 2 gave. So `Rect 2` is a perfectly good value
of type `Double -> Shape`, and `map (Rect 2) [3,4,5]` works.

**A recursive constructor mentions its own type.** `Succ :: Nat -> Nat` and
`Add :: Expr -> Expr -> Expr` are what make those types infinite — you can always wrap
one more layer. `Zero`, `Leaf` and `Val` are the ones that stop, which is why every
function over these types has a case for them.

Note also that `Node`'s type shows the *order* of its fields: subtree, value, subtree.
That ordering is why `flatten` visits left, value, right and comes out sorted.

## P2 — `type` versus `data`

**Use `type` when you want a shorter or more meaningful name for a structure that
already exists**, and you are happy for it to be interchangeable with the original:

```haskell
type Subst = [(Char, Bool)]
```

`Subst` documents intent, and every list function still works on it, which is what you
want here.

**`type` is wrong when you want the compiler to keep two things apart.** If you write

```haskell
type Pos  = (Int, Int)
type Size = (Int, Int)
```

then `Pos` and `Size` are *the same type*, and passing a size where a position belongs
typechecks silently. The bug you were hoping to catch is exactly the bug that gets
through. `data Pos = Pos Int Int` and `data Size = Size Int Int` make them distinct, at
the cost of having to wrap and unwrap.

**`type` is also wrong whenever the structure is recursive.** `type Tree = (Int, [Tree])`
is rejected with *"cycle in type synonym declarations"* — a synonym is expanded away at
compile time, and this expansion never finishes. Recursive shapes need `data`, whose
constructors give the compiler something finite to hold on to.

## P3 — `balance [1,2,3,4,5]`

`length [1..5] `div` 2` is 2, so the split is `[1,2]` and `[3,4,5]`. Recursing:

- `[1,2]` splits into `[1]` and `[2]` → `BNode (BLeaf 1) (BLeaf 2)`
- `[3,4,5]` splits into `[3]` and `[4,5]` → `BNode (BLeaf 3) (BNode (BLeaf 4) (BLeaf 5))`

```
              ●
           /     \
         ●         ●
        / \       / \
       1   2     3    ●
                     / \
                    4   5
```

```haskell
BNode (BNode (BLeaf 1) (BLeaf 2))
      (BNode (BLeaf 3) (BNode (BLeaf 4) (BLeaf 5)))
```

**Five leaves**, and **yes, it is balanced.** Check every node:

| node | left leaves | right leaves | difference |
|---|---|---|---|
| root | 2 | 3 | 1 ✓ |
| left child | 1 | 1 | 0 ✓ |
| right child | 1 | 2 | 1 ✓ |
| `BNode (BLeaf 4) (BLeaf 5)` | 1 | 1 | 0 ✓ |

Note the definition demands balance at **every** node, not only the root — which is why
`balanced` recurses into both subtrees rather than just comparing the two counts once.

## P4 — `Imply`

| `A` | `B` | `A → B` |
|:--:|:--:|:--:|
| False | False | **True** |
| False | True | **True** |
| True | False | **False** |
| True | True | **True** |

**An implication is false in exactly one case: a true antecedent with a false
consequent.** Everything else is true — including both rows where `A` is false, which is
the part that feels wrong the first time. "If the moon is cheese then I am the king" is
a true statement, because the premise never holds.

That single false row is what makes the definition so short:

```haskell
evalP s (Imply p q) = not (evalP s p) || evalP s q
```

Read it as "either the antecedent fails, or the consequent holds". Check it against the
table row by row: `not False || _` is True for the first two rows, `not True || False`
is False for the third, `not True || True` is True for the fourth. All four agree.

The common error is writing `evalP s p && evalP s q` — which is `And`, not `Imply`, and
makes `isTaut` reject valid arguments. Since both have the same type, nothing catches
it but the truth table.

## P5 — What `deriving` writes

For `data Shape = Circle Double | Rect Double Double`, `deriving Eq` generates
structural equality — same constructor, and all corresponding fields equal:

```haskell
instance Eq Shape where
  Circle r1   == Circle r2   = r1 == r2
  Rect w1 h1  == Rect w2 h2  = w1 == w2 && h1 == h2
  _           == _           = False        -- different constructors
```

and `deriving Show` generates a `show` that reproduces the constructor syntax, adding
parentheses where an argument needs them: `show (Rect 2 2)` is `"Rect 2.0 2.0"`. That is
why the test harness can print your values back at you legibly.

Note what derived `Eq` requires: **every field type must itself be in `Eq`**. `Double`
is, so `Shape` can derive it.

**Why `Handler` cannot derive `Eq`:**

> `data Handler = Handler String (Int -> Int)` has a field of function type. Derived
> equality would need to compare the two functions, and function types are not instances
> of `Eq` — deciding whether two functions agree on every input is not computable in
> general, as in week 2's paper exercise P2. GHC reports it as a missing
> `Eq (Int -> Int)` instance rather than as a rule about derivation, so read the error
> as "one of my fields isn't comparable" and look for the function.

The same argument rules out deriving `Show` and `Read` for it. `Ord` fails too, for the
extra reason that it requires `Eq` first.
