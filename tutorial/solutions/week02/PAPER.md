# Week 2 — Paper exercise answers

## P1 — Types (Hutton 3.1)

```haskell
['a','b','c']            :: [Char]              -- i.e. String
('a','b','c')            :: (Char, Char, Char)
[(False,'0'),(True,'1')] :: [(Bool, Char)]
([False,True],['0','1']) :: ([Bool], [Char])
[tail, init, reverse]    :: [[a] -> [a]]
```

The last one is the one to dwell on. A list must have elements of a *single* type,
so all three functions must share a type. Individually:

```haskell
tail    :: [a] -> [a]
init    :: [a] -> [a]
reverse :: [a] -> [a]
```

They already agree, so the list is a **list of functions from lists to lists**. Note
this list *has* a type even though `Eq` and `Show` don't apply to it — you can hold
functions in a data structure, you just can't compare or print them.

## P2 — Why function types aren't in `Eq` (Hutton 3.4)

> Two functions are equal when they produce the same result for every possible
> argument. For most types the argument space is enormous or infinite — comparing
> two functions of type `Integer -> Integer` would require infinitely many checks —
> so equality is not computable in general. Haskell therefore provides no `Eq`
> instance for function types, rather than offering one that only sometimes
> terminates or one that compares memory addresses and gives mathematically wrong
> answers.

Worth adding for full marks: it *is* feasible for functions whose argument type is
finite and small (e.g. `Bool -> Bool`, only four such functions exist), but Haskell
doesn't special-case it.

## P3 — Parenthesising `->`

`->` is right-associative, so missing parentheses always group to the right:

```haskell
a -> b -> c -> d      ==  a -> (b -> (c -> d))
(a -> b) -> c         ==  (a -> b) -> c          -- already explicit; the parens
                                                 -- here are NOT redundant
a -> (b -> c) -> d    ==  a -> ((b -> c) -> d)
```

The middle one is the point of the exercise: `(a -> b) -> c` takes a *function* as
its argument, whereas `a -> b -> c` takes two values. Removing those parentheses
changes the meaning completely.

## P4 — Partial application

Given `f :: Int -> Bool -> Char -> String`, i.e.
`Int -> (Bool -> (Char -> String))`:

```haskell
f 1          :: Bool -> Char -> String
f 1 True     :: Char -> String
f 1 True 'x' :: String
```

Each argument supplied peels off exactly one arrow, from the left.

## P5 — Which are type errors?

```haskell
[1, 2, 'a']      -- ERROR. A list needs one element type; 1 and 2 could be Char-ish
                 -- only if Char were numeric, and it isn't. GHC reports
                 -- "No instance for (Num Char)".

(1, 2, 'a')      -- FINE. :: (Num a, Num b) => (a, b, Char). Tuples permit mixed
                 -- element types.

[[1,2],[3]]      -- FINE. :: Num a => [[a]]. Inner lists may have different
                 -- LENGTHS -- only the types must match.

[[1,2],['a']]    -- ERROR. Element types are [Num a => a] and [Char], which differ.
```

The lesson in the last two: for lists, **length is free, type is not**.
