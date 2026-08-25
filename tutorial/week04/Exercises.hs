-- | Week 4 — Hutton ch. 5: list comprehensions.
--
--     ./check.sh 4
--
-- Every exercise this week has a one-line answer of the shape
--
--     [ expression | generator, guard ]
--
-- If you find yourself writing recursion, stop -- that is week 5. The whole
-- point of this chapter is that a comprehension replaces the loop you would
-- have written in Python, and it does it in one line.
module Exercises where

import Data.Char (chr, isLower, ord)

-- ---------------------------------------------------------------------------
-- Exercise 1  (Hutton 5.1)
--
-- The sum of the first n squares.
--
--   sumSquares 100  ==  338350
--   sumSquares 3    ==  14        -- 1 + 4 + 9
--   sumSquares 0    ==  0
--
-- One comprehension inside 'sum'. Note what n = 0 has to do: [1..0] is the
-- empty list, so the comprehension is empty, so the sum is 0. You get the
-- base case for free -- no special-casing.
-- ---------------------------------------------------------------------------

sumSquares :: Int -> Int
sumSquares = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 5.2)
--
-- A coordinate grid. Both dimensions count from 0.
--
--   grid 1 2  ==  [(0,0),(0,1),(0,2),(1,0),(1,1),(1,2)]
--   grid 0 0  ==  [(0,0)]
--
-- Two generators. ORDER MATTERS: the LAST generator is the inner loop, the
-- one that changes fastest. Get the order backwards and you get the same
-- pairs in the wrong sequence -- and the test will catch you.
-- ---------------------------------------------------------------------------

grid :: Int -> Int -> [(Int, Int)]
grid = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3  (Hutton 5.3)
--
-- A square grid with the diagonal removed.
--
--   square 2  ==  [(0,1),(0,2),(1,0),(1,2),(2,0),(2,1)]
--
-- Build it from 'grid' -- do not start over. A comprehension can draw from
-- another comprehension's result, and reuse is the point of exercise 2.
-- ---------------------------------------------------------------------------

square :: Int -> [(Int, Int)]
square = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 5.4)
--
-- Reimplement 'replicate' with a comprehension.
--
--   replicate' 3 True  ==  [True,True,True]
--   replicate' 0 'x'   ==  ""
--
-- The generator produces nothing you actually want -- you only need it for
-- its LENGTH. Use the wildcard '_' for the variable you are not going to
-- mention, exactly as in a pattern.
-- ---------------------------------------------------------------------------

replicate' :: Int -> a -> [a]
replicate' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 5.5)
--
-- All Pythagorean triples (x,y,z) with components drawn from [1..n], where
-- x^2 + y^2 == z^2.
--
--   pyths 10  ==  [(3,4,5),(4,3,5),(6,8,10),(8,6,10)]
--
-- Three generators and one guard. Both (3,4,5) and (4,3,5) appear -- the
-- specification says every triple, not every triple up to symmetry.
-- ---------------------------------------------------------------------------

pyths :: Int -> [(Int, Int, Int)]
pyths = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hutton 5.6)
--
-- A positive integer is PERFECT if it equals the sum of its factors, not
-- counting the number itself.
--
--   factors 15   ==  [1,3,5,15]
--   factors 7    ==  [1,7]
--   perfects 500 ==  [6,28,496]        -- 6 = 1+2+3
--
-- Write 'factors' first, with a comprehension and a guard using 'mod'. Then
-- 'perfects' uses it. To drop the number itself from its own factor list,
-- remember that it is always the LAST element.
-- ---------------------------------------------------------------------------

factors :: Int -> [Int]
factors = undefined

perfects :: Int -> [Int]
perfects = undefined

-- ---------------------------------------------------------------------------
-- Exercise 7  (from the chapter text)
--
-- 'pairs' returns every adjacent pair in a list; 'sorted' uses it to decide
-- whether a list is in non-decreasing order.
--
--   pairs [1,2,3,4]   ==  [(1,2),(2,3),(3,4)]
--   pairs [1]         ==  []
--   sorted [1,2,3]    ==  True
--   sorted [1,3,2]    ==  False
--   sorted []         ==  True
--
-- 'pairs' is 'zip' applied to the list and its own tail -- write that down
-- and stare at it until it is obvious. 'sorted' is a comprehension producing
-- Bools, wrapped in 'and'.
-- ---------------------------------------------------------------------------

pairs :: [a] -> [(a, a)]
pairs = undefined

sorted :: Ord a => [a] -> Bool
sorted = undefined

-- ---------------------------------------------------------------------------
-- Exercise 8  (Hutton 5.8)
--
-- Every position at which a value occurs in a list. Positions count from 0.
--
--   positions False [True,False,True,False]  ==  [1,3]
--   positions 'l' "hello"                    ==  [2,3]
--   positions 9 [1,2,3]                      ==  []
--
-- The trick is the same one 'pairs' uses: zip the list against [0..] so that
-- every element arrives with its own index attached. [0..] is infinite and
-- that is fine -- 'zip' stops when the shorter list runs out.
-- ---------------------------------------------------------------------------

positions :: Eq a => a -> [a] -> [Int]
positions = undefined

-- ---------------------------------------------------------------------------
-- Exercise 9  (Hutton 5.9)
--
-- The scalar (dot) product of two vectors: multiply pairwise, then sum.
--
--   scalarproduct [1,2,3] [4,5,6]  ==  32       -- 4 + 10 + 18
--   scalarproduct [] []            ==  0
--
-- One line: zip, a comprehension, and 'sum'.
-- ---------------------------------------------------------------------------

scalarproduct :: [Int] -> [Int] -> Int
scalarproduct = undefined

-- ---------------------------------------------------------------------------
-- Exercise 10  (the Caesar cipher, from the chapter text)
--
-- Shift every lowercase letter forward by n places, wrapping round from 'z'
-- to 'a'. Anything that is not a lowercase letter is left completely alone.
--
--   let2int 'a'  ==  0          int2let 0  ==  'a'
--   let2int 'z'  ==  25         int2let 25 ==  'z'
--
--   shift 3 'a'  ==  'd'
--   shift 3 'z'  ==  'c'        -- wrapped
--   shift 3 ' '  ==  ' '        -- untouched
--
--   encode 3 "haskell is fun"     ==  "kdvnhoo lv ixq"
--   encode (-3) "kdvnhoo lv ixq"  ==  "haskell is fun"
--
-- 'ord' and 'chr' convert between a Char and its Unicode number; they are
-- imported at the top of this file. The wrap-around is 'mod' 26 -- and
-- because Haskell's 'mod' returns a non-negative result for a positive
-- divisor, the same definition decodes with a negative n. You do not need a
-- separate decode function, and that is worth noticing.
-- ---------------------------------------------------------------------------

let2int :: Char -> Int
let2int = undefined

int2let :: Int -> Char
int2let = undefined

shift :: Int -> Char -> Char
shift = undefined

encode :: Int -> String -> String
encode = undefined
