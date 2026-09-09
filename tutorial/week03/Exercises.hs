-- | Week 3 — Hutton ch. 4: defining functions.
--
--     ./check.sh 3
--
-- Several exercises ask for the SAME function written more than one way. That
-- is deliberate: the exam likes asking "rewrite this using guards / using
-- pattern matching", and the only way to get fast at it is repetition.
module Exercises where

-- ---------------------------------------------------------------------------
-- Exercise 1  (Hutton 4.1)
--
-- Split a list of EVEN length into two halves.
--
--   halve [1,2,3,4,5,6]  ==  ([1,2,3],[4,5,6])
--   halve []             ==  ([],[])
--
-- Behaviour on odd-length lists is unspecified -- don't worry about it.
-- Hint: 'take', 'drop', 'length', and 'div'.
-- ---------------------------------------------------------------------------

halve :: [a] -> ([a], [a])
-- halve xs = (take (div (length xs) 2) xs, drop (div (length xs) 2) xs)
halve xs = (take n xs, drop n xs)
  where n = div (length xs) 2

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 4.2)
--
-- The third element of a list, this time by PATTERN MATCHING on the first
-- three elements directly. In week 1 you did the head/tail and (!!) versions;
-- this is the third way, and the one a Haskell programmer would actually
-- write.
--
--   thirdPat [1,2,3,4]  ==  3
--
-- Use the wildcard '_' for the elements you don't care about.
-- ---------------------------------------------------------------------------

thirdPat :: [a] -> a
thirdPat (_:_:x:_) = x

-- ---------------------------------------------------------------------------
-- Exercise 3  (Hutton 4.3)
--
-- 'tail' crashes on []. 'safetail' maps [] to [] and otherwise behaves like
-- tail. Write it THREE times, one per style. All three must behave identically
-- -- the point is to see the same idea in three syntactic dresses.
--
--   safetailCond []      ==  []
--   safetailCond [1,2,3] ==  [2,3]
--
--   safetailCond    -- using a conditional expression: if ... then ... else
--   safetailGuard   -- using guarded equations:  | cond = ...
--   safetailPat     -- using pattern matching:   f []     = ...
--                   --                           f (_:xs) = ...
-- ---------------------------------------------------------------------------

safetailCond :: [a] -> [a]
safetailCond xs = if null xs then [] else tail xs

safetailGuard :: [a] -> [a]
safetailGuard xs
  | null xs = []
  | otherwise = tail xs

safetailPat :: [a] -> [a]
safetailPat [] = []
safetailPat (_:xs) = xs

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 4.4)
--
-- Define logical OR yourself, using pattern matching only -- no (||), no if,
-- no guards. Write it with FOUR equations, one per combination of inputs.
--
-- Then look at your answer and notice it could be two equations. Write that
-- shorter version as myOr2.
--
--   myOr True False  ==  True
--   myOr False False ==  False
-- ---------------------------------------------------------------------------

myOr :: Bool -> Bool -> Bool
myOr True True = True
myOr True False = True
myOr False False = False
myOr False True = True

myOr2 :: Bool -> Bool -> Bool
myOr2 True _ = True
myOr2 False x = x

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 4.6)
--
-- Define logical AND using a SINGLE conditional expression (one 'if'), and no
-- pattern matching on the arguments.
--
-- The trick: don't try to enumerate cases. Ask what the answer is when the
-- first argument is True, and what it is when it's False.
--
--   myAnd True True   ==  True
--   myAnd False True  ==  False
-- ---------------------------------------------------------------------------

myAnd :: Bool -> Bool -> Bool
myAnd a b = if a then b else False

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hutton 4.7)
--
-- Rewrite  mult x y z = x * y * z  as a chain of LAMBDAS, to make the currying
-- explicit. Your definition should literally have the shape
--
--     mult3 = \x -> \y -> \z -> ...
--
-- This is what 'mult x y z = ...' desugars to. Understanding that the two are
-- the same thing is most of what currying is.
--
--   mult3 2 3 4  ==  24
-- ---------------------------------------------------------------------------

mult3 :: Int -> Int -> Int -> Int
mult3 = \x -> \y -> \z -> x * y * z

-- ---------------------------------------------------------------------------
-- Exercise 7  (Hutton 4.8)
--
-- The Luhn algorithm, used to catch mistyped bank card numbers.
--
-- luhnDouble doubles a digit; if the result is greater than 9, subtract 9.
--
--   luhnDouble 3  ==  6
--   luhnDouble 6  ==  3        -- 12 > 9, so 12 - 9
--
-- luhn takes four digits, applies luhnDouble to the FIRST and THIRD, sums all
-- four results, and reports whether the total is divisible by 10.
--
--   luhn 1 7 8 4  ==  True
--   luhn 4 7 8 3  ==  False
-- ---------------------------------------------------------------------------

luhnDouble :: Int -> Int
luhnDouble n
  | d > 9     = d - 9
  | otherwise = d
  where d = n * 2

luhn :: Int -> Int -> Int -> Int -> Bool
luhn a b c d = total `mod` 10 == 0
  where total = luhnDouble a + b + luhnDouble c + d

-- ---------------------------------------------------------------------------
-- Exercise 8
--
-- Guards, in their natural habitat. Convert a percentage score into a UiB
-- letter grade:
--
--   >= 90  'A'      >= 60  'D'
--   >= 80  'B'      >= 50  'E'
--   >= 70  'C'      else   'F'
--
--   grade 95  ==  'A'
--   grade 60  ==  'D'
--   grade 12  ==  'F'
--
-- Guards are tried TOP TO BOTTOM and the first match wins, so the order of
-- your equations matters. Deliberately write them in the wrong order at some
-- point and see what happens -- it is a silent logic bug, not a type error.
-- ---------------------------------------------------------------------------

grade :: Int -> Char
grade n
  | n >= 90   = 'A'
  | n >= 80   = 'B'
  | n >= 70   = 'C'
  | n >= 60   = 'D'
  | n >= 50   = 'E'
  | otherwise = 'F'
