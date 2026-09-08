module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 5 -- Hutton ch. 6"
  [ check "fac 0"               (fac 0)                       1
  , check "fac 1"               (fac 1)                       1
  , check "fac 5"               (fac 5)                       120
  , check "fac (-1)"            (fac (-1))                    0
  , check "fac (-7)"            (fac (-7))                    0

  , check "sumdown 0"           (sumdown 0)                   0
  , check "sumdown 1"           (sumdown 1)                   1
  , check "sumdown 3"           (sumdown 3)                   6
  , check "sumdown 10"          (sumdown 10)                  55

  , check "expo 2 3"            (expo 2 3)                    8
  , check "expo 5 0"            (expo 5 0)                    1
  , check "expo 0 3"            (expo 0 3)                    0
  , check "expo 0 0"            (expo 0 0)                    1
  , check "expo 2 10"           (expo 2 10)                   1024

  , check "euclid 6 27"         (euclid 6 27)                 3
  , check "euclid 12 8"         (euclid 12 8)                 4
  , check "euclid 5 0"          (euclid 5 0)                  5
  , check "euclid 0 5"          (euclid 0 5)                  5
  , check "euclid 7 7"          (euclid 7 7)                  7
  , check "euclid 13 17"        (euclid 13 17)                1

  , check "and' [True,True]"    (and' [True,True])            True
  , check "and' [True,False]"   (and' [True,False])           False
  , check "and' []"             (and' [])                     True
  , check "concat' [[1,2],[3]]" (concat' [[1,2],[3 :: Int]])  [1,2,3]
  , check "concat' []"          (concat' ([] :: [[Int]]))     []
  , check "concat' [[],[1]]"    (concat' [[],[1 :: Int]])     [1]
  , check "replicate' 3 'x'"    (replicate' 3 'x')            "xxx"
  , check "replicate' 0 'x'"    (replicate' 0 'x')            ""
  , check "nth [1,2,3] 1"       (nth [1,2,3 :: Int] 1)        2
  , check "nth [1,2,3] 0"       (nth [1,2,3 :: Int] 0)        1
  , check "nth \"abc\" 2"       (nth "abc" 2)                 'c'
  , check "elem' 3 [1,2,3]"     (elem' (3 :: Int) [1,2,3])    True
  , check "elem' 9 [1,2,3]"     (elem' (9 :: Int) [1,2,3])    False
  , check "elem' 1 []"          (elem' (1 :: Int) [])         False

  , check "merge [2,5,6] [1,3,4]" (merge [2,5,6] [1,3,4 :: Int]) [1,2,3,4,5,6]
  , check "merge [] [1,2]"      (merge [] [1,2 :: Int])       [1,2]
  , check "merge [1,2] []"      (merge [1,2 :: Int] [])       [1,2]
  , check "merge [] []"         (merge ([] :: [Int]) [])      []
  , check "merge [1,1] [1]"     (merge [1,1] [1 :: Int])      [1,1,1]

  , check "halve [1..6]"        (halve [1,2,3,4,5,6 :: Int])  ([1,2,3],[4,5,6])
  , check "halve []"            (halve ([] :: [Int]))         ([],[])
  , check "msort [4,1,3,2]"     (msort [4,1,3,2 :: Int])      [1,2,3,4]
  , check "msort []"            (msort ([] :: [Int]))         []
  , check "msort [1]"           (msort [1 :: Int])            [1]
  , check "msort \"haskell\""   (msort "haskell")             "aehklls"
  , check "msort [3,1,3]"       (msort [3,1,3 :: Int])        [1,3,3]
  , check "msort 20 items"      (msort [20,19..1 :: Int])     [1..20]

  , check "sum' [1,2,3]"        (sum' [1,2,3])                6
  , check "sum' []"             (sum' [])                     0
  , check "take' 2 [1,2,3]"     (take' 2 [1,2,3 :: Int])      [1,2]
  , check "take' 0 [1,2,3]"     (take' 0 [1,2,3 :: Int])      []
  , check "take' 5 [1,2]"       (take' 5 [1,2 :: Int])        [1,2]
  , check "take' 2 []"          (take' 2 ([] :: [Int]))       []
  , check "take' (-1) [1,2]"    (take' (-1) [1,2 :: Int])     []
  , check "last' [1,2,3]"       (last' [1,2,3 :: Int])        3
  , check "last' [7]"           (last' [7 :: Int])            7
  , check "last' \"abc\""       (last' "abc")                 'c'

  , check "evens \"abcde\""     (evens "abcde")               "ace"
  , check "odds \"abcde\""      (odds "abcde")                "bd"
  , check "evens []"            (evens ([] :: [Int]))         []
  , check "odds []"             (odds ([] :: [Int]))          []
  , check "evens [1]"           (evens [1 :: Int])            [1]
  , check "odds [1]"            (odds [1 :: Int])             []
  ]
