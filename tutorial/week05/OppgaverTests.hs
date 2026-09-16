module Main where

import Check
import Oppgaver

-- Sets built from the sheet's three operations, via the plumbing in
-- Oppgaver.hs. Set has no Show, so every set check is a checkThat.
fra :: [a] -> Set a
fra = foldr (sumM . enM) tomM

s12, s21, s123, s14 :: Set Int
s12  = fra [1,2]
s21  = sumM (enM 2) (enM 1)
s123 = sumM (fra [2,1]) (enM 3)
s14  = fra [1,4]

tom :: Set Int
tom = tomM

main :: IO ()
main = runTests "Week 5 -- oppgaver uke5"
  [ check "zipW (+) [4,5,6,7] [1,2,3]"     (zipW (+) [4,5,6,7] [1,2,3 :: Int])  [5,7,9]
  , check "zipW (-) [4,5,6,7] [1,2,5]"     (zipW (-) [4,5,6,7] [1,2,5 :: Int])  [3,3,1]
  , check "zipW (+) [1,2] [10,20,30]"      (zipW (+) [1,2] [10,20,30 :: Int])   [11,22]
  , check "zipW (+) [] [1,2]"              (zipW (+) [] [1,2 :: Int])           []
  , check "zipW (+) [1,2] []"              (zipW (+) [1,2] [] :: [Int])         []
  , check "zipW (,) \"ab\" [True,False]"   (zipW (,) "ab" [True,False])         [('a',True),('b',False)]
  , check "zipW (+) [1..] [1,2]"           (zipW (+) [1..] [1,2 :: Int])        [2,4]
  , check "zipW (+) [1,2] [1..]"           (zipW (+) [1,2 :: Int] [1..])        [2,4]

  , check "zip' [1,2,3] \"ab\""            (zip' [1,2,3 :: Int] "ab")           [(1,'a'),(2,'b')]
  , check "zip' \"\" [1]"                  (zip' "" [1 :: Int])                 []

  , check "strToInt \"2\""                 (strToInt "2")                       2
  , check "strToInt \"1398\""              (strToInt "1398")                    1398
  , check "strToInt \"0\""                 (strToInt "0")                       0
  , check "strToInt \"1000\""              (strToInt "1000")                    1000
  , check "strToInt \"007\""               (strToInt "007")                     7
  , check "strToIntF \"2\""                (strToIntF "2")                      2
  , check "strToIntF \"1398\""             (strToIntF "1398")                   1398
  , check "strToIntF \"0\""                (strToIntF "0")                      0
  , check "strToIntF \"1000\""             (strToIntF "1000")                   1000
  , check "strToIntF \"007\""              (strToIntF "007")                    7
  , checkThat "strToInt (show n) == n, for 0..500"
      (and [ strToInt (show n) == n | n <- [0..500] ])
  , checkThat "strToIntF (show n) == n, for 0..500"
      (and [ strToIntF (show n) == n | n <- [0..500] ])

  , check "poly [3,1,1] 2"                 (poly [3,1,1] 2)                     15
  , check "poly [5,0,2] 3"                 (poly [5,0,2] 3)                     47
  , check "poly [7] 5"                     (poly [7] 5)                         7
  , check "poly [1,0,0,0] 2"               (poly [1,0,0,0] 2)                   8
  , check "poly [3,1,1] 0"                 (poly [3,1,1] 0)                     1
  , check "poly [2,-3] 4"                  (poly [2,-3] 4)                      5

  , check "kompress \"aababbccc\""         (kompress "aababbccc")               "ababc"
  , check "kompress [1,1,1,2,2,2]"         (kompress [1,1,1,2,2,2 :: Int])      [1,2]
  , check "kompress \"\""                  (kompress "")                        ""
  , check "kompress \"a\""                 (kompress "a")                       "a"
  , check "kompress \"aaaa\""              (kompress "aaaa")                    "a"
  , check "kompress \"abba\""              (kompress "abba")                    "aba"

  , checkThat "med 1 {1,2}"                (med 1 s12)
  , checkThat "med 2 {1,2}"                (med 2 s12)
  , checkThat "not (med 3 {1,2})"          (not (med 3 s12))
  , checkThat "not (med 1 Ø)"              (not (med 1 tom))
  , checkThat "med 3 ({2} ∪ {1}) ∪ {3}"    (med 3 s123)

  , checkThat "delm Ø {1,2}"               (delm tom s12)
  , checkThat "delm Ø Ø"                   (delm tom tom)
  , checkThat "not (delm {1,2} Ø)"         (not (delm s12 tom))
  , checkThat "delm {1,2} {1,2}"           (delm s12 s12)
  , checkThat "delm {1,2} {2,1,3}"         (delm s12 s123)
  , checkThat "not (delm {2,1,3} {1,2})"   (not (delm s123 s12))
  , checkThat "not (delm {1,4} {2,1,3})"   (not (delm s14 s123))

  , checkThat "Ø == Ø"                     (tom == tom)
  , checkThat "{1,2} == {2,1}"             (s12 == s21)
  , checkThat "{1} ∪ {1} == {1}"           (sumM (enM 1) (enM 1) == (enM 1 :: Set Int))
  , checkThat "Ø ∪ Ø == Ø"                 (sumM tom tom == tom)
  , checkThat "{1} ∪ Ø == {1}"             (sumM (enM 1) tom == (enM 1 :: Set Int))
  , checkThat "not ({1} == {2})"           (not (enM 1 == (enM 2 :: Set Int)))
  , checkThat "not ({1,2} == {1})"         (not (s12 == (enM 1 :: Set Int)))
  , checkThat "not ({1} == {1,2})"         (not ((enM 1 :: Set Int) == s12))
  , checkThat "not ({1,2} == Ø)"           (not (s12 == tom))
  ]
