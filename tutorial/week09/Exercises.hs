-- | Week 9 — Hutton ch. 15: lazy evaluation.
--
--     ./check.sh 9
--
-- The last chapter of pensum, and the one that explains things you have been
-- using since week 4 without knowing why they worked: why 'take 5 [1..]'
-- terminates, why 'zip xs [0..]' is fine, and what your 'iterateU' from week 6
-- was really doing.
--
-- A WARNING BEFORE YOU START. Most exercises here build INFINITE values. That
-- is normal and safe, as long as every test truncates them -- and every test
-- below does. But if you write, say, 'ones = ones ++ [1]', nothing will ever
-- produce a first element and the run will HANG rather than fail.
--
-- If ./check.sh 9 hangs: Ctrl-C, and look for a definition that has to finish
-- something infinite before it can hand over its first element.
module Exercises where

-- ---------------------------------------------------------------------------
-- Exercise 1  (infinite lists, from nothing)
--
-- Four definitions, none longer than a line.
--
--   take 4 ones        ==  [1,1,1,1]
--   take 4 nats        ==  [0,1,2,3]
--   take 4 (repeat' 7) ==  [7,7,7,7]
--   take 5 (cycle' [1,2])  ==  [1,2,1,2,1]
--
-- 'ones' is the one to think hardest about. It is defined IN TERMS OF ITSELF,
-- with no base case, and it works:
--
--     ones = 1 : ones
--
-- Nothing infinite is ever built. The ':' hands back its first element without
-- looking at its second argument, so 'take 4' gets four elements and the rest
-- is never demanded. Write it, then work out why 'ones = ones ++ [1]' hangs.
--
-- 'cycle'' should reject the empty list -- 'error "cycle': empty list"'.
-- ---------------------------------------------------------------------------

ones :: [Int]
ones = undefined

nats :: [Int]
nats = undefined

repeat' :: a -> [a]
repeat' = undefined

cycle' :: [a] -> [a]
cycle' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (iterate, and generate-then-select)
--
--   take 5 (iterate' (*2) 1)  ==  [1,2,4,8,16]
--   take 3 (iterate' (+1) 0)  ==  [0,1,2]
--
-- You wrote 'iterateU' in week 6 with 'unfold'. Write it directly this time --
-- it is one line, and the shape is the same as 'ones'.
--
-- Then the pattern this chapter is really about: GENERATE an infinite supply
-- and SELECT from it, letting laziness stop the generator.
--
--   firstOver 100 (iterate' (*2) 1)  ==  128
--   firstOver 10 nats                ==  11
--
-- 'firstOver n xs' is the first element of xs strictly greater than n. The
-- list may be infinite; your definition must not try to look at all of it.
-- ---------------------------------------------------------------------------

iterate' :: (a -> a) -> a -> [a]
iterate' = undefined

firstOver :: Int -> [Int] -> Int
firstOver = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3  (Hutton 15.4 and 15.5 — the Fibonacci list)
--
-- The whole infinite Fibonacci sequence, as one definition:
--
--   take 8 fibs  ==  [0,1,1,2,3,5,8,13]
--
-- The trick, and it is worth a full minute of staring: define 'fibs' in terms
-- of ITSELF and its own tail, added elementwise.
--
--     fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
--
-- That is not circular reasoning. By the time anything asks for element n,
-- elements n-1 and n-2 have already been produced, so the demand is always
-- satisfiable. Write it out, then use it:
--
--   fibN 0   ==  0
--   fibN 10  ==  55
--   firstFibOver 1000  ==  1597
--
-- 'Integer', not 'Int' -- Fibonacci numbers outgrow 64 bits quickly, and week
-- 2 told you what happens then.
-- ---------------------------------------------------------------------------

fibs :: [Integer]
fibs = undefined

fibN :: Int -> Integer
fibN = undefined

firstFibOver :: Integer -> Integer
firstFibOver = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (the sieve of Eratosthenes, all of it)
--
--   take 8 primes     ==  [2,3,5,7,11,13,17,19]
--   primesBelow 20    ==  [2,3,5,7,11,13,17,19]
--   primesBelow 2     ==  []
--
-- The classic demonstration that laziness lets you separate a GENERATOR from a
-- TERMINATION CONDITION. 'primes' does not know how many primes you want and
-- does not need to.
--
--   sieve (p:xs) = p : sieve [x | x <- xs, ...]
--
-- Start from [2..], keep the head, and sieve the tail with every multiple of
-- that head removed.
--
-- 'primesBelow n' takes from 'primes' while they stay below n. Use
-- 'takeWhile', NOT 'filter' -- filter would keep scanning an infinite list
-- forever looking for more matches. This distinction is the exercise.
-- ---------------------------------------------------------------------------

primes :: [Int]
primes = undefined

primesBelow :: Int -> [Int]
primesBelow = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (why '&&' and 'any' can stop early)
--
--   anyInf even nats        ==  True     -- on an INFINITE list
--   allInf (< 5) nats       ==  False    -- also infinite; stops at 5
--
-- Define these with explicit recursion, and make sure they stop as soon as the
-- answer is known. If you write them with 'length' or 'filter' they will hang,
-- which is the lesson: laziness only helps if your own code is lazy too.
--
-- 'anyInf' on a list where nothing matches will never return, and that is
-- correct behaviour -- no finite prefix could prove it. The tests only ask
-- questions that can be answered.
-- ---------------------------------------------------------------------------

anyInf :: (a -> Bool) -> [a] -> Bool
anyInf = undefined

allInf :: (a -> Bool) -> [a] -> Bool
allInf = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hutton 15.7 — seq, and when laziness costs you)
--
-- Laziness is not free. 'foldl (+) 0 [1..1000000]' builds a million-deep chain
-- of unevaluated additions before adding anything, and can exhaust the stack.
--
-- 'seq' forces its first argument before returning its second:
--
--     acc `seq` go (acc + x) xs
--
-- Write a strict sum with an accumulator that is forced at every step.
--
--   sumStrict [1,2,3]  ==  6
--   sumStrict []       ==  0
--   sumStrict [1..100000]  ==  5000050000
--
-- The value is the same as 'sum'. The difference is space, which the tests
-- cannot see -- so read section 6 of LESSON.md for what you have actually
-- built, and try both on [1..10000000] in the REPL if you want to feel it.
-- ---------------------------------------------------------------------------

sumStrict :: [Int] -> Int
sumStrict = undefined

-- ---------------------------------------------------------------------------
-- Exercise 7  (Hutton 15.6 — an infinite TREE)
--
-- Infinite structures are not a list thing. Trees work too.
--
--   repeatT x      -- an infinite tree with x everywhere
--   takeT n t      -- the top n levels of t
--   replicateT n x -- a tree of depth n, all x
--
--   takeT 0 (repeatT 'a')  ==  ILeaf
--   replicateT 1 'a'       ==  INode ILeaf 'a' ILeaf
--   replicateT 2 'a'       ==  INode (INode ILeaf 'a' ILeaf) 'a'
--                                    (INode ILeaf 'a' ILeaf)
--
-- 'repeatT' is the tree version of 'ones' and is just as short. 'replicateT'
-- should be defined in terms of the other two, in one line -- that composition
-- is the point of Hutton 15.6.
--
-- 'depthT' counts levels: depthT ILeaf == 0.
-- ---------------------------------------------------------------------------

data ITree a = ILeaf | INode (ITree a) a (ITree a)
  deriving (Eq, Show)

repeatT :: a -> ITree a
repeatT = undefined

takeT :: Int -> ITree a -> ITree a
takeT = undefined

replicateT :: Int -> a -> ITree a
replicateT = undefined

depthT :: ITree a -> Int
depthT = undefined
