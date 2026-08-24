module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 1 -- Hutton ch. 1-2"
  [ check "myLast [1,2,3]"          (myLast [1,2,3 :: Int])        3
  , check "myLast \"abc\""          (myLast "abc")                 'c'
  , check "myLast [42]"             (myLast [42 :: Int])           42

  , check "myInit [1,2,3]"          (myInit [1,2,3 :: Int])        [1,2]
  , check "myInit \"abc\""          (myInit "abc")                 "ab"
  , check "myInit [42]"             (myInit [42 :: Int])           []

  , check "average [1,2,3,4]"       (average [1,2,3,4])            2.5
  , check "average [10]"            (average [10])                 10.0
  , check "average [1,2]"           (average [1,2])                1.5

  , check "productR [2,3,4]"        (productR [2,3,4])             24
  , check "productR []"             (productR [])                  1
  , check "productR [5]"            (productR [5])                 5

  , check "qsortDesc [3,1,2]"       (qsortDesc [3,1,2 :: Int])     [3,2,1]
  , check "qsortDesc []"            (qsortDesc ([] :: [Int]))      []
  , check "qsortDesc \"haskell\""   (qsortDesc "haskell")          "sllkhea"

  , check "thirdIndex [1,2,3,4]"    (thirdIndex [1,2,3,4 :: Int])  3
  , check "thirdHeads [1,2,3,4]"    (thirdHeads [1,2,3,4 :: Int])  3
  , check "thirdIndex \"abcd\""     (thirdIndex "abcd")            'c'
  , check "thirdHeads \"abcd\""     (thirdHeads "abcd")            'c'
  ]
