-- | Week 5 reference solutions.
module Exercises where

-- Exercise 1. The guard is the whole point: without it, a negative argument
-- never reaches the base case and the recursion runs forever.
fac :: Int -> Int
fac n
  | n < 0     = 0
  | n == 0    = 1
  | otherwise = n * fac (n - 1)

-- Exercise 2. Same shape as fac, but the base case gives 0 -- the identity for
-- (+) -- where fac gives 1, the identity for (*).
sumdown :: Int -> Int
sumdown n
  | n <= 0    = 0
  | otherwise = n + sumdown (n - 1)

-- Exercise 3. Recurse on the exponent. x^0 is 1 for every x, including 0.
expo :: Int -> Int -> Int
expo _ 0 = 1
expo x n = x * expo x (n - 1)

-- Exercise 4. Subtract the smaller from the larger until they agree. The two
-- zero cases are what make it total.
euclid :: Int -> Int -> Int
euclid x 0 = x
euclid 0 y = y
euclid x y
  | x == y    = x
  | x > y     = euclid (x - y) y
  | otherwise = euclid x (y - x)

-- Exercise 5. Five list recursions, all the same shape.
--
-- and' [] = True because True is the identity for (&&): 'and'' of no
-- conditions is vacuously true, and it keeps 'and' (xs ++ ys)' equal to
-- 'and' xs && and' ys' for every xs and ys. Returning False would break that.
and' :: [Bool] -> Bool
and' []     = True
and' (b:bs) = b && and' bs

concat' :: [[a]] -> [a]
concat' []       = []
concat' (xs:xss) = xs ++ concat' xss

replicate' :: Int -> a -> [a]
replicate' n x
  | n <= 0    = []
  | otherwise = x : replicate' (n - 1) x

-- Recursing on both arguments: step the list and the index down together
-- until the index hits 0.
nth :: [a] -> Int -> a
nth (x:_)  0 = x
nth (_:xs) n = nth xs (n - 1)
nth []     _ = error "nth: index too large"

elem' :: Eq a => a -> [a] -> Bool
elem' _ []     = False
elem' x (y:ys) = x == y || elem' x ys

-- Exercise 6. Two base cases, because either list can run out first, and they
-- do different things.
merge :: Ord a => [a] -> [a] -> [a]
merge [] ys = ys
merge xs [] = xs
merge (x:xs) (y:ys)
  | x <= y    = x : merge xs (y:ys)
  | otherwise = y : merge (x:xs) ys

-- Exercise 7. Both base cases are needed. Drop the [x] case and 'msort [x]'
-- recurses on [x] forever, because halve [x] is ([], [x]).
halve :: [a] -> ([a], [a])
halve xs = (take n xs, drop n xs)
  where n = length xs `div` 2

msort :: Ord a => [a] -> [a]
msort []  = []
msort [x] = [x]
msort xs  = merge (msort ls) (msort rs)
  where (ls, rs) = halve xs

-- Exercise 8.
sum' :: [Int] -> Int
sum' []     = 0
sum' (x:xs) = x + sum' xs

-- Two ways to run out, so two base cases. The n <= 0 case must come first:
-- 'take' 0 [1,2]' is [], not [1].
take' :: Int -> [a] -> [a]
take' n _ | n <= 0 = []
take' _ []         = []
take' n (x:xs)     = x : take' (n - 1) xs

-- The base case is the ONE-element list. [] has no last element at all.
last' :: [a] -> a
last' []     = error "last': empty list"
last' [x]    = x
last' (_:xs) = last' xs

-- Exercise 9. Mutual recursion: each is defined in terms of the other, and
-- each needs its own base case.
evens :: [a] -> [a]
evens []     = []
evens (x:xs) = x : odds xs

odds :: [a] -> [a]
odds []     = []
odds (_:xs) = evens xs
