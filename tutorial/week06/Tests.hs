module Main where

import Check
import Exercises

main :: IO ()
main = runTests "Week 6 -- Hutton ch. 7"
  [ check "map' (+1)"           (map' (+1) [1,2,3 :: Int])    [2,3,4]
  , check "map' on []"          (map' (+1) ([] :: [Int]))     []
  , check "map' toUpper-ish"    (map' fromEnum "ab")          [97,98]
  , check "filter' even"        (filter' even [1,2,3,4 :: Int])  [2,4]
  , check "filter' none"        (filter' (> 9) [1,2 :: Int])  []
  , check "filter' on []"       (filter' even ([] :: [Int]))  []

  , check "all' even [2,4]"     (all' even [2,4 :: Int])      True
  , check "all' even [2,3]"     (all' even [2,3 :: Int])      False
  , check "all' on []"          (all' even ([] :: [Int]))     True
  , check "any' odd [2,4]"      (any' odd [2,4 :: Int])       False
  , check "any' odd [2,3]"      (any' odd [2,3 :: Int])       True
  , check "any' on []"          (any' odd ([] :: [Int]))      False
  , check "takeWhile' even"     (takeWhile' even [2,4,5,6 :: Int])  [2,4]
  , check "takeWhile' none"     (takeWhile' even [1,2 :: Int])      []
  , check "takeWhile' all"      (takeWhile' even [2,4 :: Int])      [2,4]
  , check "dropWhile' even"     (dropWhile' even [2,4,5,6 :: Int])  [5,6]
  , check "dropWhile' none"     (dropWhile' even [1,2 :: Int])      [1,2]
  , check "dropWhile' all"      (dropWhile' even [2,4 :: Int])      []

  , check "sumF [1,2,3]"        (sumF [1,2,3])                6
  , check "sumF []"             (sumF [])                     0
  , check "productF [1,2,3]"    (productF [1,2,3])            6
  , check "productF []"         (productF [])                 1
  , check "lengthF \"abc\""     (lengthF "abc")               3
  , check "lengthF []"          (lengthF ([] :: [Int]))       0
  , check "reverseF [1,2,3]"    (reverseF [1,2,3 :: Int])     [3,2,1]
  , check "reverseF \"abc\""    (reverseF "abc")              "cba"
  , check "reverseF []"         (reverseF ([] :: [Int]))      []
  , check "andF [True,False]"   (andF [True,False])           False
  , check "andF []"             (andF [])                     True

  , check "mapF (+1)"           (mapF (+1) [1,2,3 :: Int])    [2,3,4]
  , check "mapF on []"          (mapF (+1) ([] :: [Int]))     []
  , check "filterF even"        (filterF even [1,2,3,4 :: Int])  [2,4]
  , check "filterF on []"       (filterF even ([] :: [Int]))  []
  , check "mapF agrees map'"    (mapF (*3) [1,2,3 :: Int] == map' (*3) [1,2,3])  True

  , check "dec2int [2,3,4,5]"   (dec2int [2,3,4,5])           2345
  , check "dec2int [7]"         (dec2int [7])                 7
  , check "dec2int []"          (dec2int [])                  0
  , check "dec2int [0,0,1]"     (dec2int [0,0,1])             1

  , check "curry' fst 1 2"      (curry' fst (1 :: Int) (2 :: Int))  1
  , check "curry' snd 1 2"      (curry' snd (1 :: Int) (2 :: Int))  2
  , check "uncurry' (+) (3,4)"  (uncurry' (+) (3,4 :: Int))   7
  , check "map uncurry' (+)"    (map (uncurry' (+)) [(1,2),(3,4 :: Int)])  [3,7]
  , check "curry' . uncurry'"   (curry' (uncurry' (+)) (5 :: Int) (6 :: Int))  11

  , check "twice (+3) 1"        (twice (+3) (1 :: Int))       7
  , check "twice reverse"       (twice reverse [1,2 :: Int])  [1,2]
  , check "twice (*2) 3"        (twice (*2) (3 :: Int))       12
  , check "sumOfSqOfEvens"      (sumOfSquaresOfEvens [1,2,3,4])  20
  , check "sumOfSqOfEvens []"   (sumOfSquaresOfEvens [])      0
  , check "sumOfSqOfEvens odd"  (sumOfSquaresOfEvens [1,3,5])  0

  , check "bin2int [1,0,1,1]"   (bin2int [1,0,1,1])           13
  , check "bin2int []"          (bin2int [])                  0
  , check "bin2int [0,0,0,1]"   (bin2int [0,0,0,1])           8
  , check "int2bin 13"          (int2bin 13)                  [1,0,1,1]
  , check "int2bin 0"           (int2bin 0)                   []
  , check "int2bin 8"           (int2bin 8)                   [0,0,0,1]
  , check "bin2int . int2bin"   (map (bin2int . int2bin) [0..40])  [0..40]
  , check "make8 [1,0,1,1]"     (make8 [1,0,1,1])             [1,0,1,1,0,0,0,0]
  , check "make8 length"        (length (make8 []))           8
  , check "chop8 16 zeros"      (chop8 (replicate 16 0))
      [replicate 8 0, replicate 8 0]
  , check "chop8 []"            (chop8 [])                    []
  , check "encodeB \"abc\" len" (length (encodeB "abc"))      24
  , check "encodeB \"a\""       (encodeB "a")                 [1,0,0,0,0,1,1,0]
  , check "decodeB . encodeB"   (decodeB (encodeB "haskell")) "haskell"
  , check "decodeB . encodeB 2" (decodeB (encodeB "INF122 uib!"))  "INF122 uib!"
  , check "encodeB \"\""        (encodeB "")                  []

  , check "unfold countdown"    (unfold (== 10) id (+1) (0 :: Int))  [0..9]
  , check "unfold as id"        (unfold null head tail [1,2,3 :: Int])  [1,2,3]
  , check "mapU (+1)"           (mapU (+1) [1,2,3 :: Int])    [2,3,4]
  , check "mapU on []"          (mapU (+1) ([] :: [Int]))     []
  , check "iterateU (*2)"       (take 5 (iterateU (*2) (1 :: Int)))  [1,2,4,8,16]
  , check "iterateU (+1)"       (take 3 (iterateU (+1) (0 :: Int)))  [0,1,2]

  , check "altMap"              (altMap (+10) (+100) [0,1,2,3,4 :: Int])
      [10,101,12,103,14]
  , check "altMap []"           (altMap (+10) (+100) ([] :: [Int]))  []
  , check "altMap [0]"          (altMap (+10) (+100) [0 :: Int])     [10]
  , check "luhnDouble 3"        (luhnDouble 3)                6
  , check "luhnDouble 6"        (luhnDouble 6)                3
  , check "luhn [1,7,8,4]"      (luhn [1,7,8,4])              True
  , check "luhn [4,7,8,3]"      (luhn [4,7,8,3])              False
  , check "luhn 8 digits ok"    (luhn [1,7,8,4,1,7,8,4])      True
  , check "luhn 8 digits bad"   (luhn [1,7,8,4,1,7,8,5])      False
  , check "luhn [0,0,0,0]"      (luhn [0,0,0,0])              True
  ]
