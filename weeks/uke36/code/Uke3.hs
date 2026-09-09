-- Uke 3 (uke36) — the lecturer's weekly sheet.
-- Problems: ../exercises/uke3.txt        How to check these: ../../../docs/checking-your-work.md
--
--   runghc -Wno-x-partial weeks/uke36/code/Uke3.hs
--   ghci weeks/uke36/code/Uke3.hs
--
-- The theme: build a letter-frequency analyser out of small pieces (1-3), then
-- assemble them (4). Exercises 5-6 are tokenisers, and the sheet says outright
-- that they are harder and not to panic over.
--
-- Two things the sheet is inconsistent about, so decide for yourself:
--   * Exercise 5 gives the signature as `tokMath` but calls it `tokMat` in the
--     ghci examples. uke4 also calls it `tokMat`, so that name is used here.
--   * Exercise 4's example lists ' ' LAST, after the letters — but ' ' sorts
--     BEFORE 'D' in ASCII. The example cannot be in plain sort order. Work out
--     what ordering you want and say so; that is part of the answer.

module Main where

import Test.QuickCheck

-- ---- answers -------------------------------------------------------------

-- 1. Every letter to upper case.  toUppers "Miss Universe" == "MISS UNIVERSE"
toUppers :: String -> String
toUppers = undefined

-- 2. Group runs of consecutive equal elements.
--    group "Mississippi" == ["M","i","ss","i","ss","i","pp","i"]
--    (Prelude does not export `group`, so this name is free. Data.List has one
--     — don't import it, that would be answering the exercise with an import.)
group :: Eq a => [a] -> [[a]]
group = undefined

-- 3. Given a list of identical elements, the element and how many.
--    elTall ['a','a','a'] == ('a',3)      -- partial: undefined on []
elTall :: [a] -> (a, Int)
elTall = undefined

-- 4. Built from 1-3: each character with its number of occurrences.
letterFreq :: String -> [(Char, Int)]
letterFreq = undefined

-- 5. Tokenise arithmetic expressions. Numbers only, no variables.
--    tokMat "10 - 2 * 4"   == ["10","-","2","*","4"]
--    tokMat "(10 - 2) * 4" == ["(","10","-","2",")","*","4"]
tokMat :: String -> [String]
tokMat = undefined

-- 6. Harder. Tokenise the one-argument lambda language: '|' var '->' expr,
--    where expr is arithmetic (+ - * /) or another lambda.
--    langTok "|eks -> eks + 10" == ["|","eks","->","eks","+","10"]
langTok :: String -> [String]
langTok = undefined

-- ---- examples from the sheet ---------------------------------------------

examples :: [Bool]
examples =
  [ toUppers "Miss Universe" == "MISS UNIVERSE"
  , group "Mississippi"      == ["M","i","ss","i","ss","i","pp","i"]
  , elTall "aaa"             == ('a', 3)
  , tokMat "10 - 2 * 4"      == ["10","-","2","*","4"]
  , tokMat "(10 - 2) * 4"    == ["(","10","-","2",")","*","4"]
  , langTok "|eks -> eks + 10" == ["|","eks","->","eks","+","10"]
  ]

-- Exercise 4's example, left out of `examples` on purpose — see the header note
-- about its ordering. Settle the ordering, then move this up.
--
--   letterFreq "Hello World"
--     == [('D',1),('E',1),('H',1),('L',3),('O',2),('R',1),('W',1),(' ',1)]

-- ---- properties ----------------------------------------------------------

prop_toUppers_length :: String -> Bool
prop_toUppers_length s = length (toUppers s) == length s

prop_toUppers_idem :: String -> Bool
prop_toUppers_idem s = toUppers (toUppers s) == toUppers s

-- Grouping rearranges nothing: gluing the groups back gives you the input.
prop_group_concat :: String -> Bool
prop_group_concat s = concat (group s) == s

prop_group_nonempty :: String -> Bool
prop_group_nonempty s = all (not . null) (group s)

-- Within a group every element is the same one.
prop_group_uniform :: String -> Bool
prop_group_uniform s = all (\g -> all (== head g) g) (group s)

-- elTall is the inverse of replicate, on the inputs it is defined for.
prop_elTall_replicate :: Char -> Int -> Property
prop_elTall_replicate c n =
  n > 0 ==> elTall (replicate n c) == (c, n)

-- Nothing is lost or invented: the counts add up to what you fed in.
-- If you decide letterFreq drops some characters, weaken this to match your
-- decision rather than deleting it.
prop_letterFreq_total :: String -> Bool
prop_letterFreq_total s = sum (map snd (letterFreq s)) == length s

-- A tokeniser only splits — it never changes the characters, only the spaces.
prop_tokMat_chars :: String -> Bool
prop_tokMat_chars s = concat (tokMat s) == filter (/= ' ') s

-- ---- the loop ------------------------------------------------------------

main :: IO ()
main = do
  print (and examples)
  quickCheck prop_toUppers_length
  quickCheck prop_toUppers_idem
  quickCheck prop_group_concat
  quickCheck prop_group_nonempty
  quickCheck prop_group_uniform
  quickCheck prop_elTall_replicate
  quickCheck prop_letterFreq_total
  quickCheck prop_tokMat_chars
