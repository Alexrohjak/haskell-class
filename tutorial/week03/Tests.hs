module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 3 -- Hutton ch. 4"
  [ check "halve [1..6]"        (halve [1,2,3,4,5,6 :: Int])  ([1,2,3],[4,5,6])
  , check "halve []"            (halve ([] :: [Int]))         ([],[])
  , check "halve \"abcd\""      (halve "abcd")                ("ab","cd")

  , check "thirdPat [1,2,3,4]"  (thirdPat [1,2,3,4 :: Int])   3
  , check "thirdPat \"abcd\""   (thirdPat "abcd")             'c'
  , check "thirdPat [1,2,3]"    (thirdPat [1,2,3 :: Int])     3

  , check "safetailCond []"     (safetailCond ([] :: [Int]))  []
  , check "safetailCond [1,2,3]" (safetailCond [1,2,3 :: Int]) [2,3]
  , check "safetailGuard []"    (safetailGuard ([] :: [Int])) []
  , check "safetailGuard [1,2,3]" (safetailGuard [1,2,3 :: Int]) [2,3]
  , check "safetailPat []"      (safetailPat ([] :: [Int]))   []
  , check "safetailPat [1,2,3]" (safetailPat [1,2,3 :: Int])  [2,3]
  , check "safetailPat [9]"     (safetailPat [9 :: Int])      []

  , check "myOr True True"      (myOr True True)              True
  , check "myOr True False"     (myOr True False)             True
  , check "myOr False True"     (myOr False True)             True
  , check "myOr False False"    (myOr False False)            False
  , check "myOr2 True False"    (myOr2 True False)            True
  , check "myOr2 False False"   (myOr2 False False)           False
  , check "myOr2 False True"    (myOr2 False True)            True

  , check "myAnd True True"     (myAnd True True)             True
  , check "myAnd True False"    (myAnd True False)            False
  , check "myAnd False True"    (myAnd False True)            False
  , check "myAnd False False"   (myAnd False False)           False

  , check "mult3 2 3 4"         (mult3 2 3 4)                 24
  , check "mult3 partially"     ((mult3 2 3) 4)               24
  , check "mult3 0 9 9"         (mult3 0 9 9)                 0

  , check "luhnDouble 3"        (luhnDouble 3)                6
  , check "luhnDouble 6"        (luhnDouble 6)                3
  , check "luhnDouble 0"        (luhnDouble 0)                0
  , check "luhnDouble 5"        (luhnDouble 5)                1
  , check "luhn 1 7 8 4"        (luhn 1 7 8 4)                True
  , check "luhn 4 7 8 3"        (luhn 4 7 8 3)                False
  , check "luhn 0 0 0 0"        (luhn 0 0 0 0)                True

  , check "grade 95"            (grade 95)                    'A'
  , check "grade 90"            (grade 90)                    'A'
  , check "grade 85"            (grade 85)                    'B'
  , check "grade 70"            (grade 70)                    'C'
  , check "grade 60"            (grade 60)                    'D'
  , check "grade 50"            (grade 50)                    'E'
  , check "grade 49"            (grade 49)                    'F'
  , check "grade 0"             (grade 0)                     'F'
  ]
