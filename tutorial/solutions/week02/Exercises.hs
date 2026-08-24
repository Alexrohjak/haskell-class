-- | Week 2 reference solutions.
module Exercises where

-- Exercise 1. Any values of the right type. The trap is 'nums': the type is
-- [[Int]], so every element must itself be a list.
bools :: [Bool]
bools = [True, False, True]

nums :: [[Int]]
nums = [[1,2,3], [4,5], []]

-- Exercise 2. Curried: three arrows means add3 1 has type Int -> Int -> Int.
add3 :: Int -> Int -> Int -> Int
add3 x y z = x + y + z

-- Exercise 3. Parametricity: the type variable is opaque, so copying is the
-- only thing available. There is essentially one inhabitant of this type.
copy :: a -> (a, a)
copy x = (x, x)

-- Exercise 4. Also nearly forced by its type. This is the Prelude's ($).
apply :: (a -> b) -> a -> b
apply f x = f x

-- Exercise 5.
second :: [a] -> a
second xs = head (tail xs)

swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

pair :: a -> b -> (a, b)
pair x y = (x, y)

double :: Num a => a -> a
double x = x * 2

palindrome :: Eq a => [a] -> Bool
palindrome xs = reverse xs == xs

twice :: (a -> a) -> a -> a
twice f x = f (f x)

-- Exercise 6. 'Ord a =>' is exactly what licenses the use of (>).
-- Without it: "No instance for (Ord a) arising from a use of '>'".
largest :: Ord a => [a] -> a
largest [x]    = x
largest (x:xs) = if x > rest then x else rest
  where rest = largest xs
largest []     = error "largest: empty list"

-- Exercise 7. 'read' needs to know what type to parse into; here it is fixed
-- by the signature, since the argument and result share the variable a.
roundTrip :: (Show a, Read a) => a -> a
roundTrip = read . show

-- Exercise 8. Two classes, one variable: Ord for the comparison, Show to
-- render the values.
describe :: (Show a, Ord a) => a -> a -> String
describe x y
  | x < y     = show x ++ " is smaller than " ++ show y
  | x > y     = show x ++ " is bigger than "  ++ show y
  | otherwise = show x ++ " is equal to "     ++ show y
