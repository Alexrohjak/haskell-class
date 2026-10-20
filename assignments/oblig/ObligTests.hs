-- | Checks for the oblig: only what the PDF itself specifies.
--
--     ./tutorial/check.sh oblig
--
-- The PDF fixes the *names* of the Ast constructors but not their arguments,
-- and fixes only one constructor of Type (NumT). So these tests cannot build
-- an Ast or a Type of their own, and tokenise, parse, occursIn and unify are
-- only reached through typeOf. They will go green late and all at once; test
-- the pieces yourself in GHCi on the way (`./tutorial/check.sh oblig --repl`).
--
-- What is checked:
--
--   * typeOf on every example the PDF gives a type or an error for. A type is
--     compared through your Show instance, the way the PDF prints it:
--     NumT, ->, brackets. Spaces don't matter, redundant brackets don't
--     matter, and the names of type variables don't matter -- t0->t0 and
--     t7->t7 are the same answer, t0->t1 is not.
--   * main, run the way the PDF describes: t, f and q fed in on stdin. Only
--     that the right types come out and that q ends it; the exact wording of
--     your output is yours.
--
-- Every typeOf check has a 5-second limit, so a unify that loops shows up as
-- a FAIL rather than a hang.
module Main where

import Check
import Oblig hiding (main)

import Control.Exception (ErrorCall (..), PatternMatchFail (..), SomeException, evaluate,
                          fromException, throwIO, try)
import Data.Char (isAlphaNum, isSpace, toLower)
import Data.List (inits, isInfixOf, isPrefixOf, tails)
import System.Directory (getTemporaryDirectory, removeFile)
import System.Environment (lookupEnv)
import System.Exit (ExitCode (..))
import System.IO (hClose, hPutStr, openTempFile)
import System.Process (proc, readCreateProcessWithExitCode)
import System.Timeout (timeout)

-- ---------------------------------------------------------------------------
-- Reading a printed type back in, so the comparison doesn't depend on
-- spacing, extra brackets or what you called your type variables.
-- ---------------------------------------------------------------------------

data T = TNum | TV String | TArr T T deriving Eq

tokens :: String -> Maybe [String]
tokens [] = Just []
tokens ('-':'>':cs) = ("->" :) <$> tokens cs
tokens (c:cs)
  | isSpace c     = tokens cs
  | c `elem` "()" = ([c] :) <$> tokens cs
  | isAlphaNum c  = let (w, rest) = span isAlphaNum (c:cs) in (w :) <$> tokens rest
  | otherwise     = Nothing

pType :: [String] -> Maybe (T, [String])
pType ts = do
  (a, rest) <- pAtom ts
  case rest of
    "->" : rest' -> do (b, rest'') <- pType rest'
                       Just (TArr a b, rest'')
    _            -> Just (a, rest)

pAtom :: [String] -> Maybe (T, [String])
pAtom ("(" : ts) = do
  (a, rest) <- pType ts
  case rest of
    ")" : rest' -> Just (a, rest')
    _           -> Nothing
pAtom ("NumT" : ts) = Just (TNum, ts)
pAtom (w : ts) | all isAlphaNum w = Just (TV w, ts)
pAtom _ = Nothing

readT :: String -> Maybe T
readT s = do
  ts <- tokens s
  (t, rest) <- pType ts
  if null rest then Just t else Nothing

-- | Same shape, and the variables correspond one-to-one.
sameUpToNames :: T -> T -> Bool
sameUpToNames a b = maybe False (const True) (go a b [])
  where
    go TNum TNum m = Just m
    go (TV x) (TV y) m = case (lookup x m, lookup y [(v, u) | (u, v) <- m]) of
      (Nothing, Nothing) -> Just ((x, y) : m)
      (Just y', Just x') | y' == y && x' == x -> Just m
      _ -> Nothing
    go (TArr a1 b1) (TArr a2 b2) m = go a1 a2 m >>= go b1 b2
    go _ _ _ = Nothing

-- | One of the types written in this file.
expected :: String -> T
expected want = maybe (errorWithoutStackTrace ("test bug: " ++ want)) id (readT want)

squash :: String -> String
squash = filter (not . isSpace)

-- ---------------------------------------------------------------------------
-- Running typeOf: a time limit, and an error of your own told apart from a
-- stub, a missing case and a loop.
-- ---------------------------------------------------------------------------

data Outcome = Gave String      -- show (typeOf s)
             | Refused String   -- it called error, with this message
             | NoCase String    -- a pattern-match failure
             | TimedOut
             | Crashed String

-- | A stub still containing 'undefined' rethrows, so the check reports todo.
runTypeOf :: String -> IO Outcome
runTypeOf s = do
  r <- try (timeout 5000000 (evaluate (force (show (typeOf s)))))
         :: IO (Either SomeException (Maybe String))
  case r of
    Right (Just t) -> pure (Gave t)
    Right Nothing  -> pure TimedOut
    Left e
      | Just (ErrorCall m) <- fromException e ->
          if "Prelude.undefined" `isPrefixOf` m then throwIO e else pure (Refused m)
      | Just (PatternMatchFail m) <- fromException e -> pure (NoCase m)
      | otherwise -> pure (Crashed (show e))
  where force t = length t `seq` t

typeOfCheck :: String -> String -> (Outcome -> String) -> IO (String, Result)
typeOfCheck name s verdict = do
  r <- try (runTypeOf s) :: IO (Either SomeException Outcome)
  check name (either (\e -> errorWithoutStackTrace (show e)) verdict r) "ok"

typeOfGives :: String -> String -> IO (String, Result)
typeOfGives s want = typeOfCheck ("typeOf " ++ show s ++ " gives " ++ want) s verdict
  where
    wantT = expected want
    verdict (Gave t) = case readT t of
      Just t' | sameUpToNames t' wantT -> "ok"
              | otherwise -> "gave " ++ t ++ ", expected " ++ want ++ " (up to variable names)"
      Nothing -> "show gave " ++ show t ++ ", which doesn't read as a type the way the PDF prints them"
    verdict (Refused m) = "error " ++ show (firstLine m) ++ ", but this has type " ++ want
    verdict (NoCase m)  = "pattern-match failure (" ++ firstLine m ++ ")"
    verdict TimedOut    = "still running after 5 seconds"
    verdict (Crashed e) = "crashed: " ++ e

-- | The second argument, if given, must appear in the message (any case).
typeOfFails :: String -> String -> Maybe String -> IO (String, Result)
typeOfFails what s mention = typeOfCheck ("typeOf " ++ show s ++ " is an error (" ++ what ++ ")") s verdict
  where
    verdict (Refused m) = case mention of
      Just w | not (w `isInfixOf` map toLower m) ->
        "the error should say what went wrong (" ++ w ++ "); it said " ++ show (firstLine m)
      _ -> "ok"
    verdict (Gave t)    = "gave " ++ t ++ ", but this should be an error"
    verdict (NoCase m)  = "failed with a pattern-match error, not an error message of your own (" ++ firstLine m ++ ")"
    verdict TimedOut    = "still running after 5 seconds"
    verdict (Crashed e) = "crashed: " ++ e

firstLine :: String -> String
firstLine = takeWhile (/= '\n')

-- ---------------------------------------------------------------------------
-- Running main the way the graders will: `main` in GHCi, commands on stdin.
-- ---------------------------------------------------------------------------

obligFile :: IO FilePath
obligFile = maybe "assignments/oblig/Oblig.hs" id <$> lookupEnv "OBLIG_FILE"

-- | Run main with this stdin: exit code, stdout, stderr. Nothing = timed
-- out. A stub rethrows, so the check reports todo.
runMain :: String -> IO (Maybe (ExitCode, String, String))
runMain input = do
  file <- obligFile
  r <- timeout 60000000 (readCreateProcessWithExitCode (proc "ghc" ["-v0", "-w", "-e", "main", file]) input)
  case r of
    Just (_, _, err) | "Prelude.undefined" `isInfixOf` err -> errorWithoutStackTrace "main is a stub"
    _ -> pure r

mainCheck :: String -> String -> (String -> String) -> IO (String, Result)
mainCheck name input verdict = do
  r <- try (runMain input) :: IO (Either SomeException (Maybe (ExitCode, String, String)))
  check name (either (\e -> errorWithoutStackTrace (show e)) v r) "ok"
  where
    v Nothing = "still running after 60 seconds -- did q end the loop?"
    v (Just (ExitFailure _, _, err)) = "main ended with an error: " ++ ghciError err
    v (Just (ExitSuccess, out, _)) = verdict out

-- | The exception GHCi reported, without the call stack after it.
ghciError :: String -> String
ghciError err = case [l | l <- lines err, "<interactive>" `isPrefixOf` l] of
  l : _ -> l
  []    -> firstLine err

-- | What main printed, for a failure message.
excerpt :: String -> String
excerpt out = "it printed:\n" ++ unlines (map ("            " ++) (take 6 (lines out)))

-- | Some line contains the expression and, somewhere in it, the type --
-- read the same lenient way as typeOf's answers.
lineWith :: String -> String -> String -> Bool
lineWith expr want out = any ok (lines out)
  where
    wantT = expected want
    ok l = squash expr `isInfixOf` squash l
           && or [ maybe False (sameUpToNames wantT) (readT piece)
                 | rest <- tails l, piece <- inits rest, not (null piece) ]

mainT :: IO (String, Result)
mainT = mainCheck "main: t |x -> x+x  prints NumT->NumT, then q ends it" "t |x -> x+x\nq\n" verdict
  where verdict out | lineWith "" "NumT->NumT" out = "ok"
                    | otherwise = "no line with the type NumT->NumT; " ++ excerpt out

mainF :: IO (String, Result)
mainF = do
  dir <- getTemporaryDirectory
  (path, h) <- openTempFile dir "oblig-exprs.txt"
  hPutStr h (unlines (map fst exprs)) >> hClose h
  r <- mainCheck "main: f <file>  prints one line per expression with its type" ("f " ++ path ++ "\nq\n") verdict
  removeFile path
  pure r
  where
    exprs = [ ("5",               "NumT")
            , ("|x -> x+x",       "NumT->NumT")
            , ("|a -> |b -> a+b", "NumT->NumT->NumT") ]
    verdict out = case [e | (e, t) <- exprs, not (lineWith e t out)] of
      []      -> "ok"
      missing -> "no line with both the expression and its type for " ++ show missing ++ "; " ++ excerpt out

mainQ :: IO (String, Result)
mainQ = mainCheck "main: q on its own returns" "q\n" (const "ok")

main :: IO ()
main = runTests "Oblig -- INF122 H-2026"
  -- 3.3, the table of examples
  [ typeOfFails "a free variable" "x" Nothing
  , typeOfGives "|x -> x"               "t0->t0"
  , typeOfGives "|x -> x+x"             "NumT->NumT"
  , typeOfGives "[|a -> a+3 4]"         "NumT"
  , typeOfGives "|a -> a + [|b -> b 2]" "NumT->NumT"
  , typeOfGives "|f -> [f 2]"           "(NumT->t1)->t1"
  , typeOfGives "|f -> |a -> [f a]"     "(t2->t3)->t2->t3"
  , typeOfFails "occurs-check" "|a -> [a a]" (Just "occurs")

  -- the introduction's examples
  , typeOfGives "5"                       "NumT"
  , typeOfGives "[|a->a+1 3]"             "NumT"
  , typeOfGives "|a->a+2"                 "NumT->NumT"
  , typeOfGives "|a->|b->a+b"             "NumT->NumT->NumT"
  , typeOfGives "[[|a -> |b -> a+b 2] 3]" "NumT"
  , typeOfFails "[4 5] is correct but not well-typed" "[4 5]" Nothing

  -- 4, the interaction
  , mainT
  , mainF
  , mainQ
  ]
