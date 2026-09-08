module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 9 -- Hutton ch. 15"
  [ check "take 4 ones"         (take 4 ones)                 [1,1,1,1]
  , check "take 1 ones"         (take 1 ones)                 [1]
  , check "take 6 ones"         (take 6 ones)                 [1,1,1,1,1,1]
  , check "take 4 nats"         (take 4 nats)                 [0,1,2,3]
  , check "nats !! 100"         (nats !! 100)                 100
  , check "take 4 (repeat' 7)"  (take 4 (repeat' 7))          [7,7,7,7]
  , check "repeat' on Char"     (take 3 (repeat' 'x'))        "xxx"
  , check "cycle' [1,2]"        (take 5 (cycle' [1,2 :: Int]))  [1,2,1,2,1]
  , check "cycle' one element"  (take 3 (cycle' [9 :: Int]))  [9,9,9]
  , check "cycle' \"ab\""       (take 5 (cycle' "ab"))        "ababa"

  , check "iterate' (*2)"       (take 5 (iterate' (*2) (1 :: Int)))  [1,2,4,8,16]
  , check "iterate' (+1)"       (take 3 (iterate' (+1) (0 :: Int)))  [0,1,2]
  , check "iterate' id"         (take 3 (iterate' id 'a'))    "aaa"
  , check "firstOver 100"       (firstOver 100 (iterate' (*2) 1))  128
  , check "firstOver 10 nats"   (firstOver 10 nats)           11
  , check "firstOver 0 nats"    (firstOver 0 nats)            1

  , check "take 8 fibs"         (take 8 fibs)                 [0,1,1,2,3,5,8,13]
  , check "take 2 fibs"         (take 2 fibs)                 [0,1]
  , check "fibN 0"              (fibN 0)                      0
  , check "fibN 1"              (fibN 1)                      1
  , check "fibN 10"             (fibN 10)                     55
  , check "fibN 30"             (fibN 30)                     832040
  , check "fibN 90 needs Integer" (fibN 90)                   2880067194370816120
  , check "firstFibOver 1000"   (firstFibOver 1000)           1597
  , check "firstFibOver 0"      (firstFibOver 0)              1
  , check "fibs is additive"    (take 6 (zipWith (+) fibs (tail fibs)))
      [1,2,3,5,8,13]

  , check "take 8 primes"       (take 8 primes)               [2,3,5,7,11,13,17,19]
  , check "primes !! 0"         (head primes)                 2
  , check "25th prime"          (primes !! 24)                97
  , check "primesBelow 20"      (primesBelow 20)              [2,3,5,7,11,13,17,19]
  , check "primesBelow 2"       (primesBelow 2)               []
  , check "primesBelow 3"       (primesBelow 3)               [2]
  , check "primesBelow 30"      (length (primesBelow 30))     10

  , check "anyInf on infinite"  (anyInf even nats)            True
  , check "anyInf finds 100"    (anyInf (== 100) nats)        True
  , check "anyInf finite False" (anyInf even [1,3,5 :: Int])  False
  , check "anyInf []"           (anyInf even ([] :: [Int]))   False
  , check "allInf on infinite"  (allInf (< 5) nats)           False
  , check "allInf finite True"  (allInf even [2,4 :: Int])    True
  , check "allInf []"           (allInf even ([] :: [Int]))   True
  , check "allInf stops early"  (allInf (< 3) nats)           False

  , check "sumStrict [1,2,3]"   (sumStrict [1,2,3])           6
  , check "sumStrict []"        (sumStrict [])                0
  , check "sumStrict negatives" (sumStrict [-1,1])            0
  , check "sumStrict 100k"      (sumStrict [1..100000])       5000050000
  , check "sumStrict = sum"     (sumStrict [1..5000] == sum [1..5000])  True

  , check "takeT 0"             (takeT 0 (repeatT 'a'))       ILeaf
  , check "replicateT 0"        (replicateT 0 'a')            ILeaf
  , check "replicateT 1"        (replicateT 1 'a')            (INode ILeaf 'a' ILeaf)
  , check "replicateT 2"        (replicateT 2 'a')
      (INode (INode ILeaf 'a' ILeaf) 'a' (INode ILeaf 'a' ILeaf))
  , check "takeT of infinite"   (takeT 1 (repeatT (7 :: Int)))
      (INode ILeaf 7 ILeaf)
  , check "depthT ILeaf"        (depthT (ILeaf :: ITree Int))  0
  , check "depthT replicateT 3" (depthT (replicateT 3 'a'))   3
  , check "depthT replicateT 5" (depthT (replicateT 5 'a'))   5
  , check "takeT caps depth"    (depthT (takeT 4 (repeatT 'a')))  4
  , check "takeT idempotent"    (takeT 2 (takeT 2 (repeatT 'a')) == takeT 2 (repeatT 'a'))
      True
  ]
