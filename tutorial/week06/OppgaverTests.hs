module Main where

import Check
import Oppgaver

-- The sheet's own definition of cp (oppgave 1), used as the specification.
cpSpec :: [[a]] -> [[a]]
cpSpec [] = [[]]
cpSpec (xs:xss) = [ x:ys | x <- xs, ys <- cpSpec xss ]

-- Some non-empty lists for oppgave 4, written out by hand.
l1, l2, l3, l5 :: List Int
l1 = Wrap 7
l2 = Cons 1 (Wrap 2)
l3 = Cons 1 (Cons 2 (Wrap 3))
l5 = Cons 5 (Cons 4 (Cons 3 (Cons 2 (Wrap 1))))

ls :: List String
ls = Cons "a" (Cons "b" (Wrap "c"))

-- Nats for nat2Int, built from Z by n applications of S.
nat :: Int -> Nat
nat n = iterate S Z !! n

main :: IO ()
main = runTests "Week 6 -- oppgaver uke6"
  [ check "cp []"                          (cp ([] :: [[Int]]))              [[]]
  , check "cp [[1,2],[3,4]]"               (cp [[1,2],[3,4 :: Int]])         [[1,3],[1,4],[2,3],[2,4]]
  , check "cp [[1,2,3]]"                   (cp [[1,2,3 :: Int]])             [[1],[2],[3]]
  , check "cp [\"ab\",\"cd\",\"e\"]"       (cp ["ab","cd","e"])              ["ace","ade","bce","bde"]
  , check "cp [[1,2],[]]"                  (cp [[1,2],[] :: [Int]])          []
  , check "cp [[],[1,2]]"                  (cp [[],[1,2 :: Int]])            []
  , check "cp [[]]"                        (cp [[] :: [Int]])                []
  , check "length (cp [[1,2],[3,4,5],[6,7]])"
      (length (cp [[1,2],[3,4,5],[6,7 :: Int]]))                            12
  , checkThat "cp xss == the sheet's cp xss, on several inputs"
      (and [ cp xss == cpSpec xss
           | xss <- [ [], [[1]], [[1,2],[3]], [[1],[2],[3]], [[1,2,3],[4,5],[6,7,8]]
                    , [[0,1],[0,1],[0,1],[0,1 :: Int]], [[1,2],[],[3]] ] ])

  , check "nat2Int zero"                   (nat2Int zero)                    0
  , check "nat2Int one"                    (nat2Int one)                     1
  , check "nat2Int seven"                  (nat2Int seven)                   7
  , check "nat2Int Z"                      (nat2Int Z)                       0
  , check "nat2Int (S (S (S Z)))"          (nat2Int (S (S (S Z))))           3
  , checkThat "nat2Int (k S's around Z) == k, for 0..100"
      (and [ nat2Int (nat k) == k | k <- [0..100] ])

  , check "foldL Wrap Cons (Wrap 7)"       (foldL Wrap Cons l1)              l1
  , check "foldL Wrap Cons (Cons 1 (Wrap 2))"
      (foldL Wrap Cons l2)                                                  l2
  , check "foldL Wrap Cons (Cons 1 (Cons 2 (Wrap 3)))"
      (foldL Wrap Cons l3)                                                  l3
  , check "foldL Wrap Cons on 5 elements"  (foldL Wrap Cons l5)              l5
  , check "foldL Wrap Cons on Strings"     (foldL Wrap Cons ls)              ls

  , check "clist [1,2,3]"                  (clist [1,2,3 :: Int])            (Cons 1 (Cons 2 (Wrap 3)))
  , check "clist [7]"                      (clist [7 :: Int])                (Wrap 7)
  , check "clist \"ab\""                   (clist "ab")                      (Cons 'a' (Wrap 'b'))
  , check "clist [5,4,3,2,1]"              (clist [5,4,3,2,1 :: Int])        l5

  , check "list (Cons 1 (Cons 2 (Wrap 3)))" (list l3)                        [1,2,3]
  , check "list (Wrap 7)"                  (list l1)                         [7]
  , check "list (Cons 1 (Wrap 2))"         (list l2)                         [1,2]
  , check "list on Strings"                (list ls)                         ["a","b","c"]

  , checkThat "list (clist xs) == xs, for [1..n], n = 1..30"
      (and [ list (clist xs) == xs | n <- [1..30 :: Int], let xs = [1..n] ])
  , checkThat "clist (list l) == l, for the lists above"
      (and [ clist (list l) == l | l <- [l1, l2, l3, l5] ])
  ]
