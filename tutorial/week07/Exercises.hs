-- | Week 7 — Hutton ch. 8: declaring types and classes.
--
--     ./check.sh 7
--
-- LEARNING OUTCOME #3: ikkje-muterbare datastrukturar. Up to now you have
-- borrowed the Prelude's vocabulary -- lists, tuples, Bool. This week you
-- define your own, and the language stops feeling like a list-processing
-- toolkit and starts feeling like a place to model a problem.
--
-- Every type below already has 'deriving (Eq, Show)' on it, so the harness can
-- compare and print your values. Read section 6 of LESSON.md for what that
-- line actually does.
module Exercises where

-- ---------------------------------------------------------------------------
-- Exercise 1  (your first data declaration)
--
-- A shape is EITHER a circle with a radius OR a rectangle with a width and a
-- height. Not both, and nothing else.
--
--   area (Circle 1)     ==  pi
--   area (Rect 3 4)     ==  12.0
--   perimeter (Rect 3 4) == 14.0
--
-- 'Circle' and 'Rect' are CONSTRUCTORS. They are ordinary functions that build
-- a Shape -- ask GHCi for ':t Circle' once you have loaded this file.
--
-- 'square' should build a Rect with equal sides, in one line, without
-- repeating the Rect constructor's arguments by hand more than you must.
-- ---------------------------------------------------------------------------

data Shape = Circle Double | Rect Double Double
  deriving (Eq, Show)

area :: Shape -> Double
area = undefined

perimeter :: Shape -> Double
perimeter = undefined

square :: Double -> Shape
square = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 8.1 — recursive types, the smallest possible one)
--
-- The natural numbers, built from nothing but "zero" and "add one".
--
--   Zero              is 0
--   Succ Zero         is 1
--   Succ (Succ Zero)  is 2
--
--   nat2int (Succ (Succ Zero))  ==  2
--   int2nat 2                   ==  Succ (Succ Zero)
--   nat2int (addNat (int2nat 2) (int2nat 3))  ==  5
--
-- Write 'addNat' WITHOUT converting to Int and back. It is three tokens on the
-- right-hand side of the recursive case, and it is the whole point of the
-- exercise: the structure of the data tells you the structure of the function.
--
-- Then 'multNat', defined in terms of addNat. Same rule -- no Ints.
-- ---------------------------------------------------------------------------

data Nat = Zero | Succ Nat
  deriving (Eq, Show)

nat2int :: Nat -> Int
nat2int = undefined

int2nat :: Int -> Nat
int2nat = undefined

addNat :: Nat -> Nat -> Nat
addNat = undefined

multNat :: Nat -> Nat -> Nat
multNat = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3  (Maybe, and the end of crashing)
--
-- In week 1 you wrote 'thirdHeads' and were told it crashes on short lists and
-- that this was fine "for now". Now is later.
--
--   safeDiv 7 2   ==  Just 3
--   safeDiv 7 0   ==  Nothing
--   safeHead []   ==  Nothing
--   safeHead [1]  ==  Just 1
--   safeThird [1,2,3,4]  ==  Just 3
--   safeThird [1,2]      ==  Nothing
--
-- 'Maybe' is just a data type -- 'data Maybe a = Nothing | Just a' -- and
-- nothing about it is magic. It moves failure from a CRASH into the RETURN
-- TYPE, where the type checker can force the caller to deal with it.
--
-- 'mapMaybes' keeps only the successes:
--   mapMaybes [Just 1, Nothing, Just 3]  ==  [1,3]
-- ---------------------------------------------------------------------------

safeDiv :: Int -> Int -> Maybe Int
safeDiv = undefined

safeHead :: [a] -> Maybe a
safeHead = undefined

safeThird :: [a] -> Maybe a
safeThird = undefined

mapMaybes :: [Maybe a] -> [a]
mapMaybes = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 8.2 — a binary search tree)
--
-- A tree is either empty, or a node with a left subtree, a value, and a right
-- subtree. In a SEARCH tree, everything left of a node is smaller and
-- everything right is larger.
--
--   insertT 5 Leaf                 ==  Node Leaf 5 Leaf
--   occurs 5 (insertT 5 Leaf)      ==  True
--   flatten (insertT 1 (insertT 2 Leaf))  ==  [1,2]
--   treeDepth Leaf                 ==  0
--
-- 'occurs' must use 'compare', which returns LT, EQ or GT in ONE comparison.
-- The naive version writes 'x == y', 'x < y' and 'x > y' as separate guards
-- and so compares up to twice per node. That doubling is Hutton 8.2's point.
--
-- 'flatten' returns the values in ORDER, which for a search tree falls out of
-- visiting left, then the value, then right. Do not sort anything.
-- ---------------------------------------------------------------------------

data Tree a = Leaf | Node (Tree a) a (Tree a)
  deriving (Eq, Show)

insertT :: Ord a => a -> Tree a -> Tree a
insertT = undefined

occurs :: Ord a => a -> Tree a -> Bool
occurs = undefined

flatten :: Tree a -> [a]
flatten = undefined

treeDepth :: Tree a -> Int
treeDepth = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 8.3 and 8.4 — a different tree, on purpose)
--
-- This tree keeps its values only at the LEAVES. Same word, different shape --
-- and noticing that "tree" is not one type but a family of them is half of
-- what this exercise teaches.
--
--   leaves (BLeaf 1)                    ==  1
--   leaves (BNode (BLeaf 1) (BLeaf 2))  ==  2
--
-- A tree is BALANCED if, at every node, the number of leaves on the two sides
-- differs by at most one.
--
--   balanced (BLeaf 1)                                  ==  True
--   balanced (BNode (BLeaf 1) (BNode (BLeaf 2) (BLeaf 3)))  ==  True
--   balanced (BNode (BLeaf 1) (BNode (BLeaf 2) (BNode (BLeaf 3) (BLeaf 4))))  == False
--
-- 'balance' turns a non-empty list into a balanced tree. Split the list in
-- half (week 3's 'halve' idea), build each side, join them.
--
--   balance [1,2]  ==  BNode (BLeaf 1) (BLeaf 2)
-- ---------------------------------------------------------------------------

data BTree a = BLeaf a | BNode (BTree a) (BTree a)
  deriving (Eq, Show)

leaves :: BTree a -> Int
leaves = undefined

balanced :: BTree a -> Bool
balanced = undefined

balance :: [a] -> BTree a
balance = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hutton 8.5 and 8.6 — a fold for your own type)
--
-- An arithmetic expression, as data:
--
--   Add (Val 2) (Mul (Val 3) (Val 4))    is    2 + (3 * 4)
--
-- 'folde f g h' replaces every 'Val' with f, every 'Add' with g, and every
-- 'Mul' with h -- exactly the constructor-replacement reading of foldr from
-- week 6, now for a type you declared yourself.
--
--   evalE (Add (Val 2) (Val 3))  ==  5
--   sizeE (Add (Val 2) (Val 3))  ==  2      -- how many Vals
--
-- Define BOTH evalE and sizeE using folde and nothing else. If you find
-- yourself pattern matching on Expr inside them, you have missed the exercise:
-- folde is the only place that should mention the constructors.
-- ---------------------------------------------------------------------------

data Expr = Val Int | Add Expr Expr | Mul Expr Expr
  deriving (Eq, Show)

folde :: (Int -> b) -> (b -> b -> b) -> (b -> b -> b) -> Expr -> b

folde f g h (Val n) = f n

folde f g h (Add x y) = g (folde f g h x) (folde f g h y)

folde f g h (Mul x y) = h (folde f g h x) (folde f g h y)

evalE :: Expr -> Int
evalE = folde (\n -> n) (+) (*)

sizeE :: Expr -> Int
sizeE = folde (\_ -> 1) (+) (+)

-- ---------------------------------------------------------------------------
-- Exercise 7  (a class of your own)
--
-- A class is a set of types that share an interface. Declare 'Pretty' with one
-- method, then give instances for three types.
--
--   pretty (Circle 2)   ==  "circle r=2.0"
--   pretty (Rect 3 4)   ==  "rect 3.0x4.0"
--   pretty (Val 3)      ==  "3"
--   pretty (Add (Val 1) (Val 2))  ==  "(1 + 2)"
--   pretty (Mul (Val 1) (Val 2))  ==  "(1 * 2)"
--   pretty True         ==  "yes"
--   pretty False        ==  "no"
--
-- The class declaration is written for you. Fill in the three instances.
-- 'show' is useful for turning a number into a String.
-- ---------------------------------------------------------------------------

class Pretty a where
  pretty :: a -> String

instance Pretty Shape where
  pretty = undefined

instance Pretty Expr where
  pretty = undefined

instance Pretty Bool where
  pretty = undefined

-- ---------------------------------------------------------------------------
-- Exercise 8  (the tautology checker — the chapter's worked example)
--
-- A proposition is a constant, a variable, a negation, a conjunction, or an
-- implication. A TAUTOLOGY is one that is true under every assignment of its
-- variables.
--
--   p1 = And (Var 'A') (Not (Var 'A'))            -- never true
--   p2 = Imply (And (Var 'A') (Var 'B')) (Var 'A')  -- always true
--
--   isTaut p1  ==  False
--   isTaut p2  ==  True
--
-- Five small pieces, each of which is easy on its own:
--
--   evalP s p    -- the value of p, given a substitution s
--   varsP p      -- every variable in p, WITH duplicates
--   boolsP n     -- all 2^n lists of n Bools, False-first
--   substs p     -- every assignment of p's variables
--   isTaut p     -- true under all of them
--
--   varsP (And (Var 'A') (Var 'A'))  ==  "AA"
--   boolsP 2  ==  [[False,False],[False,True],[True,False],[True,True]]
--   length (substs (And (Var 'A') (Var 'B')))  ==  4
--
-- 'lookup' from the Prelude finds a value in a list of pairs and returns a
-- Maybe -- which you met in exercise 3. 'rmdups' is written for you.
--
-- The implication A -> B is False in exactly one case. Work out which before
-- you write it.
-- ---------------------------------------------------------------------------

data Prop
  = Const Bool
  | Var Char
  | Not Prop
  | And Prop Prop
  | Imply Prop Prop
  deriving (Eq, Show)

type Subst = [(Char, Bool)]

rmdups :: Eq a => [a] -> [a]
rmdups []     = []
rmdups (x:xs) = x : rmdups (filter (/= x) xs)

evalP :: Subst -> Prop -> Bool
evalP = undefined

varsP :: Prop -> [Char]
varsP = undefined

boolsP :: Int -> [[Bool]]
boolsP = undefined

substs :: Prop -> [Subst]
substs = undefined

isTaut :: Prop -> Bool
isTaut = undefined
