-- | Week 2 — Hutton ch. 3: types and classes.
--
--     ./check.sh 2
--
-- Every exercise here is about TYPES. Before you write a body, write the type
-- and make sure you believe it. Use ':t' constantly.
module Exercises where

-- ---------------------------------------------------------------------------
-- Exercise 1  (Hutton 3.2)
--
-- Write definitions that have these exact types. Any value of the right type
-- is acceptable -- the point is to produce something that typechecks, so you
-- have to read the type as a specification.
--
--   bools :: [Bool]         a list of booleans
--   nums  :: [[Int]]        a list of LISTS of ints (not a list of ints!)
-- ---------------------------------------------------------------------------

bools :: [Bool]
bools = [True, True, False]

nums :: [[Int]]
nums = [[1, 2, 3], [4, 5, 6]]

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 3.2 cont.)
--
-- add3 takes three Ints and sums them. Note the type: three arrows, which
-- means it is really a function returning a function returning a function.
-- After you define it, try 'add3 1 2' in GHCi and read what ':t' says.
--
--   add3 1 2 3  ==  6
-- ---------------------------------------------------------------------------

add3 :: Int -> Int -> Int -> Int
add3 a b c = a + b + c

-- ---------------------------------------------------------------------------
-- Exercise 3  (Hutton 3.2 cont.)
--
-- copy duplicates its argument into a pair.
--
-- The type variable 'a' is doing real work here. Because the type promises to
-- work for EVERY type a, and says nothing about a, there is literally nothing
-- you can do with the argument except copy it around. This is parametricity:
-- the type alone almost pins down the implementation.
--
--   copy 'x'  ==  ('x','x')
-- ---------------------------------------------------------------------------

copy :: a -> (a, a)
copy a = (a, a)

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 3.2 cont.)
--
-- apply applies a function to an argument. Yes, that is all it does.
--
--   apply (+1) 5     ==  6
--   apply reverse "abc" == "cba"
-- ---------------------------------------------------------------------------

apply :: (a -> b) -> a -> b
apply a b = a b

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 3.3)
--
-- Hutton gives you these definitions and asks for their types. Here you get
-- the types and write the definitions. Work out what each MUST do from its
-- type before you look at the examples.
--
--   second [1,2,3]        ==  2
--   swap (1,'a')          ==  ('a',1)
--   pair 1 'a'            ==  (1,'a')
--   double 4              ==  8
--   palindrome "racecar"  ==  True
--   palindrome [1,2,3]    ==  False
--   twice (*2) 3          ==  12
-- ---------------------------------------------------------------------------

second :: [a] -> a
second xs = head (drop 1 xs)

swap :: (a, b) -> (b, a)
swap (a, b) = (b, a)

pair :: a -> b -> (a, b)
pair a b = (a, b)

double :: Num a => a -> a
double xs = xs * 2

palindrome :: Eq a => [a] -> Bool
palindrome xs = xs == reverse xs

twice :: (a -> a) -> a -> a
twice a b = a (a b)

-- ---------------------------------------------------------------------------
-- Exercise 6
--
-- The biggest element of a non-empty list, WITHOUT using 'maximum'.
--
-- Look at the constraint: 'Ord a =>' is what buys you the right to use (>) or
-- (<=) on a. Try deleting the constraint and see what GHC says -- read that
-- error message carefully, you will meet it often.
--
--   largest [3,1,4,1,5]  ==  5
--   largest "haskell"    ==  's'
-- ---------------------------------------------------------------------------

largest :: Ord a => [a] -> a
largest [a] = a
largest (x:xs) = if x > rest then x else rest
    where rest = largest xs

-- ---------------------------------------------------------------------------
-- Exercise 7
--
-- roundTrip turns a value into a String and immediately parses it back.
-- It should be the identity function for any type that has both a Show and a
-- Read instance.
--
--   roundTrip (3 :: Int)        ==  3
--   roundTrip [True,False]      ==  [True,False]
--
-- Two constraints on one type variable. Note the syntax: they go in a tuple
-- before the '=>'.
-- ---------------------------------------------------------------------------

roundTrip :: (Show a, Read a) => a -> a
roundTrip xs = read (show xs)

-- ---------------------------------------------------------------------------
-- Exercise 8
--
-- describe compares two values and reports on them. This exercise exists to
-- make you combine constraints from two different classes on one variable.
--
--   describe (3 :: Int) 5   ==  "3 is smaller than 5"
--   describe (5 :: Int) 3   ==  "5 is bigger than 3"
--   describe 'a' 'a'        ==  "'a' is equal to 'a'"
--
-- Note the last one: 'show' on a Char includes the quotes. Use 'show' for
-- both values, and (++) to glue the pieces together.
-- ---------------------------------------------------------------------------

describe :: (Show a, Ord a) => a -> a -> String
describe a b = if a > b then bigger else if a < b then smaller else equal
    where
        bigger = show a ++ " is bigger than " ++ show b
        smaller = show a ++ " is smaller than " ++ show b
        equal = show a ++ " is equal to " ++ show b

