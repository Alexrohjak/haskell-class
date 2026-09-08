-- | Week 7 reference solutions.
module Exercises where

-- Exercise 1. Two constructors, so two equations.
data Shape = Circle Double | Rect Double Double
  deriving (Eq, Show)

area :: Shape -> Double
area (Circle r) = pi * r * r
area (Rect w h) = w * h

perimeter :: Shape -> Double
perimeter (Circle r) = 2 * pi * r
perimeter (Rect w h) = 2 * (w + h)

-- A square is a rectangle whose sides agree -- no new constructor needed.
square :: Double -> Shape
square n = Rect n n

-- Exercise 2. The shape of the data dictates the shape of the function.
data Nat = Zero | Succ Nat
  deriving (Eq, Show)

nat2int :: Nat -> Int
nat2int Zero     = 0
nat2int (Succ n) = 1 + nat2int n

int2nat :: Int -> Nat
int2nat n
  | n <= 0    = Zero
  | otherwise = Succ (int2nat (n - 1))

-- Peel a Succ off the first argument and put it back on the result. No
-- arithmetic anywhere: the recursion IS the addition.
addNat :: Nat -> Nat -> Nat
addNat Zero     n = n
addNat (Succ m) n = Succ (addNat m n)

multNat :: Nat -> Nat -> Nat
multNat Zero     _ = Zero
multNat (Succ m) n = addNat n (multNat m n)

-- Exercise 3. Failure moves from a crash into the return type.
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv m n = Just (m `div` n)

safeHead :: [a] -> Maybe a
safeHead []    = Nothing
safeHead (x:_) = Just x

safeThird :: [a] -> Maybe a
safeThird (_:_:x:_) = Just x
safeThird _         = Nothing

mapMaybes :: [Maybe a] -> [a]
mapMaybes ms = [x | Just x <- ms]

-- Exercise 4. A binary search tree.
data Tree a = Leaf | Node (Tree a) a (Tree a)
  deriving (Eq, Show)

insertT :: Ord a => a -> Tree a -> Tree a
insertT x Leaf = Node Leaf x Leaf
insertT x t@(Node l y r) = case compare x y of
  LT -> Node (insertT x l) y r
  EQ -> t
  GT -> Node l y (insertT x r)

-- One 'compare' per node instead of up to two comparisons. On a deep tree that
-- halves the work, which is the whole of Hutton 8.2.
occurs :: Ord a => a -> Tree a -> Bool
occurs _ Leaf = False
occurs x (Node l y r) = case compare x y of
  LT -> occurs x l
  EQ -> True
  GT -> occurs x r

-- Left, value, right. For a search tree that is sorted order, for free.
flatten :: Tree a -> [a]
flatten Leaf         = []
flatten (Node l x r) = flatten l ++ [x] ++ flatten r

treeDepth :: Tree a -> Int
treeDepth Leaf         = 0
treeDepth (Node l _ r) = 1 + max (treeDepth l) (treeDepth r)

-- Exercise 5. Values at the leaves only -- a different type with the same name.
data BTree a = BLeaf a | BNode (BTree a) (BTree a)
  deriving (Eq, Show)

leaves :: BTree a -> Int
leaves (BLeaf _)   = 1
leaves (BNode l r) = leaves l + leaves r

-- Balanced everywhere, not just at the root: both subtrees must themselves be
-- balanced, which is why the recursive calls are there.
balanced :: BTree a -> Bool
balanced (BLeaf _)   = True
balanced (BNode l r) =
  abs (leaves l - leaves r) <= 1 && balanced l && balanced r

balance :: [a] -> BTree a
balance [x] = BLeaf x
balance xs  = BNode (balance ls) (balance rs)
  where (ls, rs) = splitAt (length xs `div` 2) xs

-- Exercise 6. A fold for a type you declared: replace each constructor with a
-- function of the same arity.
data Expr = Val Int | Add Expr Expr | Mul Expr Expr
  deriving (Eq, Show)

folde :: (Int -> b) -> (b -> b -> b) -> (b -> b -> b) -> Expr -> b
folde f _ _ (Val n)   = f n
folde f g h (Add x y) = g (folde f g h x) (folde f g h y)
folde f g h (Mul x y) = h (folde f g h x) (folde f g h y)

-- Replace Val with itself and the operators with real arithmetic.
evalE :: Expr -> Int
evalE = folde id (+) (*)

-- Replace every Val with 1 and both operators with addition: that counts them.
sizeE :: Expr -> Int
sizeE = folde (const 1) (+) (+)

-- Exercise 7. One interface, three types.
class Pretty a where
  pretty :: a -> String

instance Pretty Shape where
  pretty (Circle r) = "circle r=" ++ show r
  pretty (Rect w h) = "rect " ++ show w ++ "x" ++ show h

instance Pretty Expr where
  pretty (Val n)   = show n
  pretty (Add x y) = "(" ++ pretty x ++ " + " ++ pretty y ++ ")"
  pretty (Mul x y) = "(" ++ pretty x ++ " * " ++ pretty y ++ ")"

instance Pretty Bool where
  pretty True  = "yes"
  pretty False = "no"

-- Exercise 8. The tautology checker.
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

-- One equation per constructor, and each one recurses on its own children.
evalP :: Subst -> Prop -> Bool
evalP _ (Const b)   = b
evalP s (Var x)     = maybe False id (lookup x s)
evalP s (Not p)     = not (evalP s p)
evalP s (And p q)   = evalP s p && evalP s q
evalP s (Imply p q) = not (evalP s p) || evalP s q

-- Duplicates are kept here; substs removes them once, at the end.
varsP :: Prop -> [Char]
varsP (Const _)   = []
varsP (Var x)     = [x]
varsP (Not p)     = varsP p
varsP (And p q)   = varsP p ++ varsP q
varsP (Imply p q) = varsP p ++ varsP q

-- 2^n lists. Take every list of n-1 Bools, and put False in front of a copy
-- and True in front of another. False-first gives the order the tests expect.
boolsP :: Int -> [[Bool]]
boolsP 0 = [[]]
boolsP n = map (False :) bss ++ map (True :) bss
  where bss = boolsP (n - 1)

substs :: Prop -> [Subst]
substs p = map (zip vs) (boolsP (length vs))
  where vs = rmdups (varsP p)

isTaut :: Prop -> Bool
isTaut p = and [evalP s p | s <- substs p]
