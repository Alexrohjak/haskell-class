module Main where

import Check
import Exercises

-- Built by inserting 1, 8, 3, 5 in that order.
sampleTree :: Tree Int
sampleTree = foldr insertT Leaf [5,3,8,1]

pA, pB :: Prop
pA = And (Var 'A') (Not (Var 'A'))
pB = Imply (And (Var 'A') (Var 'B')) (Var 'A')

main :: IO ()
main = runTests "Week 7 -- Hutton ch. 8"
  [ check "area (Circle 1)"     (area (Circle 1))             pi
  , check "area (Rect 3 4)"     (area (Rect 3 4))             12.0
  , check "area (Rect 0 5)"     (area (Rect 0 5))             0.0
  , check "perimeter (Rect 3 4)" (perimeter (Rect 3 4))       14.0
  , check "perimeter (Circle 1)" (perimeter (Circle 1))       (2 * pi)
  , check "square 2"            (square 2)                    (Rect 2 2)
  , check "area (square 3)"     (area (square 3))             9.0

  , check "nat2int Zero"        (nat2int Zero)                0
  , check "nat2int 2"           (nat2int (Succ (Succ Zero)))  2
  , check "int2nat 0"           (int2nat 0)                   Zero
  , check "int2nat 2"           (int2nat 2)                   (Succ (Succ Zero))
  , check "nat round trip"      (map (nat2int . int2nat) [0..6])  [0..6]
  , check "addNat 2 3"          (nat2int (addNat (int2nat 2) (int2nat 3)))  5
  , check "addNat 0 4"          (nat2int (addNat Zero (int2nat 4)))         4
  , check "addNat 4 0"          (nat2int (addNat (int2nat 4) Zero))         4
  , check "addNat is Succ-built" (addNat (int2nat 1) (int2nat 1))
      (Succ (Succ Zero))
  , check "multNat 3 4"         (nat2int (multNat (int2nat 3) (int2nat 4)))  12
  , check "multNat 0 5"         (nat2int (multNat Zero (int2nat 5)))         0
  , check "multNat 5 0"         (nat2int (multNat (int2nat 5) Zero))         0

  , check "safeDiv 7 2"         (safeDiv 7 2)                 (Just 3)
  , check "safeDiv 7 0"         (safeDiv 7 0)                 Nothing
  , check "safeDiv 0 3"         (safeDiv 0 3)                 (Just 0)
  , check "safeHead []"         (safeHead ([] :: [Int]))      Nothing
  , check "safeHead [1]"        (safeHead [1 :: Int])         (Just 1)
  , check "safeHead \"ab\""     (safeHead "ab")               (Just 'a')
  , check "safeThird [1,2,3,4]" (safeThird [1,2,3,4 :: Int])  (Just 3)
  , check "safeThird [1,2]"     (safeThird [1,2 :: Int])      Nothing
  , check "safeThird []"        (safeThird ([] :: [Int]))     Nothing
  , check "mapMaybes"           (mapMaybes [Just 1, Nothing, Just (3 :: Int)])  [1,3]
  , check "mapMaybes none"      (mapMaybes ([Nothing, Nothing] :: [Maybe Int])) []
  , check "mapMaybes []"        (mapMaybes ([] :: [Maybe Int]))  []

  , check "insertT into Leaf"   (insertT (5 :: Int) Leaf)     (Node Leaf 5 Leaf)
  , check "occurs 3"            (occurs 3 sampleTree)         True
  , check "occurs 5"            (occurs 5 sampleTree)         True
  , check "occurs 9"            (occurs 9 sampleTree)         False
  , check "occurs in Leaf"      (occurs (1 :: Int) Leaf)      False
  , check "flatten is sorted"   (flatten sampleTree)          [1,3,5,8]
  , check "flatten Leaf"        (flatten (Leaf :: Tree Int))  []
  , check "flatten stays sorted" (flatten (foldr insertT Leaf [9,2,7,4,1 :: Int]))
      [1,2,4,7,9]
  , check "treeDepth Leaf"      (treeDepth (Leaf :: Tree Int))  0
  , check "treeDepth one node"  (treeDepth (insertT (1 :: Int) Leaf))  1
  , check "treeDepth sample"    (treeDepth sampleTree)        4
  , check "insert is idempotent" (flatten (insertT (3 :: Int) sampleTree))  [1,3,5,8]

  , check "leaves (BLeaf 1)"    (leaves (BLeaf (1 :: Int)))   1
  , check "leaves of 2"         (leaves (BNode (BLeaf 'a') (BLeaf 'b')))  2
  , check "balanced leaf"       (balanced (BLeaf (1 :: Int)))  True
  , check "balanced 3"          (balanced (BNode (BLeaf 1) (BNode (BLeaf 2) (BLeaf (3 :: Int)))))
      True
  , check "unbalanced 4"        (balanced (BNode (BLeaf 1) (BNode (BLeaf 2) (BNode (BLeaf 3) (BLeaf (4 :: Int))))))
      False
  , check "balance [1,2]"       (balance [1,2 :: Int])
      (BNode (BLeaf 1) (BLeaf 2))
  , check "balance [1]"         (balance [1 :: Int])          (BLeaf 1)
  , check "balance is balanced" (balanced (balance [1..7 :: Int]))  True
  , check "balance keeps all"   (leaves (balance [1..7 :: Int]))   7
  , check "balance 8 balanced"  (balanced (balance [1..8 :: Int]))  True

  , check "folde count Vals"    (folde (const 1) (+) (+) (Add (Val 2) (Val 3)))  2
  , check "folde to string len" (folde (length . show) (+) (+) (Val 42))  2
  , check "evalE 2+3"           (evalE (Add (Val 2) (Val 3)))  5
  , check "evalE 2+(3*4)"       (evalE (Add (Val 2) (Mul (Val 3) (Val 4))))  14
  , check "evalE (Val 7)"       (evalE (Val 7))               7
  , check "sizeE 2+3"           (sizeE (Add (Val 2) (Val 3)))  2
  , check "sizeE (Val 7)"       (sizeE (Val 7))               1
  , check "sizeE nested"        (sizeE (Add (Val 2) (Mul (Val 3) (Val 4))))  3

  , check "pretty (Circle 2)"   (pretty (Circle 2))           "circle r=2.0"
  , check "pretty (Rect 3 4)"   (pretty (Rect 3 4))           "rect 3.0x4.0"
  , check "pretty (Val 3)"      (pretty (Val 3))              "3"
  , check "pretty Add"          (pretty (Add (Val 1) (Val 2)))  "(1 + 2)"
  , check "pretty Mul"          (pretty (Mul (Val 1) (Val 2)))  "(1 * 2)"
  , check "pretty nested"       (pretty (Add (Val 1) (Mul (Val 2) (Val 3))))
      "(1 + (2 * 3))"
  , check "pretty True"         (pretty True)                 "yes"
  , check "pretty False"        (pretty False)                "no"

  , check "evalP Const"         (evalP [] (Const True))       True
  , check "evalP Var"           (evalP [('A',True)] (Var 'A'))  True
  , check "evalP Not"           (evalP [('A',True)] (Not (Var 'A')))  False
  , check "evalP And"           (evalP [('A',True),('B',False)] (And (Var 'A') (Var 'B')))
      False
  , check "evalP Imply T->F"    (evalP [('A',True),('B',False)] (Imply (Var 'A') (Var 'B')))
      False
  , check "evalP Imply F->F"    (evalP [('A',False),('B',False)] (Imply (Var 'A') (Var 'B')))
      True
  , check "varsP duplicates"    (varsP (And (Var 'A') (Var 'A')))  "AA"
  , check "varsP two"           (varsP (And (Var 'A') (Var 'B')))  "AB"
  , check "varsP Const"         (varsP (Const True))          ""
  , check "boolsP 0"            (boolsP 0)                    [[]]
  , check "boolsP 1"            (boolsP 1)                    [[False],[True]]
  , check "boolsP 2"            (boolsP 2)
      [[False,False],[False,True],[True,False],[True,True]]
  , check "boolsP 3 length"     (length (boolsP 3))           8
  , check "substs count"        (length (substs (And (Var 'A') (Var 'B'))))  4
  , check "substs dedups"       (length (substs (And (Var 'A') (Var 'A'))))  2
  , check "isTaut contradiction" (isTaut pA)                  False
  , check "isTaut valid"        (isTaut pB)                   True
  , check "isTaut A or not A"   (isTaut (Not (And (Var 'A') (Not (Var 'A')))))  True
  , check "isTaut Const True"   (isTaut (Const True))         True
  , check "isTaut bare Var"     (isTaut (Var 'A'))            False
  ]
