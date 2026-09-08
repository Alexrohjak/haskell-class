-- | Week 6 — Hutton ch. 7: higher-order functions.
--
--     ./check.sh 6
--
-- LEARNING OUTCOME #2. Last week you hand-wrote a dozen list recursions. This
-- week you find out that almost all of them were three patterns in different
-- clothes, and you stop writing them.
--
-- Rule for this week, and it is the opposite of last week's:
--
--     Once an exercise says "using foldr", RECURSION IS BANNED. Writing it
--     recursively and calling it done is the one way to waste this chapter.
module Exercises where

import Data.Char (chr, ord)

-- ---------------------------------------------------------------------------
-- Exercise 1  (the two you already know, by hand)
--
-- Define map and filter recursively, once, so you know what you are replacing.
--
--   map' (+1) [1,2,3]      ==  [2,3,4]
--   filter' even [1,2,3,4] ==  [2,4]
--
-- Look at the types before you start. 'map'' takes a FUNCTION as its first
-- argument -- that is the whole of what "higher-order" means.
-- ---------------------------------------------------------------------------

map' :: (a -> b) -> [a] -> [b]
map' = undefined

filter' :: (a -> Bool) -> [a] -> [a]
filter' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 7.2)
--
-- Four more from the Prelude, recursively.
--
--   all' even [2,4]        ==  True
--   all' even []           ==  True      -- vacuously
--   any' odd  [2,4]        ==  False
--   any' odd  []           ==  False
--   takeWhile' even [2,4,5,6]  ==  [2,4]
--   dropWhile' even [2,4,5,6]  ==  [5,6]
--
-- Note the base cases for all' and any'. Same identity-element argument as
-- last week: True for (&&), False for (||).
--
-- takeWhile' and dropWhile' stop at the FIRST element failing the test, and do
-- not look any further. They are not filter.
-- ---------------------------------------------------------------------------

all' :: (a -> Bool) -> [a] -> Bool
all' = undefined

any' :: (a -> Bool) -> [a] -> Bool
any' = undefined

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' = undefined

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3  (the foldr drill)
--
-- Now the point of the chapter. Every one of these is 'foldr' with a different
-- pair of arguments -- NO RECURSION, NO COMPREHENSIONS, one line each.
--
--   sumF [1,2,3]        ==  6
--   productF [1,2,3]    ==  6
--   lengthF "abc"       ==  3
--   reverseF [1,2,3]    ==  [3,2,1]
--   andF [True,False]   ==  False
--
-- For each one ask the two foldr questions:
--   (a) what is the answer for [] ?          -> that is the second argument
--   (b) how do I combine the head with the
--       answer for the tail?                  -> that is the first argument
--
-- 'lengthF' is the one that catches people: the combining function must
-- IGNORE the element. 'reverseF' is the one worth staring at afterwards.
-- ---------------------------------------------------------------------------

sumF :: [Int] -> Int
sumF = undefined

productF :: [Int] -> Int
productF = undefined

lengthF :: [a] -> Int
lengthF = undefined

reverseF :: [a] -> [a]
reverseF = undefined

andF :: [Bool] -> Bool
andF = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 7.3)
--
-- map and filter AGAIN, this time as folds. Compare with exercise 1 when you
-- are done -- that comparison is the exercise.
--
--   mapF (+1) [1,2,3]       ==  [2,3,4]
--   filterF even [1,2,3,4]  ==  [2,4]
--
-- Hint for filterF: the combining function needs a conditional. Keep the head
-- or don't, then carry on with the rest.
-- ---------------------------------------------------------------------------

mapF :: (a -> b) -> [a] -> [b]
mapF = undefined

filterF :: (a -> Bool) -> [a] -> [a]
filterF = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (Hutton 7.4)
--
-- Convert a list of decimal digits into the number it represents, using foldl.
--
--   dec2int [2,3,4,5]  ==  2345
--   dec2int [7]        ==  7
--   dec2int []         ==  0
--
-- This is the exercise that shows you what foldl is FOR. Work left to right,
-- carrying a running total: each new digit means "multiply what I have by ten
-- and add the digit".
--
-- Try it with foldr afterwards and see how much worse it is. That difficulty
-- is the answer to "when do I use foldl?"
-- ---------------------------------------------------------------------------

dec2int :: [Int] -> Int
dec2int = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hutton 7.5)
--
-- Define curry and uncurry yourself.
--
--   curry' fst 1 2            ==  1
--   uncurry' (+) (3,4)        ==  7
--   map (uncurry' (+)) [(1,2),(3,4)]  ==  [3,7]
--
-- Read the types very slowly; they ARE the definitions. 'curry'' turns a
-- function on pairs into a curried function of two arguments, and 'uncurry''
-- goes the other way. Neither needs more than one short line.
--
-- 'uncurry' is genuinely useful: it is how you use a two-argument function
-- with 'map' over a list of pairs.
-- ---------------------------------------------------------------------------

curry' :: ((a, b) -> c) -> a -> b -> c
curry' = undefined

uncurry' :: (a -> b -> c) -> (a, b) -> c
uncurry' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 7  (composition)
--
-- 'twice f' applies f two times.
--
--   twice (+3) 1        ==  7
--   twice reverse [1,2] ==  [1,2]
--
-- 'sumOfSquaresOfEvens' is a pipeline: keep the even numbers, square them, add
-- them up. Write it POINT-FREE, with (.) and sections, and no lambda and no
-- named argument:
--
--   sumOfSquaresOfEvens [1,2,3,4]  ==  20        -- 4 + 16
--   sumOfSquaresOfEvens []         ==  0
--
-- Remember (.) reads RIGHT TO LEFT: 'f . g' does g first.
-- ---------------------------------------------------------------------------

twice :: (a -> a) -> a -> a
twice = undefined

sumOfSquaresOfEvens :: [Int] -> Int
sumOfSquaresOfEvens = undefined

-- ---------------------------------------------------------------------------
-- Exercise 8  (the binary string transmitter, from the chapter's worked
-- example)
--
-- Hutton's running example for the chapter. Bits are little-endian -- LEAST
-- significant first -- which looks backwards and makes bin2int much nicer.
--
--   bin2int [1,0,1,1]  ==  13       -- 1 + 2*0 + 4*1 + 8*1
--   int2bin 13         ==  [1,0,1,1]
--   int2bin 0          ==  []
--   make8 [1,0,1,1]    ==  [1,0,1,1,0,0,0,0]
--   chop8 (replicate 16 0) == [replicate 8 0, replicate 8 0]
--   encodeB "abc"      ==  <24 bits>
--   decodeB (encodeB s) == s
--
-- Write bin2int with foldr. The neat version is one fold and no arithmetic on
-- indices -- if you find yourself writing 'zip bits [0..]' and powers of two,
-- you have the ugly version; it is correct, but look at the fold afterwards.
--
-- 'encodeB' and 'decodeB' should be compositions, not recursions.
-- ---------------------------------------------------------------------------

type Bit = Int

bin2int :: [Bit] -> Int
bin2int = undefined

int2bin :: Int -> [Bit]
int2bin = undefined

make8 :: [Bit] -> [Bit]
make8 = undefined

chop8 :: [Bit] -> [[Bit]]
chop8 = undefined

encodeB :: String -> [Bit]
encodeB = undefined

decodeB :: [Bit] -> String
decodeB = undefined

-- ---------------------------------------------------------------------------
-- Exercise 9  (Hutton 7.6)
--
-- 'unfold p h t' is the mirror image of a fold: instead of consuming a list it
-- PRODUCES one. Stop when p holds; otherwise emit 'h x' and continue from
-- 't x'.
--
--   unfold (== 10) id (+1) 0   ==  [0,1,2,3,4,5,6,7,8,9]
--   unfold null head tail [1,2,3]  ==  [1,2,3]
--
-- Then redefine two things with it -- and notice that chop8 from exercise 8 is
-- also an unfold, which is the actual point of Hutton 7.6:
--
--   mapU (+1) [1,2,3]      ==  [2,3,4]
--   iterateU (*2) 1        ==  [1,2,4,8,...]     -- infinite; test with take
--
-- 'iterateU' never stops, so its predicate must never hold. 'const False' is
-- the function that ignores its argument and returns False.
-- ---------------------------------------------------------------------------

unfold :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold = undefined

mapU :: (a -> b) -> [a] -> [b]
mapU = undefined

iterateU :: (a -> a) -> a -> [a]
iterateU = undefined

-- ---------------------------------------------------------------------------
-- Exercise 10  (Hutton 7.9 and 7.10)
--
-- 'altMap' applies two functions to ALTERNATE elements, starting with the
-- first function.
--
--   altMap (+10) (+100) [0,1,2,3,4]  ==  [10,101,12,103,14]
--   altMap (+10) (+100) []           ==  []
--
-- Then use it to write the Luhn algorithm properly. In week 3 you wrote 'luhn'
-- for exactly four digits; this version takes any number of them.
--
--   luhn [1,7,8,4]          ==  True
--   luhn [4,7,8,3]          ==  False
--   luhn [1,7,8,4,1,7,8,4]  ==  True    -- two valid blocks; still valid
--   luhn [1,7,8,4,1,7,8,5]  ==  False
--
-- The rule: working from the RIGHT, double every second digit (subtracting 9
-- if the result exceeds 9), sum everything, and check divisibility by 10.
-- 'reverse', 'altMap', 'sum' -- and the composition operator.
-- ---------------------------------------------------------------------------

altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap = undefined

luhnDouble :: Int -> Int
luhnDouble = undefined

luhn :: [Int] -> Bool
luhn = undefined
