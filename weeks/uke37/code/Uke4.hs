-- Uke 4 (uke37) — the lecturer's weekly sheet.
-- Problems: ../exercises/uke4.txt        How to check these: ../../../docs/checking-your-work.md
--
--   runghc -Wno-x-partial weeks/uke37/code/Uke4.hs
--   ghci weeks/uke37/code/Uke4.hs
--
-- Read the instructions on the sheet, not just the signatures:
--   * Exercises 2 and 3 must each be solved TWICE — once with a list
--     comprehension, once with recursion. Hence the LC/Rec pairs below.
--   * Exercise 4 wants isOdd twice too: (a) tail-recursive, (b) mutually
--     recursive with isEven.
--   * Exercises 5 and 6 are flagged as harder. No panic required.

module Main where

import Test.QuickCheck

-- ---- answers -------------------------------------------------------------

-- 1. Recursive. Each string represents an integer; convert the lot.
--    Use `read s :: Int`.  (`show` goes the other way.)
strInt :: [String] -> [Int]
strInt = undefined

-- 2. Remove every occurrence of the character from the string.
--    fjern "ab cd ef" ' ' == "abcdef"
--    fjern "ab cd cf" 'c' == "ab d f"
fjernLC :: String -> Char -> String     -- (1) list comprehension
fjernLC = undefined

fjernRec :: String -> Char -> String    -- (2) recursion
fjernRec = undefined

-- 3. All positions at which the character occurs.
--    tegnpos 'n' "Tannenberg 1410" == [2,3,5]
--    tegnpos '1' "Tannenberg 1410" == [11,13]
--    (Note the indices the sheet expects — check which end it counts from.)
tegnposLC :: Char -> String -> [Int]    -- (1) list comprehension
tegnposLC = undefined

tegnposRec :: Char -> String -> [Int]   -- (2) recursion
tegnposRec = undefined

-- 4. The naive version on the sheet is
--      isOdd 0 = False
--      isOdd n = not (isOdd (n-1))
isOddTail :: Int -> Bool                -- (a) tail recursion
isOddTail = undefined

isOddMut :: Int -> Bool                 -- (b) mutual recursion, with isEvenMut
isOddMut = undefined

isEvenMut :: Int -> Bool
isEvenMut = undefined

-- 5. Harder. The LIST, defined in terms of itself: fibs = ... fibs ...
--    Starts 1, 1, 2, 3, 5, 8, 13, ...   zipWith is the hint the sheet gives.
fibs :: [Integer]
fibs = undefined

-- 6. Harder. Reverse Polish notation. First argument is the stack.
--    evalOPN [] ["12","5","*","1","+"] == 61
evalOPN :: [Int] -> [String] -> Int
evalOPN = undefined

-- tokMat is your answer to uke3 oppgave 5 — copy it across once it works.
tokMat :: String -> [String]
tokMat = undefined

--    eval "1 2 3 * +"   == 7
--    eval "12 5 * 1 -"  == 59
eval :: String -> Int
eval = undefined

-- ---- examples from the sheet ---------------------------------------------

examples :: [Bool]
examples =
  [ fjernLC  "ab cd ef" ' ' == "abcdef"
  , fjernRec "ab cd ef" ' ' == "abcdef"
  , fjernLC  "ab cd cf" 'c' == "ab d f"
  , fjernRec "ab cd cf" 'c' == "ab d f"
  , tegnposLC  'n' "Tannenberg 1410" == [2,3,5]
  , tegnposRec 'n' "Tannenberg 1410" == [2,3,5]
  , tegnposLC  '1' "Tannenberg 1410" == [11,13]
  , tegnposRec '1' "Tannenberg 1410" == [11,13]
  , take 7 fibs == [1,1,2,3,5,8,13]
  , evalOPN [] ["12","5","*","1","+"] == 61
  , eval "1 2 3 * +"  == 7
  , eval "12 5 * 1 -" == 59
  ]

-- ---- properties ----------------------------------------------------------

-- strInt undoes show. The inverse pattern, and the cleanest check there is.
prop_strInt_inverse :: [Int] -> Bool
prop_strInt_inverse ns = strInt (map show ns) == ns

-- The sheet asks for two implementations, which makes each the other's oracle.
-- If these two disagree, one of them is wrong and you get the input for free.
prop_fjern_agree :: String -> Char -> Bool
prop_fjern_agree s c = fjernLC s c == fjernRec s c

prop_tegnpos_agree :: Char -> String -> Bool
prop_tegnpos_agree c s = tegnposLC c s == tegnposRec c s

-- After removing c, no c is left.
prop_fjern_gone :: String -> Char -> Bool
prop_fjern_gone s c = c `notElem` fjernLC s c

-- Removing twice is removing once.
prop_fjern_idem :: String -> Char -> Bool
prop_fjern_idem s c = fjernLC (fjernLC s c) c == fjernLC s c

-- What is removed is exactly what was counted.
prop_fjern_length :: String -> Char -> Bool
prop_fjern_length s c =
  length (fjernLC s c) + length (tegnposLC c s) == length s

-- Same again for the two isOdd variants, against each other and against
-- Prelude's `odd`. Only non-negative n: the sheet's definition bottoms at 0.
prop_isOdd_agree :: Int -> Bool
prop_isOdd_agree n = let m = abs n `mod` 200 in isOddTail m == isOddMut m

prop_isOdd_correct :: Int -> Bool
prop_isOdd_correct n = let m = abs n `mod` 200 in isOddTail m == odd m

prop_isEven_complement :: Int -> Bool
prop_isEven_complement n = let m = abs n `mod` 200 in isEvenMut m == not (isOddMut m)

-- Each Fibonacci number is the sum of the two before it.
prop_fibs_recurrence :: Int -> Bool
prop_fibs_recurrence n =
  let k  = abs n `mod` 100
      xs = take (k + 3) fibs
  in xs !! (k + 2) == xs !! (k + 1) + xs !! k

-- eval is evalOPN composed with tokMat — that sentence is the property.
prop_eval_composition :: Bool
prop_eval_composition = eval s == evalOPN [] (tokMat s)
  where s = "12 5 * 1 +"

-- ---- the loop ------------------------------------------------------------

main :: IO ()
main = do
  print (and examples)
  quickCheck prop_strInt_inverse
  quickCheck prop_fjern_agree
  quickCheck prop_tegnpos_agree
  quickCheck prop_fjern_gone
  quickCheck prop_fjern_idem
  quickCheck prop_fjern_length
  quickCheck prop_isOdd_agree
  quickCheck prop_isOdd_correct
  quickCheck prop_isEven_complement
  quickCheck prop_fibs_recurrence
  quickCheck prop_eval_composition
