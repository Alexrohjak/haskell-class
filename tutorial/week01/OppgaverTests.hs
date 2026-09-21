module Main where

import Check
import Oppgaver

main :: IO ()
main = runTests "Week 1 -- oppgaver uke1"
  [ check "plu [1,2,5] 4"          (plu [1,2,5] 4)               [5,6,9]
  , check "plu [] 4"               (plu [] 4)                    []
  , check "plu [1,2] 0"            (plu [1,2] 0)                 [1,2]
  , check "plu [3] (-3)"           (plu [3] (-3))                [0]

  , check "pali \"regninger\""     (pali "regninger")            True
  , check "pali \"abba\""          (pali "abba")                 True
  , check "pali \"abc\""           (pali "abc")                  False
  , check "pali \"ab\""            (pali "ab")                   False
  , check "pali \"a\""             (pali "a")                    True
  , check "pali \"\""              (pali "")                     True

  , check "hjuster 6 \"word\""     (hjuster 6 "word")            "  word"
  , check "vjuster 6 \"word\""     (vjuster 6 "word")            "word  "
  , check "hjuster 4 \"word\""     (hjuster 4 "word")            "word"
  , check "vjuster 4 \"word\""     (vjuster 4 "word")            "word"
  , check "hjuster 3 \"\""         (hjuster 3 "")                "   "
  , check "vjuster 3 \"\""         (vjuster 3 "")                "   "

  , check "evens \"abcde\""        (evens "abcde")               "ace"
  , check "odds \"abcde\""         (odds "abcde")                "bd"
  , check "evens []"               (evens ([] :: [Int]))         []
  , check "odds []"                (odds ([] :: [Int]))          []
  , check "evens [7]"              (evens [7 :: Int])            [7]
  , check "odds [7]"               (odds [7 :: Int])             []
  , check "evens [1..6]"           (evens [1..6 :: Int])         [1,3,5]
  , check "odds [1..6]"            (odds [1..6 :: Int])          [2,4,6]

  , check "evensOdds \"abcde\""    (evensOdds "abcde")           ("ace","bd")
  , check "evensOdds []"           (evensOdds ([] :: [Int]))     ([],[])
  , check "evensOdds [7]"          (evensOdds [7 :: Int])        ([7],[])
  , check "evensOdds [1..6]"       (evensOdds [1..6 :: Int])     ([1,3,5],[2,4,6])
  , checkThat "evensOdds xs == (evens xs, odds xs)"
      (and [ evensOdds xs == (evens xs, odds xs) | n <- [0..9], let xs = [1..n :: Int] ])
  ]
