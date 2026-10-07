module Main where

import Check
import Oppgaver

import Control.Exception (ErrorCall (..), PatternMatchFail (..), SomeException, evaluate,
                          fromException, throwIO, try)
import Data.Char (isAlphaNum, isSpace)
import Data.List (isPrefixOf)
import System.Timeout (timeout)

-- ---------------------------------------------------------------------------
-- Types for the tests, and a way to print them that doesn't use the Show
-- instance from task 1: constructors, exactly as you would type them.
-- ---------------------------------------------------------------------------

infixr 5 ~>
(~>) :: Type -> Type -> Type
(~>) = Arrow

tA, tB, tC, tD, tE, tT, tInt, tBool :: Type
tA = Var "a"
tB = Var "b"
tC = Var "c"
tD = Var "d"
tE = Var "e"
tT = Var "t"
tInt  = Var "Int"
tBool = Var "Bool"

raw :: Type -> String
raw (Var s)     = "Var " ++ show s
raw (Arrow a b) = "Arrow (" ++ raw a ++ ") (" ++ raw b ++ ")"

newtype Raw = Raw Type deriving Eq
instance Show Raw where show (Raw t) = raw t

-- ---------------------------------------------------------------------------
-- Task 1: read a shown type back in. -> associates to the right, brackets
-- group, anything else made of letters and digits is a variable.
-- ---------------------------------------------------------------------------

tokens :: String -> Maybe [String]
tokens [] = Just []
tokens ('-':'>':cs) = ("->" :) <$> tokens cs
tokens (c:cs)
  | isSpace c       = tokens cs
  | c `elem` "()"   = ([c] :) <$> tokens cs
  | isAlphaNum c    = let (w, rest) = span isAlphaNum (c:cs) in (w :) <$> tokens rest
  | otherwise       = Nothing

pType :: [String] -> Maybe (Type, [String])
pType ts = do
  (a, rest) <- pAtom ts
  case rest of
    "->" : rest' -> do (b, rest'') <- pType rest'
                       Just (Arrow a b, rest'')
    _            -> Just (a, rest)

pAtom :: [String] -> Maybe (Type, [String])
pAtom ("(" : ts) = do
  (a, rest) <- pType ts
  case rest of
    ")" : rest' -> Just (a, rest')
    _           -> Nothing
pAtom (w : ts) | all isAlphaNum w = Just (Var w, ts)
pAtom _ = Nothing

readType :: String -> Maybe Type
readType s = do
  ts <- tokens s
  (t, rest) <- pType ts
  if null rest then Just t else Nothing

showCheck :: String -> Type -> IO (String, Result)
showCheck name t = check name verdict "ok"
  where
    s = show t
    verdict = case readType s of
      Just t' | t' == t   -> "ok"
              | otherwise -> "show gave " ++ show s ++ ", which reads as " ++ raw t' ++ "; the value was " ++ raw t
      Nothing             -> "show gave " ++ show s ++ ", which isn't a type expression; the value was " ++ raw t

-- ---------------------------------------------------------------------------
-- Task 4: run unify with a time limit, and tell an error of your own apart
-- from a stub, a missing case and a loop.
-- ---------------------------------------------------------------------------

data Outcome = Gave Type        -- it returned this
             | Refused          -- it called error
             | NoCase String    -- no equation of unify matched
             | TimedOut         -- still going after 5 seconds
             | Crashed String   -- anything else

-- | A stub still containing 'undefined' rethrows, so the check reports todo.
runUnify :: [(Type, Type)] -> String -> IO Outcome
runUnify eqs v = do
  r <- try (timeout 5000000 (evaluate (force (unify eqs v))))
         :: IO (Either SomeException (Maybe Type))
  case r of
    Right (Just t) -> pure (Gave t)
    Right Nothing  -> pure TimedOut
    Left e
      | Just (ErrorCall m) <- fromException e ->
          if "Prelude.undefined" `isPrefixOf` m then throwIO e else pure Refused
      | Just (PatternMatchFail m) <- fromException e -> pure (NoCase m)
      | otherwise -> pure (Crashed (show e))
  where force t = length (raw t) `seq` t

unifyCheck :: String -> [(Type, Type)] -> String -> (Outcome -> String) -> IO (String, Result)
unifyCheck name eqs v verdict = do
  r <- try (runUnify eqs v) :: IO (Either SomeException Outcome)
  check name (either (\e -> errorWithoutStackTrace (show e)) verdict r) "ok"

unifyGives :: String -> [(Type, Type)] -> String -> Type -> IO (String, Result)
unifyGives name eqs v want = unifyCheck name eqs v verdict
  where
    verdict (Gave t) | t == want = "ok"
                     | otherwise = "gave " ++ raw t ++ ", expected " ++ raw want
    verdict Refused     = "reported failure, but these equations unify: expected " ++ raw want
    verdict (NoCase m)  = "no case of unify matched (" ++ takeWhile (/= '\n') m ++ ")"
    verdict TimedOut    = "still running after 5 seconds"
    verdict (Crashed e) = "crashed: " ++ e

unifyFails :: String -> [(Type, Type)] -> String -> IO (String, Result)
unifyFails name eqs v = unifyCheck name eqs v verdict
  where
    verdict Refused     = "ok"
    verdict (Gave t)    = "gave " ++ raw t ++ ", but these equations have no solution"
    verdict (NoCase _)  = "failed with a pattern-match error, not an error message of your own (rule 5)"
    verdict TimedOut    = "still running after 5 seconds"
    verdict (Crashed e) = "crashed: " ++ e

main :: IO ()
main = runTests "Week 9 -- oppgaver uke9"
  [ showCheck "show: Int -> Int -> Bool (the sheet's example)" (tInt ~> tInt ~> tBool)
  , showCheck "show: (a -> b) -> c (the sheet's example)"      ((tA ~> tB) ~> tC)
  , showCheck "show: a single variable"                        tA
  , showCheck "show: a -> b"                                   (tA ~> tB)
  , showCheck "show: a -> b -> c -> d"                         (tA ~> tB ~> tC ~> tD)
  , showCheck "show: ((a -> b) -> c) -> d"                     (((tA ~> tB) ~> tC) ~> tD)
  , showCheck "show: (a -> b) -> (c -> d) -> e"                ((tA ~> tB) ~> (tC ~> tD) ~> tE)
  , showCheck "show: a -> (b -> c) -> d"                       (tA ~> (tB ~> tC) ~> tD)
  , showCheck "show: (a -> b -> c) -> d"                       ((tA ~> tB ~> tC) ~> tD)

  , check "subst: (a -> b)[b\\c] (the sheet's example)"
      (Raw (subst "b" tC (tA ~> tB)))                          (Raw (tA ~> tC))
  , check "subst: (Int -> Int -> Bool)[Int\\Double] (the sheet's example)"
      (Raw (subst "Int" (Var "Double") (tInt ~> tInt ~> tBool)))
      (Raw (Var "Double" ~> Var "Double" ~> tBool))
  , check "subst: a[a\\b]"
      (Raw (subst "a" tB tA))                                  (Raw tB)
  , check "subst: a[b\\c] -- the variable isn't there"
      (Raw (subst "b" tC tA))                                  (Raw tA)
  , check "subst: (a -> b)[c\\d] -- the variable isn't there"
      (Raw (subst "c" tD (tA ~> tB)))                          (Raw (tA ~> tB))
  , check "subst: (a -> b -> a)[a\\(c -> d)] -- a whole type goes in, twice"
      (Raw (subst "a" (tC ~> tD) (tA ~> tB ~> tA)))            (Raw ((tC ~> tD) ~> tB ~> tC ~> tD))
  , check "subst: ((a -> b) -> a)[a\\c] -- on the left of an arrow too"
      (Raw (subst "a" tC ((tA ~> tB) ~> tA)))                  (Raw ((tC ~> tB) ~> tC))
  , check "subst: (a -> b)[a\\(a -> a)] -- the new a's are left alone"
      (Raw (subst "a" (tA ~> tA) (tA ~> tB)))                  (Raw ((tA ~> tA) ~> tB))

  , check "occursIn \"x\" (x -> y) (the sheet's example)"
      (occursIn "x" (Var "x" ~> Var "y"))                      True
  , check "occursIn \"x\" int (the sheet's example)"
      (occursIn "x" (Var "int"))                               False
  , check "occursIn \"x\" x"            (occursIn "x" (Var "x"))                      True
  , check "occursIn \"y\" (x -> y)"     (occursIn "y" (Var "x" ~> Var "y"))           True
  , check "occursIn \"z\" (x -> y)"     (occursIn "z" (Var "x" ~> Var "y"))           False
  , check "occursIn \"a\" ((b -> (c -> a)) -> d)"
      (occursIn "a" ((tB ~> tC ~> tA) ~> tD))                  True
  , check "occursIn \"a\" ((b -> c) -> d -> e)"
      (occursIn "a" ((tB ~> tC) ~> tD ~> tE))                  False
  , check "occursIn \"x\" (xs -> y) -- xs is another variable"
      (occursIn "x" (Var "xs" ~> Var "y"))                     False

  , unifyGives "unify: the sheet's example"
      [(tA ~> tB, tT), (tA, tC ~> tD)] "t"                     ((tC ~> tD) ~> tB)
  , unifyGives "unify: [t = a -> b] is already solved"
      [(tT, tA ~> tB)] "t"                                     (tA ~> tB)
  , unifyGives "unify: [a -> b = t], t on the right"
      [(tA ~> tB, tT)] "t"                                     (tA ~> tB)
  , unifyGives "unify: [a = t, a = b -> c]"
      [(tA, tT), (tA, tB ~> tC)] "t"                           (tB ~> tC)
  , unifyGives "unify: [t = a, b -> c = a] -- rule 4 turns the second one round"
      [(tT, tA), (tB ~> tC, tA)] "t"                           (tB ~> tC)
  , unifyGives "unify: [t = a -> b, a -> b = c -> d -> e] -- rule 3"
      [(tT, tA ~> tB), (tA ~> tB, tC ~> tD ~> tE)] "t"         (tC ~> tD ~> tE)
  , unifyGives "unify: [t = a -> b, c -> a = (Int -> Bool) -> c] -- substitute on both sides"
      [(tT, tA ~> tB), (tC ~> tA, (tInt ~> tBool) ~> tC)] "t"  ((tInt ~> tBool) ~> tB)
  , unifyGives "unify: [t = a -> b, a = c -> d, b = a, d = c] -- a chain of substitutions"
      [(tT, tA ~> tB), (tA, tC ~> tD), (tB, tA), (tD, tC)] "t" ((tC ~> tC) ~> tC ~> tC)
  , unifyGives "unify: initial variable r, with t an ordinary variable"
      [(Var "r", tT ~> tB), (tT, tInt ~> tInt)] "r"            ((tInt ~> tInt) ~> tB)

  , unifyFails "unify: [t = a, a = a -> b] has no solution (a occurs in a -> b)"
      [(tT, tA), (tA, tA ~> tB)] "t"
  , unifyFails "unify: [t = a, a -> b = b -> a -> c] has no solution"
      [(tT, tA), (tA ~> tB, tB ~> tA ~> tC)] "t"
  , unifyFails "unify: [t = a -> b, a -> b = b -> a -> c] has no solution"
      [(tT, tA ~> tB), (tA ~> tB, tB ~> tA ~> tC)] "t"
  ]
