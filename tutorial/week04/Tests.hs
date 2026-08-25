module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 4 -- Hutton ch. 5"
  [ check "sumSquares 100"      (sumSquares 100)            338350
  , check "sumSquares 3"        (sumSquares 3)              14
  , check "sumSquares 1"        (sumSquares 1)              1
  , check "sumSquares 0"        (sumSquares 0)              0

  , check "grid 1 2"            (grid 1 2)                  [(0,0),(0,1),(0,2),(1,0),(1,1),(1,2)]
  , check "grid 0 0"            (grid 0 0)                   [(0,0)]
  , check "grid 2 1"            (grid 2 1)                   [(0,0),(0,1),(1,0),(1,1),(2,0),(2,1)]

  , check "square 2"            (square 2)                   [(0,1),(0,2),(1,0),(1,2),(2,0),(2,1)]
  , check "square 0"            (square 0)                   []
  , check "square 1"            (square 1)                   [(0,1),(1,0)]

  , check "replicate' 3 True"   (replicate' 3 True)          [True,True,True]
  , check "replicate' 0 'x'"    (replicate' 0 'x')           ""
  , check "replicate' 2 [1]"    (replicate' 2 [1 :: Int])    [[1],[1]]

  , check "pyths 10"            (pyths 10)                   [(3,4,5),(4,3,5),(6,8,10),(8,6,10)]
  , check "pyths 5"             (pyths 5)                    [(3,4,5),(4,3,5)]
  , check "pyths 2"             (pyths 2)                    []

  , check "factors 15"          (factors 15)                 [1,3,5,15]
  , check "factors 7"           (factors 7)                  [1,7]
  , check "factors 1"           (factors 1)                  [1]
  , check "perfects 500"        (perfects 500)               [6,28,496]
  , check "perfects 5"          (perfects 5)                 []

  , check "pairs [1,2,3,4]"     (pairs [1,2,3,4 :: Int])     [(1,2),(2,3),(3,4)]
  , check "pairs [1]"           (pairs [1 :: Int])           []
  , check "pairs \"abc\""       (pairs "abc")                [('a','b'),('b','c')]
  , check "sorted [1,2,3]"      (sorted [1,2,3 :: Int])      True
  , check "sorted [1,3,2]"      (sorted [1,3,2 :: Int])      False
  , check "sorted [2,2]"        (sorted [2,2 :: Int])        True
  , check "sorted []"           (sorted ([] :: [Int]))       True
  , check "sorted \"abc\""      (sorted "abc")               True

  , check "positions False"     (positions False [True,False,True,False]) [1,3]
  , check "positions 'l'"       (positions 'l' "hello")      [2,3]
  , check "positions 9"         (positions (9 :: Int) [1,2,3]) []
  , check "positions 'h'"       (positions 'h' "hello")      [0]

  , check "scalarproduct"       (scalarproduct [1,2,3] [4,5,6]) 32
  , check "scalarproduct []"    (scalarproduct [] [])           0
  , check "scalarproduct ragged" (scalarproduct [1,2] [4,5,6])  14

  , check "let2int 'a'"         (let2int 'a')                0
  , check "let2int 'z'"         (let2int 'z')                25
  , check "int2let 0"           (int2let 0)                  'a'
  , check "int2let 25"          (int2let 25)                 'z'
  , check "shift 3 'a'"         (shift 3 'a')                'd'
  , check "shift 3 'z'"         (shift 3 'z')                'c'
  , check "shift 3 ' '"         (shift 3 ' ')                ' '
  , check "shift 3 'A'"         (shift 3 'A')                'A'
  , check "shift 0 'q'"         (shift 0 'q')                'q'
  , check "shift (-3) 'a'"      (shift (-3) 'a')             'x'
  , check "encode 3"            (encode 3 "haskell is fun")  "kdvnhoo lv ixq"
  , check "encode (-3)"         (encode (-3) "kdvnhoo lv ixq") "haskell is fun"
  , check "encode 3 round-trip" (encode (-3) (encode 3 "attack at dawn")) "attack at dawn"
  , check "encode 3 \"\""       (encode 3 "")                ""
  ]
