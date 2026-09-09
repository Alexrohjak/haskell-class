-- Uke 2 (uke35) — the lecturer's weekly sheet.
-- Problems: ../exercises/uke2.txt        How to check these: ../../../docs/checking-your-work.md
--
--   ghci weeks/uke35/code/Uke2.hs        -- this sheet is mostly a `:t` session
--   runghc weeks/uke35/code/Uke2.hs
--
-- Most of uke2 is paper work: tasks 1, 2, 4 and the counting in 5 are answered
-- with a pen, then confirmed here. Write your answer down FIRST, then ask GHC —
-- that order is the whole exercise. `:t` after guessing teaches you something;
-- `:t` instead of guessing teaches you nothing.
--
-- Note on the sheet itself: e3/e4 in task 2 are printed with typographic quotes
-- (“a” and ‘a’). They mean the ASCII "a" and 'a'.

module Main where

-- ---- task 2: fill in the signatures --------------------------------------
-- Write the type you believe is right, uncomment, and let GHC agree or not.
-- If GHC infers something MORE general than what you wrote, that gap is the
-- lesson — go back and see what you over-specified.

-- e1 :: ?
e1 = [False, True, False]

-- e2 :: ?
e2 = [[1,2],[3,4]]

-- e3 :: ?
e3 = [ ("a", 7) ]

-- e4 :: ?
e4 = [ ('a', 7) ]

-- e5 :: ?
e5 x = x * 2

-- e6 :: ?
e6 (x, y) = x

e7 :: a -> (a, a)
e7 = undefined

-- ---- task 3: most general type --------------------------------------------
-- Work each one out on paper, then uncomment it ONE AT A TIME and check with
-- `:t`. They are ordered by how much they will hurt.
--
-- One of these five cannot be typed in Haskell at all. Finding out which, and
-- being able to say why, is the point of the task — the error message is the
-- answer, so read it rather than deleting the line.

-- app f x = f x
-- com f g x = f (g x)
-- sub f g x = (f x) (g x)
-- fix f = f (fix f)
-- selv f = f f

-- ---- task 5: define every function of type Bool -> Bool -------------------
-- The counting part (1-10) is paper. This is the code part: list them all.
-- Add one stub per function you find; `table` and `sameFun` below are there to
-- check you have neither missed one nor written the same one twice.

allBoolFuns :: [Bool -> Bool]
allBoolFuns = undefined

-- ---- tools ----------------------------------------------------------------
-- A Bool -> Bool function is completely determined by these two rows, so this
-- is a total description of it, not a sample of it.

table :: (Bool -> Bool) -> [(Bool, Bool)]
table f = [ (b, f b) | b <- [False, True] ]

sameFun :: (Bool -> Bool) -> (Bool -> Bool) -> Bool
sameFun f g = table f == table g

-- True when your list has no duplicates in it.
allDistinct :: [Bool -> Bool] -> Bool
allDistinct fs = length ts == length (dedup ts)
  where
    ts = map table fs
    dedup [] = []
    dedup (x:xs) = x : dedup (filter (/= x) xs)

main :: IO ()
main = do
  mapM_ (print . table) allBoolFuns
  putStrLn ("count: " ++ show (length allBoolFuns))
  putStrLn ("all distinct: " ++ show (allDistinct allBoolFuns))
