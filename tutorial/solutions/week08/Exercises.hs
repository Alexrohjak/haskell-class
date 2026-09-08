-- | Week 8 reference solutions.
module Exercises where

import Data.Char (isDigit)

-- Exercise 1. do-notation sequences actions; 'return' packages a value into an
-- action that does nothing else.
pairIO :: IO a -> IO b -> IO (a, b)
pairIO ax ay = do
  x <- ax
  y <- ay
  return (x, y)

-- The base case must still be an ACTION, hence 'return []' rather than [].
sequenceIO :: [IO a] -> IO [a]
sequenceIO []     = return []
sequenceIO (a:as) = do
  x  <- a
  xs <- sequenceIO as
  return (x : xs)

mapMIO :: (a -> IO b) -> [a] -> IO [b]
mapMIO f xs = sequenceIO (map f xs)

-- Exercise 2. Two versions of the same thing.
putStrRec :: String -> IO ()
putStrRec []     = return ()
putStrRec (c:cs) = do
  putChar c
  putStrRec cs

-- 'mapM_' runs an action for each element and discards the results, which is
-- exactly what printing wants.
putStr' :: String -> IO ()
putStr' = mapM_ putChar

putStrLn' :: String -> IO ()
putStrLn' s = do
  putStr' s
  putChar '\n'

-- Exercise 3. The rules of Nim, with no IO in sight.
type NimBoard = [Int]

initialNim :: NimBoard
initialNim = [5,4,3,2,1]

next :: Int -> Int
next 1 = 2
next _ = 1

finished :: NimBoard -> Bool
finished = all (== 0)

-- Rows count from 1, so the index is row - 1. The range check has to come
-- first: without it, an out-of-range row makes (!!) crash rather than return
-- False.
valid :: NimBoard -> Int -> Int -> Bool
valid board row num =
  row >= 1 && row <= length board && num >= 1 && board !! (row - 1) >= num

move :: NimBoard -> Int -> Int -> NimBoard
move board row num = [update r n | (r, n) <- zip [1 ..] board]
  where update r n = if r == row then n - num else n

-- Exercise 4. Build the string; let the caller print it.
showRow :: Int -> Int -> String
showRow row n = show row ++ ": " ++ unwords (replicate n "*")

-- 'unlines' would add a trailing newline; 'intercalate "\n"' is what we want,
-- and this is it written with the Prelude only.
showBoard :: NimBoard -> String
showBoard board =
  foldr1 (\a b -> a ++ "\n" ++ b) [showRow r n | (r, n) <- zip [1 ..] board]

-- Exercise 5. A whole game as a fold: invalid moves leave the board alone.
playMoves :: NimBoard -> [(Int, Int)] -> NimBoard
playMoves = foldl apply
  where apply b (row, num)
          | valid b row num = move b row num
          | otherwise       = b

-- Exercise 6.
match :: String -> String -> String
match secret guessed = [if c `elem` guessed then c else '-' | c <- secret]

won :: String -> String -> Bool
won secret guessed = match secret guessed == secret

-- Exercise 7. All the messiness of user input, in a pure function.
parseMove :: String -> Maybe (Int, Int)
parseMove s = case words s of
  [a, b] | isNum a && isNum b -> Just (read a, read b)
  _                           -> Nothing
  where isNum t = not (null t) && all isDigit t

-- Exercise 8. The Game of Life.
type Pos = (Int, Int)
type LifeBoard = [Pos]

width, height :: Int
width  = 10
height = 10

rmdups :: Eq a => [a] -> [a]
rmdups []     = []
rmdups (x:xs) = x : rmdups (filter (/= x) xs)

-- Shift down by one so 'mod' works on a 0-based range, then shift back.
wrap :: Pos -> Pos
wrap (x, y) = (((x - 1) `mod` width) + 1, ((y - 1) `mod` height) + 1)

neighbs :: Pos -> [Pos]
neighbs (x, y) = map wrap
  [ (x-1, y-1), (x, y-1), (x+1, y-1)
  , (x-1, y  ),           (x+1, y  )
  , (x-1, y+1), (x, y+1), (x+1, y+1) ]

liveneighbs :: LifeBoard -> Pos -> Int
liveneighbs b = length . filter (`elem` b) . neighbs

survivors :: LifeBoard -> [Pos]
survivors b = [p | p <- b, liveneighbs b p `elem` [2,3]]

-- Only cells next to a live one can be born, so that is the only list worth
-- searching -- checking all 100 positions would also work and is slower.
births :: LifeBoard -> [Pos]
births b =
  [ p | p <- rmdups (concatMap neighbs b)
      , not (p `elem` b)
      , liveneighbs b p == 3 ]

nextgen :: LifeBoard -> LifeBoard
nextgen b = survivors b ++ births b
