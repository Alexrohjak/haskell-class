-- | Week 4 reference solutions.
module Exercises where

import Data.Char (chr, isLower, ord)

-- Exercise 1. [1..0] is empty, so n = 0 gives sum [] = 0 with no special case.
sumSquares :: Int -> Int
sumSquares n = sum [x ^ 2 | x <- [1 .. n]]

-- Exercise 2. The last generator is the inner loop: y changes fastest.
grid :: Int -> Int -> [(Int, Int)]
grid m n = [(x, y) | x <- [0 .. m], y <- [0 .. n]]

-- Exercise 3. Draw from grid, then filter with a guard. The pattern (x,y) on
-- the left of <- takes the pair apart so the guard can name both halves.
square :: Int -> [(Int, Int)]
square n = [(x, y) | (x, y) <- grid n n, x /= y]

-- Exercise 4. The generator is used only for its length, so the value it
-- produces is discarded with '_'.
replicate' :: Int -> a -> [a]
replicate' n x = [x | _ <- [1 .. n]]

-- Exercise 5. Three generators, one guard.
pyths :: Int -> [(Int, Int, Int)]
pyths n = [(x, y, z) | x <- [1 .. n], y <- [1 .. n], z <- [1 .. n],
                       x ^ 2 + y ^ 2 == z ^ 2]

-- Exercise 6. A factor is a divisor, so guard on the remainder being zero.
factors :: Int -> [Int]
factors n = [x | x <- [1 .. n], n `mod` x == 0]

-- 'init' drops the last element, which for a factor list is always n itself.
perfects :: Int -> [Int]
perfects n = [x | x <- [1 .. n], sum (init (factors x)) == x]

-- Exercise 7. Zip a list against its own tail and adjacent pairs fall out.
pairs :: [a] -> [(a, a)]
pairs xs = zip xs (tail xs)

-- 'and' is True for the empty list, so the empty and single-element cases are
-- handled without being mentioned.
sorted :: Ord a => [a] -> Bool
sorted xs = and [x <= y | (x, y) <- pairs xs]

-- Exercise 8. Zipping against the infinite [0..] attaches an index to every
-- element; zip stops when the finite list runs out.
positions :: Eq a => a -> [a] -> [Int]
positions x xs = [i | (x', i) <- zip xs [0 ..], x == x']

-- Exercise 9.
scalarproduct :: [Int] -> [Int] -> Int
scalarproduct xs ys = sum [x * y | (x, y) <- zip xs ys]

-- Exercise 10. 'a' is the origin, so subtracting its code gives 0..25.
let2int :: Char -> Int
let2int c = ord c - ord 'a'

int2let :: Int -> Char
int2let n = chr (ord 'a' + n)

-- Guard on isLower so digits, spaces and punctuation pass through untouched.
-- 'mod' 26 does the wrap-around, and because Haskell's 'mod' is non-negative
-- for a positive divisor, a negative n decodes correctly.
shift :: Int -> Char -> Char
shift n c
  | isLower c = int2let ((let2int c + n) `mod` 26)
  | otherwise = c

encode :: Int -> String -> String
encode n xs = [shift n x | x <- xs]
