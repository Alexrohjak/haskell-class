-- | Week 1 reference solutions. Try the exercises yourself first --
-- run './check.sh 1 --solution' to confirm these pass.
module Exercises where

qsort :: Ord a => [a] -> [a]
qsort []     = []
qsort (x:xs) = qsort smaller ++ [x] ++ qsort larger
  where
    smaller = [a | a <- xs, a <= x]
    larger  = [b | b <- xs, b >  x]

-- Exercise 1. Reverse the list and take its head. O(n), like 'last' itself.
-- Alternative: myLast xs = xs !! (length xs - 1)
myLast :: [a] -> a
myLast = head . reverse

-- Exercise 2. Reverse, drop the (now) first element, reverse back.
-- Alternative: myInit xs = take (length xs - 1) xs
myInit :: [a] -> [a]
myInit = reverse . tail . reverse

-- Exercise 3. Both operands of (/) must be Fractional, so BOTH sum and
-- length have to be pushed across with fromIntegral.
average :: [Int] -> Double
average xs = fromIntegral (sum xs) / fromIntegral (length xs)

-- Exercise 4. 1 is the identity for (*), which is exactly why it is the
-- right answer for the empty list -- it keeps the multiplication law intact.
productR :: [Int] -> Int
productR []     = 1
productR (x:xs) = x * productR xs

-- Exercise 5. Only the two comparison operators change: what used to go
-- left now goes right.
qsortDesc :: Ord a => [a] -> [a]
qsortDesc []     = []
qsortDesc (x:xs) = qsortDesc larger ++ [x] ++ qsortDesc smaller
  where
    smaller = [a | a <- xs, a <= x]
    larger  = [b | b <- xs, b >  x]

-- Exercise 6.
thirdIndex :: [a] -> a
thirdIndex xs = xs !! 2

thirdHeads :: [a] -> a
thirdHeads = head . tail . tail
