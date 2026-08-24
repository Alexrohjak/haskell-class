module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 2 -- Hutton ch. 3"
  [ checkThat "bools is a non-empty [Bool]"      (not (null bools))
  , checkThat "nums is a non-empty [[Int]]"      (not (null nums))
  , checkThat "nums really is a list of lists"   (all (\xs -> length xs == length xs) nums)

  , check "add3 1 2 3"            (add3 1 2 3)                 6
  , check "add3 0 0 0"            (add3 0 0 0)                 0
  , check "add3 partially applied" ((add3 1 2) 3)              6

  , check "copy 'x'"              (copy 'x')                   ('x','x')
  , check "copy [1,2]"            (copy [1,2 :: Int])          ([1,2],[1,2])

  , check "apply (+1) 5"          (apply (+1) (5 :: Int))      6
  , check "apply reverse"         (apply reverse "abc")        "cba"

  , check "second [1,2,3]"        (second [1,2,3 :: Int])      2
  , check "second \"abc\""        (second "abc")               'b'
  , check "swap (1,'a')"          (swap (1 :: Int, 'a'))       ('a', 1)
  , check "swap ('a',True)"       (swap ('a', True))           (True, 'a')
  , check "pair 1 'a'"            (pair (1 :: Int) 'a')        (1, 'a')
  , check "double 4"              (double (4 :: Int))          8
  , check "double 2.5"            (double (2.5 :: Double))     5.0
  , check "palindrome \"racecar\"" (palindrome "racecar")      True
  , check "palindrome [1,2,3]"    (palindrome [1,2,3 :: Int])  False
  , check "palindrome []"         (palindrome ([] :: [Int]))   True
  , check "twice (*2) 3"          (twice (*2) (3 :: Int))      12
  , check "twice tail [1,2,3,4]"  (twice tail [1,2,3,4 :: Int]) [3,4]

  , check "largest [3,1,4,1,5]"   (largest [3,1,4,1,5 :: Int]) 5
  , check "largest \"haskell\""   (largest "haskell")          's'
  , check "largest [7]"           (largest [7 :: Int])         7

  , check "roundTrip 3"           (roundTrip (3 :: Int))       3
  , check "roundTrip [True,False]" (roundTrip [True,False])    [True,False]
  , check "roundTrip (1,'a')"     (roundTrip (1 :: Int, 'a'))  (1,'a')

  , check "describe 3 5"          (describe (3 :: Int) 5)      "3 is smaller than 5"
  , check "describe 5 3"          (describe (5 :: Int) 3)      "5 is bigger than 3"
  , check "describe 'a' 'a'"      (describe 'a' 'a')           "'a' is equal to 'a'"
  ]
