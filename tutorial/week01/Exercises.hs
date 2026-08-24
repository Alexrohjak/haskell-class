-- | Week 1 — Hutton ch. 1-2: the functional mindset, GHCi, first steps.
--
-- Replace every 'undefined' with a real definition.
-- Check your work from the tutorial/ directory with:
--
--     ./check.sh 1
--
-- Read LESSON.md first. Do not import anything: everything you need is in
-- the Prelude, which is in scope automatically.
module Exercises where

-- ---------------------------------------------------------------------------
-- Given to you: the quicksort from Hutton section 1.7. Read it carefully,
-- you will modify it in exercise 5.
-- ---------------------------------------------------------------------------

qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
  where
    smaller = [a | a <- xs, a <= x]
    larger  = [b | b <- xs, b >  x]

-- ---------------------------------------------------------------------------
-- Exercise 1  (Hutton 2.5)
--
-- The library function 'last' returns the final element of a non-empty list.
-- Define it yourself using ONLY these Prelude functions: head, reverse,
-- length, (!!), drop, sum. Do not use 'last' itself and do not use recursion
-- or pattern matching on (x:xs) -- that comes in week 3.
--
--   myLast [1,2,3]  ==  3
--   myLast "abc"    ==  'c'
-- ---------------------------------------------------------------------------

myLast :: [a] -> a
myLast = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 2.6)
--
-- 'init' returns everything except the final element. Define it yourself,
-- again without using 'init'. Two obvious routes: reverse/tail/reverse, or
-- take/length. Pick one, then write the OTHER one in a comment underneath so
-- you have seen both.
--
--   myInit [1,2,3]  ==  [1,2]
--   myInit "abc"    ==  "ab"
-- ---------------------------------------------------------------------------

myInit :: [a] -> [a]
myInit = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3
--
-- The average of a list of Ints, as a Double.
--
-- This one exists to teach you a specific pain. Haskell will NOT silently
-- convert an Int into a Double for you: 'sum xs / length xs' is a type error,
-- because (/) wants Fractional and length gives you an Int. You need
-- 'fromIntegral' to move a whole number into the Fractional world.
--
--   average [1,2,3,4]  ==  2.5
--   average [10]       ==  10.0
-- ---------------------------------------------------------------------------

average :: [Int] -> Double
average = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 1.1)
--
-- The Prelude's 'product' multiplies every number in a list together.
-- Define it yourself by recursion. This is a preview of week 5 -- the shape
-- is exactly the 'sum' definition on Hutton page 3, with (*) instead of (+).
--
-- What should the empty list give back? Think about why 1 is the only answer
-- that makes 'productR (xs ++ ys) == productR xs * productR ys' hold.
--
--   productR [2,3,4]  ==  24
--   productR []       ==  1
-- ---------------------------------------------------------------------------

productR :: [Int] -> Int
productR = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 1.3)
--
-- Copy 'qsort' above and change it so it sorts into DESCENDING order.
-- Change as little as possible -- the answer is a one-character-ish edit.
--
--   qsortDesc [3,1,2]  ==  [3,2,1]
-- ---------------------------------------------------------------------------

qsortDesc :: Ord a => [a] -> [a]
qsortDesc = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6
--
-- Return the third element of a list, two different ways.
--
--   thirdIndex  [1,2,3,4]  ==  3     -- using (!!)
--   thirdHeads  [1,2,3,4]  ==  3     -- using only head and tail
--
-- Both are partial: they crash on short lists. That is fine for now. In week 4
-- you will learn to return a Maybe instead, which is how you would really
-- write this.
-- ---------------------------------------------------------------------------

thirdIndex :: [a] -> a
thirdIndex = undefined

thirdHeads :: [a] -> a
thirdHeads = undefined
