-- | Week 8 — Hutton ch. 10: interactive programming.
--
--     ./check.sh 8
--
-- The chapter that explains how a language with no side effects manages to
-- read a keyboard.
--
-- A NOTE ON HOW THIS WEEK IS TESTED. The harness compares pure values, and an
-- IO action that prints to the screen has no value to compare. That is not a
-- limitation of the harness so much as the shape of the chapter -- and the
-- response to it is the professional habit this week is really teaching:
--
--     Push all the thinking into PURE functions. Leave IO as a thin shell that
--     reads, calls them, and prints.
--
-- So most exercises below are the pure cores of interactive programs, and they
-- are tested exhaustively. Exercise 2 is IO you run by hand; its instructions
-- say how.
module Exercises where

import Data.Char (isDigit)

-- ---------------------------------------------------------------------------
-- Exercise 1  (the IO type, and what 'return' really does)
--
-- Three pieces of plumbing, defined with do-notation and 'return'.
--
--   pairIO (return 1) (return 'x')  runs both, gives (1,'x')
--   sequenceIO [return 1, return 2] runs both, gives [1,2]
--   mapMIO f xs                     applies f to each, collects the results
--
-- 'return' is NOT the 'return' of an imperative language. It does not jump out
-- of anything. It builds an action that does nothing and yields the value you
-- gave it -- read section 2 of LESSON.md before writing these.
--
-- Write all three with do-notation. 'sequenceIO' is recursive; note that its
-- base case must still be an ACTION, not a plain list.
-- ---------------------------------------------------------------------------

pairIO :: IO a -> IO b -> IO (a, b)
pairIO = undefined

sequenceIO :: [IO a] -> IO [a]
sequenceIO = undefined

mapMIO :: (a -> IO b) -> [a] -> IO [b]
mapMIO = undefined

-- ---------------------------------------------------------------------------
-- Exercise 2  (Hutton 10.1 — RUN THIS ONE BY HAND)
--
-- Define putStr yourself, from putChar. There are no automatic checks for
-- this: run it in the REPL and look at the screen.
--
--     ./check.sh 8 --repl
--     ghci> putStr' "hei\n"
--     ghci> putStrLn' "hei"
--
-- Write putStr' TWICE: once with explicit recursion, and once as a one-liner
-- using 'mapM_' and nothing else. Keep both -- the second is the idiomatic
-- answer and the comparison is the exercise.
--
-- The type is 'String -> IO ()'. '()' is the unit type, whose only value is
-- '()'. An action of type 'IO ()' is one you run for its EFFECT, because its
-- result carries no information.
-- ---------------------------------------------------------------------------

putStr' :: String -> IO ()
putStr' = undefined

putStrRec :: String -> IO ()
putStrRec = undefined

putStrLn' :: String -> IO ()
putStrLn' = undefined

-- ---------------------------------------------------------------------------
-- Exercise 3  (Nim: the rules, as pure functions)
--
-- Nim is played on a board of five rows of stars:
--
--     1: * * * * *
--     2: * * * *
--     3: * * *
--     4: * *
--     5: *
--
-- Players take turns removing any number of stars from a single row. Whoever
-- clears the board wins.
--
--   next 1              ==  2
--   next 2              ==  1
--   finished [0,0,0,0,0] ==  True
--   finished [0,0,1,0,0] ==  False
--   valid [5,4,3,2,1] 2 3  ==  True     -- row 2 has 4, taking 3 is fine
--   valid [5,4,3,2,1] 5 2  ==  False    -- row 5 only has 1
--   valid [5,4,3,2,1] 1 0  ==  False    -- must take at least one
--   move [5,4,3,2,1] 2 3   ==  [5,1,3,2,1]
--
-- Rows are numbered from 1, not 0 -- that off-by-one is where the bugs live,
-- so decide once where you convert and stick to it.
--
-- 'valid' must also reject an out-of-range row. 'move' may assume its move is
-- valid.
-- ---------------------------------------------------------------------------

type NimBoard = [Int]

initialNim :: NimBoard
initialNim = [5,4,3,2,1]

next :: Int -> Int
next = undefined

finished :: NimBoard -> Bool
finished = undefined

valid :: NimBoard -> Int -> Int -> Bool
valid = undefined

move :: NimBoard -> Int -> Int -> NimBoard
move = undefined

-- ---------------------------------------------------------------------------
-- Exercise 4  (Hutton 10.2/10.3 — the display, still pure)
--
-- Hutton's version prints as it goes, which makes it untestable. Build the
-- STRING instead, and let the IO shell print it. That one change is the whole
-- lesson of this week in miniature.
--
--   showRow 1 5     ==  "1: * * * * *"
--   showRow 5 0     ==  "5: "
--   showBoard [1,0] ==  "1: *\n2: "
--
-- 'unwords' joins strings with single spaces; 'unlines' joins with newlines
-- and adds a trailing one, which is NOT what showBoard wants -- look at the
-- expected value above and pick your joining function accordingly.
-- ---------------------------------------------------------------------------

showRow :: Int -> Int -> String
showRow = undefined

showBoard :: NimBoard -> String
showBoard = undefined

-- ---------------------------------------------------------------------------
-- Exercise 5  (a whole game, with no IO at all)
--
-- Apply a list of moves to a board, in order. An INVALID move is skipped --
-- the board is returned unchanged and play continues.
--
--   playMoves [5,4,3,2,1] [(2,3),(1,5)]  ==  [0,1,3,2,1]
--   playMoves [5,4,3,2,1] [(5,9)]        ==  [5,4,3,2,1]   -- invalid, skipped
--   playMoves b []                       ==  b
--
-- Note what this gets you: the entire game is now a pure function you can test
-- with a hundred move-lists in a second. The IO version can only be tested by
-- a human typing. Keep that difference in mind on the oblig.
-- ---------------------------------------------------------------------------

playMoves :: NimBoard -> [(Int, Int)] -> NimBoard
playMoves = undefined

-- ---------------------------------------------------------------------------
-- Exercise 6  (Hangman's pure core)
--
-- Show a secret word with only the guessed letters revealed.
--
--   match "haskell" "ael"   ==  "-a--ell"
--   match "haskell" ""      ==  "-------"
--   match "abc" "abc"       ==  "abc"
--
-- And decide when the game is over:
--
--   won "haskell" "haskell"  ==  True
--   won "haskell" "ael"      ==  False
--
-- One comprehension each. 'won' should be defined in terms of 'match' rather
-- than repeating its logic.
-- ---------------------------------------------------------------------------

match :: String -> String -> String
match = undefined

won :: String -> String -> Bool
won = undefined

-- ---------------------------------------------------------------------------
-- Exercise 7  (parsing input, which is always the messy part)
--
-- Reading a number from the keyboard means dealing with what the user actually
-- typed. Keep that pure too.
--
--   parseMove "2 3"    ==  Just (2,3)
--   parseMove "2"      ==  Nothing
--   parseMove "a b"    ==  Nothing
--   parseMove "  2  3 " ==  Just (2,3)
--   parseMove ""       ==  Nothing
--
-- 'words' splits on whitespace and handles the padding for you. 'all isDigit'
-- checks a string is a number -- and note that 'all isDigit ""' is True, which
-- is exactly the vacuous-truth trap from week 5, so guard against the empty
-- string yourself.
--
-- 'read' turns a String into an Int once you know it is safe.
-- ---------------------------------------------------------------------------

parseMove :: String -> Maybe (Int, Int)
parseMove = undefined

-- ---------------------------------------------------------------------------
-- Exercise 8  (the Game of Life, pure core)
--
-- The chapter's last example. The board is a list of the positions that are
-- ALIVE; everything else is empty. The grid wraps around at the edges.
--
--   wrap (0,1)      ==  (10,1)      -- off the left edge, back on the right
--   wrap (11,1)     ==  (1,1)
--   wrap (3,4)      ==  (3,4)       -- already inside, unchanged
--   length (neighbs (3,4))  ==  8
--   liveneighbs [(2,3),(3,3)] (2,3)  ==  1
--
-- A cell SURVIVES with 2 or 3 live neighbours; an empty cell is BORN with
-- exactly 3. 'nextgen' is survivors plus births.
--
--   nextgen [(2,3),(3,3),(4,3)]  ==  [(3,3),(3,2),(3,4)]
--
-- That last one is the blinker: a horizontal line of three becomes vertical.
-- Get the ORDER right -- survivors first, in board order, then births in the
-- order 'births' produces them. 'rmdups' is written for you.
-- ---------------------------------------------------------------------------

type Pos = (Int, Int)
type LifeBoard = [Pos]

width, height :: Int
width  = 10
height = 10

rmdups :: Eq a => [a] -> [a]
rmdups []     = []
rmdups (x:xs) = x : rmdups (filter (/= x) xs)

wrap :: Pos -> Pos
wrap = undefined

neighbs :: Pos -> [Pos]
neighbs = undefined

liveneighbs :: LifeBoard -> Pos -> Int
liveneighbs = undefined

survivors :: LifeBoard -> [Pos]
survivors = undefined

births :: LifeBoard -> [Pos]
births = undefined

nextgen :: LifeBoard -> LifeBoard
nextgen = undefined
