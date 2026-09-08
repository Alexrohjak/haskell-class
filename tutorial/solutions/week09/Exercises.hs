-- | Week 9 reference solutions.
module Exercises where

-- Exercise 1. Nothing infinite is ever built: (:) hands back its head without
-- inspecting its tail, so a consumer taking four elements demands exactly four.
ones :: [Int]
ones = 1 : ones

nats :: [Int]
nats = [0 ..]

repeat' :: a -> [a]
repeat' x = x : repeat' x

-- The recursive call is guarded by the elements of xs, so each round produces
-- work before recursing.
cycle' :: [a] -> [a]
cycle' [] = error "cycle': empty list"
cycle' xs = xs ++ cycle' xs

-- Exercise 2.
iterate' :: (a -> a) -> a -> [a]
iterate' f x = x : iterate' f (f x)

-- Generate infinitely, select lazily: 'head' demands one element, so dropWhile
-- stops as soon as it finds it.
firstOver :: Int -> [Int] -> Int
firstOver n = head . dropWhile (<= n)

-- Exercise 3. Self-referential and perfectly well defined: by the time element
-- n is demanded, n-1 and n-2 have already been produced.
fibs :: [Integer]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

fibN :: Int -> Integer
fibN n = fibs !! n

firstFibOver :: Integer -> Integer
firstFibOver n = head (dropWhile (<= n) fibs)

-- Exercise 4. The generator knows nothing about how many primes are wanted.
primes :: [Int]
primes = sieve [2 ..]
  where sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]
        sieve []     = []

-- takeWhile stops at the first failure. 'filter' would scan forever, because
-- it cannot know no further element will match.
primesBelow :: Int -> [Int]
primesBelow n = takeWhile (< n) primes

-- Exercise 5. Both stop as soon as the answer is determined, because (||) and
-- (&&) do not evaluate their second argument unless they must.
anyInf :: (a -> Bool) -> [a] -> Bool
anyInf _ []     = False
anyInf p (x:xs) = p x || anyInf p xs

allInf :: (a -> Bool) -> [a] -> Bool
allInf _ []     = True
allInf p (x:xs) = p x && allInf p xs

-- Exercise 6. 'seq' forces the accumulator at every step, so no chain of
-- pending additions is ever built. Same answer as 'sum', constant space.
sumStrict :: [Int] -> Int
sumStrict = go 0
  where go acc []     = acc
        go acc (x:xs) = acc `seq` go (acc + x) xs

-- Exercise 7. Same idea as 'ones', one dimension up.
data ITree a = ILeaf | INode (ITree a) a (ITree a)
  deriving (Eq, Show)

repeatT :: a -> ITree a
repeatT x = INode (repeatT x) x (repeatT x)

takeT :: Int -> ITree a -> ITree a
takeT n _ | n <= 0 = ILeaf
takeT _ ILeaf      = ILeaf
takeT n (INode l x r) = INode (takeT (n - 1) l) x (takeT (n - 1) r)

-- Generate an infinite tree, then cut it to size. Neither half knows about the
-- other, which is exactly the modularity the chapter is arguing for.
replicateT :: Int -> a -> ITree a
replicateT n = takeT n . repeatT

depthT :: ITree a -> Int
depthT ILeaf         = 0
depthT (INode l _ r) = 1 + max (depthT l) (depthT r)
