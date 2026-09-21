-- Uke 1 (uke34) — the lecturer's weekly sheet
-- Problems: ../exercises/uke1.txt        How to check these: ../../../docs/checking-your-work.md
--
--   runghc -Wno-x-partial weeks/uke34/code/Uke1.hs   -- examples + properties
--   ghci weeks/uke34/code/Uke1.hs                    -- poke at it by hand
--
-- Every `undefined` below is yours to fill in. The signatures come from the
-- sheet — leave them in place, they are your first and cheapest test.

module Main where

import Test.QuickCheck

-- ---- answers -------------------------------------------------------------

-- 1. xs with every element increased by k.
plu :: [Int] -> Int -> [Int]
plu [] k = []
plu (x:xs) k = x + k : plu xs k

-- 2. True iff the string reads the same forwards and backwards.
pali :: String -> Bool
pali xs = xs == reverse xs

-- 3. Pad to the given width. The sheet asks what should happen when the input
--    is already longer than the width — decide, then write a property for it.
hjuster :: Int -> String -> String   -- right-align: "  word"
hjuster k xs = replicate (k - length xs) ' ' ++ xs

vjuster :: Int -> String -> String   -- left-align:  "word  "
vjuster k xs = xs ++ replicate (k - length xs)' '

-- 4. Elements at even / odd positions.
evens :: [a] -> [a]
evens [] = []
evens (x:xs) = x : odds xs

odds :: [a] -> [a]
odds [] = []
odds (x:xs) = drop x : evens xs

-- 5. Same result as (evens xs, odds xs), but traversing xs only once.
evensOdds :: [a] -> ([a], [a])
evensOdds xs =

-- ---- examples from the sheet ---------------------------------------------

examples :: [Bool]
examples =
  [ plu [1,2,5] 4     == [5,6,9]
  , hjuster 6 "word"  == "  word"
  , vjuster 6 "word"  == "word  "
  , evens "abcde"     == "ace"
  , odds  "abcde"     == "bd"
  ]

-- ---- properties ----------------------------------------------------------
-- Monomorphic signatures on purpose: see §4.1 of checking-your-work.md.
-- Add your own. Patterns worth reaching for: invariant, identity, inverse,
-- idempotence, composition, oracle.

prop_plu_length :: [Int] -> Int -> Bool
prop_plu_length xs k = length (plu xs k) == length xs

prop_plu_zero :: [Int] -> Bool
prop_plu_zero xs = plu xs 0 == xs

prop_plu_twice :: [Int] -> Int -> Int -> Bool
prop_plu_twice xs j k = plu (plu xs j) k == plu xs (j + k)

-- Exercise 3's own question, asked of the machine.
prop_hjuster_len :: Int -> String -> Bool
prop_hjuster_len n s = length (hjuster n s) == n

-- The sheet states exercise 5's specification outright. That sentence is the
-- property: the obvious two-pass version is the oracle for your one-pass one.
prop_evensOdds_spec :: [Int] -> Bool
prop_evensOdds_spec xs = evensOdds xs == (evens xs, odds xs)

-- ---- the loop ------------------------------------------------------------

main :: IO ()
main = do
  print (and examples)
  quickCheck prop_plu_length
  quickCheck prop_plu_zero
  quickCheck prop_plu_twice
  quickCheck prop_hjuster_len
  quickCheck prop_evensOdds_spec
