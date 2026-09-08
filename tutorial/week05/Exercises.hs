-- | Week 5 — Hutton ch. 6: recursive functions.
--
--     ./check.sh 5
--
-- This is LEARNING OUTCOME #1, named in the emneplan. Everything from here on
-- is built out of it.
--
-- Nearly every function below already exists in the Prelude. You are writing
-- them again, from scratch, because the point is not to have them -- it is to
-- be able to derive them. Each one is primed ('and'' etc.) so it does not
-- clash with the original.
--
-- Work them with Hutton's five-step recipe, in LESSON.md section 3. Do not
-- skip it because the early ones are easy; you want the habit installed before
-- you meet a hard one.
module Exercises where

-- ---------------------------------------------------------------------------
-- Exercise 1  (Hutton 6.1)
--
-- Factorial, guarded against negative input.
--
--   fac 0    ==  1
--   fac 5    ==  120
--   fac (-1) ==  0        -- see below
--
-- Hutton's point: the book's 'fac n = n * fac (n-1)' does not terminate for a
-- negative argument -- it counts down forever past zero. Add a guard so any
-- negative input gives 0.
--
-- This is the base-case lesson in miniature: a recursive function is only as
-- correct as its base cases are REACHABLE.
-- ---------------------------------------------------------------------------

fac :: Int -> Int
fac = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 6.2)
--
-- Sum down from n to 0.
--
--   sumdown 3   ==  6      -- 3 + 2 + 1 + 0
--   sumdown 0   ==  0
--   sumdown 1   ==  1
--
-- Recursion on a NUMBER, not a list. Same shape as fac with (+) for (*), and
-- a different identity for the base case -- notice which, and why.
-- ---------------------------------------------------------------------------

sumdown :: Int -> Int
sumdown = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3  (Hutton 6.3)
--
-- Exponentiation, recursively. Don't use (^) -- that's what you're defining.
--
--   expo 2 3   ==  8
--   expo 5 0   ==  1
--   expo 0 3   ==  0
--
-- Mirror the structure of 'mult' from the chapter: recurse on the SECOND
-- argument, and let the base case give the identity for multiplication.
-- ---------------------------------------------------------------------------

expo :: Int -> Int -> Int
expo = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 6.4)
--
-- Euclid's algorithm for the greatest common divisor of two non-negative
-- integers.
--
--   euclid 6 27   ==  3
--   euclid 12 8   ==  4
--   euclid 5 0    ==  5
--
-- The rule: if the two are equal, that IS the gcd. Otherwise replace the
-- larger by their difference and go again. (The 'mod' version is faster and
-- also correct -- write the subtraction one first, since that is the one the
-- exam asks for.)
-- ---------------------------------------------------------------------------

euclid :: Int -> Int -> Int
euclid = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 6.6)
--
-- Five Prelude functions, defined from scratch. All five recurse on a list, so
-- all five have the same two cases: [] and (x:xs).
--
--   and'  [True,True]      ==  True
--   and'  []               ==  True      -- think about why
--   concat' [[1,2],[3]]    ==  [1,2,3]
--   replicate' 3 'x'       ==  "xxx"
--   nth [1,2,3] 1          ==  2         -- this is (!!), zero-indexed
--   elem' 3 [1,2,3]        ==  True
--
-- Write them WITHOUT list comprehensions this week. Week 4 solved this shape of
-- problem by DESCRIBING the result; this week you BUILD it, one cons at a
-- time. Reaching for a comprehension here skips the exercise.
-- ---------------------------------------------------------------------------

and' :: [Bool] -> Bool
and' = undefined

concat' :: [[a]] -> [a]
concat' = undefined

replicate' :: Int -> a -> [a]
replicate' = undefined

nth :: [a] -> Int -> a
nth = undefined

elem' :: Eq a => a -> [a] -> Bool
elem' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hutton 6.7)
--
-- Merge two ALREADY SORTED lists into one sorted list, without using any
-- sorting function.
--
--   merge [2,5,6] [1,3,4]  ==  [1,2,3,4,5,6]
--   merge [] [1,2]         ==  [1,2]
--   merge [1,1] [1]        ==  [1,1,1]
--
-- Three cases, and the third one splits in two. Take the smaller head, and
-- recurse on what is left. Note the two base cases are NOT the same case.
-- ---------------------------------------------------------------------------

merge :: Ord a => [a] -> [a] -> [a]
merge = undefined

-- ---------------------------------------------------------------------------
-- Exercise 7  (Hutton 6.8)
--
-- Merge sort. Split the list in half, sort each half, merge the results.
--
--   msort [4,1,3,2]  ==  [1,2,3,4]
--   msort ""         ==  ""
--   msort [1]        ==  [1]
--
-- Use 'halve' from week 3 (repeated below as a helper -- fill it in again, it
-- is one line) and 'merge' from exercise 6.
--
-- THE TRAP: lists of length 0 and 1 are already sorted and must be base cases.
-- Without them, halve [x] gives ([], [x]) and you recurse on [x] forever. If
-- your tests hang instead of failing, this is why.
-- ---------------------------------------------------------------------------

halve :: [a] -> ([a], [a])
halve = undefined

msort :: Ord a => [a] -> [a]
msort = undefined

-- ---------------------------------------------------------------------------
-- Exercise 8  (Hutton 6.9)
--
-- Three more Prelude functions from scratch.
--
--   sum' [1,2,3]      ==  6
--   sum' []           ==  0
--   take' 2 [1,2,3]   ==  [1,2]
--   take' 0 [1,2,3]   ==  []
--   take' 5 [1,2]     ==  [1,2]     -- more than there is: give what there is
--   last' [1,2,3]     ==  3
--
-- 'take'' recurses on TWO things at once -- the number and the list -- so it
-- needs a case for each of them running out. 'last'' is the one where the base
-- case is a one-element list, not the empty one.
-- ---------------------------------------------------------------------------

sum' :: [Int] -> Int
sum' = undefined

take' :: Int -> [a] -> [a]
take' = undefined

last' :: [a] -> a
last' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 9  (mutual recursion, from the chapter text)
--
-- Two functions that call each other. Build evens/odds this way -- no
-- comprehensions, no zip, no index arithmetic. Compare with week 4's
-- 'positions', which reached for 'zip xs [0..]' to get at element positions;
-- here you will not compute an index at all.
--
--   evens "abcde"  ==  "ace"
--   odds  "abcde"  ==  "bd"
--
-- 'evens' keeps the head and hands the tail to 'odds'; 'odds' drops the head
-- and hands the tail to 'evens'. Each needs its own base case.
--
-- Worth noticing: this is exactly exercise 4 on the lecturer's uke1 sheet,
-- arrived at from the other direction.
-- ---------------------------------------------------------------------------

evens :: [a] -> [a]
evens = undefined

odds :: [a] -> [a]
odds = undefined
