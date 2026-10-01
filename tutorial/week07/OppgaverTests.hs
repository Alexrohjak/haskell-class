module Main where

import Check
import Oppgaver hiding (main)
import qualified Oppgaver

import Control.Exception (ErrorCall (..), SomeException, fromException, throwIO, try)
import Data.Char (isDigit, isSpace)
import Data.List (isInfixOf, isPrefixOf)
import GHC.IO.Handle (hDuplicate, hDuplicateTo)
import System.Environment (lookupEnv)
import System.IO
import System.IO.Error (isEOFError)
import System.Timeout (timeout)

-- ---------------------------------------------------------------------------
-- Running an IO action with stdin fed from a string and stdout captured.
--
-- Only base is visible to runghc here (no 'directory' package), so the files
-- this needs have fixed names in $TMPDIR (or /tmp) and are overwritten on
-- every run rather than deleted: five small files, never more.
-- ---------------------------------------------------------------------------

tmpFile :: String -> IO FilePath
tmpFile name = do
  dir <- maybe "/tmp" id <$> lookupEnv "TMPDIR"
  pure (dir ++ "/inf122-oppg7-" ++ name)

-- | What happened when an action ran.
data Run = Printed String   -- it returned; this is everything it printed
         | WantedMore       -- it read past the end of the input we gave it
         | TimedOut         -- it ran for 5 seconds without returning
         | Crashed String   -- it threw something else

-- | Run an action with the given text as stdin. An action still containing
-- 'undefined' rethrows, so the check that uses the result reports todo.
runWith :: String -> IO () -> IO Run
runWith input act = do
  inPath  <- tmpFile "stdin.txt"
  outPath <- tmpFile "stdout.txt"
  writeFile inPath input
  hOut <- openFile outPath WriteMode
  hFlush stdout
  oldIn  <- hDuplicate stdin
  oldOut <- hDuplicate stdout
  inH <- openFile inPath ReadMode
  hDuplicateTo inH stdin
  hDuplicateTo hOut stdout
  r <- try (timeout 5000000 act) :: IO (Either SomeException (Maybe ()))
  hFlush stdout
  hDuplicateTo oldIn stdin
  hDuplicateTo oldOut stdout
  hClose inH >> hClose hOut >> hClose oldIn >> hClose oldOut
  out <- readFile' outPath
  case r of
    Right (Just ()) -> pure (Printed out)
    Right Nothing   -> pure TimedOut
    Left e
      | Just (ErrorCall m) <- fromException e
      , "Prelude.undefined" `isPrefixOf` m -> throwIO e
      | Just ioe <- fromException e, isEOFError ioe -> pure WantedMore
      | otherwise -> pure (Crashed (show e))

-- | Judge a run. "ok", or what went wrong -- check compares against "ok", so a
-- wrong answer prints the reason, and an 'undefined' inside is a todo.
judge :: (String -> Maybe String) -> Run -> String
judge verdict (Printed out) = maybe "ok" id (verdict out)
judge _ WantedMore          = "asked for more input than the test gave it"
judge _ TimedOut            = "still running after 5 seconds"
judge _ (Crashed e)         = "crashed: " ++ e

-- | A check of an IO action: feed it input, judge what it printed.
ioCheck :: String -> String -> IO () -> (String -> Maybe String) -> IO (String, Result)
ioCheck name input act verdict = do
  r <- try (runWith input act) :: IO (Either SomeException Run)
  check name (either (\e -> errorWithoutStackTrace (show e)) (judge verdict) r) "ok"

-- | The printed results must appear as numbers, in this order (anything else
-- may be printed around them, even with no space in between), and none of
-- the forbidden ones may appear.
results :: [String] -> [String] -> String -> Maybe String
results want forbidden out
  | not (want `inOrderIn` ws) = Just ("didn't print " ++ unwords want ++ " in that order; printed " ++ show out)
  | any (`elem` ws) forbidden = Just ("printed " ++ unwords forbidden ++ ", from input after the stop; printed " ++ show out)
  | otherwise                 = Nothing
  where ws = numbersIn out

-- | Every whole number in a string, with its minus sign: "Svar:-147." gives
-- ["-147"].
numbersIn :: String -> [String]
numbersIn [] = []
numbersIn ('-':c:cs) | isDigit c = let (d, rest) = span isDigit (c:cs) in ('-':d) : numbersIn rest
numbersIn (c:cs)
  | isDigit c = let (d, rest) = span isDigit (c:cs) in d : numbersIn rest
  | otherwise = numbersIn cs

inOrderIn :: [String] -> [String] -> Bool
inOrderIn [] _ = True
inOrderIn _ [] = False
inOrderIn (w:want) (x:xs)
  | w == x    = inOrderIn want xs
  | otherwise = inOrderIn (w:want) xs

-- | What main printed must contain this, once spaces are taken out.
shows' :: String -> String -> Maybe String
shows' want out
  | want `isInfixOf` filter (not . isSpace) out = Nothing
  | otherwise = Just ("didn't print " ++ want ++ " (spaces ignored); printed " ++ show out)

-- ---------------------------------------------------------------------------
-- Files for lesev and les.
-- ---------------------------------------------------------------------------

-- | Write the input file, run the action with stdin built from the two file
-- names, and judge the output file's lines.
fileCheck :: String -> [String] -> (FilePath -> FilePath -> String) -> IO () -> [String]
          -> IO (String, Result)
fileCheck name inLines stdinFor act want = do
  a <- tmpFile "a.txt"
  b <- tmpFile "b.txt"
  writeFile a (unlines inLines)
  writeFile b ""
  r <- try (runWith (stdinFor a b) act) :: IO (Either SomeException Run)
  got <- readFile' b
  let verdict _ | map trim (filter (not . all isSpace) (lines got)) == want = Nothing
                | otherwise = Just ("file (b) should hold " ++ show want ++ " one per line; it holds " ++ show got)
  check name (either (\e -> errorWithoutStackTrace (show e)) (judge verdict) r) "ok"
  where trim = reverse . dropWhile isSpace . reverse . dropWhile isSpace

main :: IO ()
main = runTests "Week 7 -- oppgaver uke7"
  [ ioCheck "expr: evaluates each line, stops at 0"
      "12 5 * 1 -\n0\n5 5 +\n" (expr "1 2 +")
      (results ["59"] ["10"])
  , ioCheck "expr: several expressions in a row"
      "1 2 3 * +\n1 22 - 7 *\n1 22 7 * -\n0\n" (expr "1 2 +")
      (results ["7", "-147", "-153"] [])
  , ioCheck "expr: 0 straight away stops it"
      "0\n5 5 +\n" (expr "1 2 +")
      (results [] ["10"])

  , fileCheck "lesev: one result per line into file (b)"
      ["1 2 3 * +", "12 5 * 1 -", "1 22 - 7 *"]
      (\a b -> a ++ "\n" ++ b ++ "\n") lesev
      ["7", "59", "-147"]
  , fileCheck "lesev: a single line"
      ["20 4 /"]
      (\a b -> a ++ "\n" ++ b ++ "\n") lesev
      ["5"]

  , ioCheck "main: exp evaluates, q stops"
      "exp 1 2 3 * +\nexp 12 5 * 1 -\nq\nexp 5 5 +\n" Oppgaver.main
      (results ["7", "59"] ["10"])
  , ioCheck "main: q straight away stops it"
      "q\nexp 5 5 +\n" Oppgaver.main
      (results [] ["10"])
  , fileCheck "main: les fil-a fil-b runs lesev's job"
      ["1 2 3 * +", "1 22 7 * -"]
      (\a b -> "les " ++ a ++ " " ++ b ++ "\nq\n") Oppgaver.main
      ["7", "-153"]

  , ioCheck "main: pre 1 2 3 * +"         "pre 1 2 3 * +\nq\n"   Oppgaver.main (shows' "+1*23")
  , ioCheck "main: pre 1 22 - 7 *"        "pre 1 22 - 7 *\nq\n"  Oppgaver.main (shows' "*-1227")
  , ioCheck "main: pre 12 5 * 1 -"        "pre 12 5 * 1 -\nq\n"  Oppgaver.main (shows' "-*1251")

  , ioCheck "main: inf 1 22 - 7 *  ->  (1-22)*7" "inf 1 22 - 7 *\nq\n" Oppgaver.main (shows' "(1-22)*7")
  , ioCheck "main: inf 1 22 7 * -  ->  1-22*7"   "inf 1 22 7 * -\nq\n" Oppgaver.main (shows' "1-22*7")
  , ioCheck "main: inf 1 2 + 3 *  ->  (1+2)*3"   "inf 1 2 + 3 *\nq\n"  Oppgaver.main (shows' "(1+2)*3")
  , ioCheck "main: inf 2 3 * 4 +  ->  2*3+4"     "inf 2 3 * 4 +\nq\n"  Oppgaver.main (shows' "2*3+4")
  , ioCheck "main: inf 1 2 - 3 -  ->  1-2-3"     "inf 1 2 - 3 -\nq\n"  Oppgaver.main (shows' "1-2-3")
  , ioCheck "main: inf 1 2 3 - -  ->  1-(2-3)"   "inf 1 2 3 - -\nq\n"  Oppgaver.main (shows' "1-(2-3)")
  , ioCheck "main: inf 8 4 / 2 /  ->  8/4/2"     "inf 8 4 / 2 /\nq\n"  Oppgaver.main (shows' "8/4/2")
  , ioCheck "main: inf 8 4 2 / /  ->  8/(4/2)"   "inf 8 4 2 / /\nq\n"  Oppgaver.main (shows' "8/(4/2)")
  ]
