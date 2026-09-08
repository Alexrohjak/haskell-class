-- | Week 6 reference solutions.
module Exercises where

import Data.Char (chr, ord)

-- Exercise 1. The recursive originals, for comparison with exercise 4.
map' :: (a -> b) -> [a] -> [b]
map' _ []     = []
map' f (x:xs) = f x : map' f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' p (x:xs)
  | p x       = x : filter' p xs
  | otherwise = filter' p xs

-- Exercise 2. Base cases are identity elements again: True for (&&), False
-- for (||).
all' :: (a -> Bool) -> [a] -> Bool
all' _ []     = True
all' p (x:xs) = p x && all' p xs

any' :: (a -> Bool) -> [a] -> Bool
any' _ []     = False
any' p (x:xs) = p x || any' p xs

-- Stops at the first failure -- it does not filter the rest.
takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' p (x:xs)
  | p x       = x : takeWhile' p xs
  | otherwise = []

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' p (x:xs)
  | p x       = dropWhile' p xs
  | otherwise = x : xs

-- Exercise 3. The whole drill is "what is the answer for [], and how do I
-- combine the head with the answer for the tail".
sumF :: [Int] -> Int
sumF = foldr (+) 0

productF :: [Int] -> Int
productF = foldr (*) 1

-- The combining function ignores the element and just counts.
lengthF :: [a] -> Int
lengthF = foldr (\_ n -> 1 + n) 0

-- Each element goes on the END of the reversed tail. Correct, and quadratic --
-- see the lesson.
reverseF :: [a] -> [a]
reverseF = foldr (\x xs -> xs ++ [x]) []

andF :: [Bool] -> Bool
andF = foldr (&&) True

-- Exercise 4. Both are folds whose combining function rebuilds a list.
mapF :: (a -> b) -> [a] -> [b]
mapF f = foldr (\x xs -> f x : xs) []

filterF :: (a -> Bool) -> [a] -> [a]
filterF p = foldr (\x xs -> if p x then x : xs else xs) []

-- Exercise 5. foldl carries a running total left to right: this is the natural
-- direction for place-value arithmetic, and foldr is awkward here.
dec2int :: [Int] -> Int
dec2int = foldl (\acc d -> 10 * acc + d) 0

-- Exercise 6. The types are the definitions.
curry' :: ((a, b) -> c) -> a -> b -> c
curry' f x y = f (x, y)

uncurry' :: (a -> b -> c) -> (a, b) -> c
uncurry' f (x, y) = f x y

-- Exercise 7.
twice :: (a -> a) -> a -> a
twice f = f . f

-- Point-free: read right to left. Keep the evens, square them, sum them.
sumOfSquaresOfEvens :: [Int] -> Int
sumOfSquaresOfEvens = sum . map (^ 2) . filter even

-- Exercise 8. The binary string transmitter.
type Bit = Int

-- Little-endian makes this a single fold: each step is "this bit, plus twice
-- whatever the rest came to". No powers of two, no indices.
bin2int :: [Bit] -> Int
bin2int = foldr (\b n -> b + 2 * n) 0

int2bin :: Int -> [Bit]
int2bin 0 = []
int2bin n = n `mod` 2 : int2bin (n `div` 2)

make8 :: [Bit] -> [Bit]
make8 bits = take 8 (bits ++ repeat 0)

chop8 :: [Bit] -> [[Bit]]
chop8 []   = []
chop8 bits = take 8 bits : chop8 (drop 8 bits)

encodeB :: String -> [Bit]
encodeB = concat . map (make8 . int2bin . ord)

decodeB :: [Bit] -> String
decodeB = map (chr . bin2int) . chop8

-- Exercise 9. The mirror image of a fold: it builds a list instead of
-- consuming one.
unfold :: (a -> Bool) -> (a -> b) -> (a -> a) -> a -> [b]
unfold p h t x
  | p x       = []
  | otherwise = h x : unfold p h t (t x)

mapU :: (a -> b) -> [a] -> [b]
mapU f = unfold null (f . head) tail

-- The predicate never holds, so the list never ends. Laziness makes that
-- usable rather than fatal -- see week 9.
iterateU :: (a -> a) -> a -> [a]
iterateU f = unfold (const False) id f

-- Exercise 10.
altMap :: (a -> b) -> (a -> b) -> [a] -> [b]
altMap _ _ []     = []
altMap f g (x:xs) = f x : altMap g f xs

luhnDouble :: Int -> Int
luhnDouble x
  | d > 9     = d - 9
  | otherwise = d
  where d = 2 * x

-- Reverse first, because the doubling is counted from the right. Then 'id' on
-- the last digit, luhnDouble on the one before, alternating outward.
luhn :: [Int] -> Bool
luhn = (== 0) . (`mod` 10) . sum . altMap id luhnDouble . reverse
