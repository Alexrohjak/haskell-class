-- | Week 3 reference solutions.
module Exercises where

-- Exercise 1.
halve :: [a] -> ([a], [a])
halve xs = (take n xs, drop n xs)
  where n = length xs `div` 2

-- Exercise 2. Match the first three cells directly; '_' means "some value I
-- am not going to name".
thirdPat :: [a] -> a
thirdPat (_:_:x:_) = x
thirdPat _         = error "thirdPat: list too short"

-- Exercise 3, three ways.
safetailCond :: [a] -> [a]
safetailCond xs = if null xs then [] else tail xs

safetailGuard :: [a] -> [a]
safetailGuard xs
  | null xs   = []
  | otherwise = tail xs

safetailPat :: [a] -> [a]
safetailPat []     = []
safetailPat (_:xs) = xs

-- Exercise 4. Four equations, one per case...
myOr :: Bool -> Bool -> Bool
myOr False False = False
myOr False True  = True
myOr True  False = True
myOr True  True  = True

-- ...but three of the four agree, and when the first argument is True the
-- second is irrelevant. Two equations suffice.
myOr2 :: Bool -> Bool -> Bool
myOr2 True  _ = True
myOr2 False b = b

-- Exercise 5. One conditional. The insight: if the first argument is True the
-- answer IS the second argument; if it is False the answer is False.
myAnd :: Bool -> Bool -> Bool
myAnd x y = if x then y else False

-- Exercise 6. Exactly what 'mult3 x y z = x * y * z' desugars to.
mult3 :: Int -> Int -> Int -> Int
mult3 = \x -> \y -> \z -> x * y * z

-- Exercise 7.
luhnDouble :: Int -> Int
luhnDouble x
  | d > 9     = d - 9
  | otherwise = d
  where d = 2 * x

luhn :: Int -> Int -> Int -> Int -> Bool
luhn a b c d = total `mod` 10 == 0
  where total = luhnDouble a + b + luhnDouble c + d

-- Exercise 8. Guards are tried top to bottom; 'otherwise' is just True, so it
-- always matches and must come last.
grade :: Int -> Char
grade s
  | s >= 90   = 'A'
  | s >= 80   = 'B'
  | s >= 70   = 'C'
  | s >= 60   = 'D'
  | s >= 50   = 'E'
  | otherwise = 'F'
