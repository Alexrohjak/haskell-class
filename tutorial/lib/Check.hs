-- | A tiny, dependency-free test harness for the INF122 tutorial.
--
-- You never need to edit this file. Each week's Tests.hs uses it like so:
--
-- > main = runTests "Week 1"
-- >   [ check "double 3" (double 3) 6
-- >   , checkThat "5 is odd" (odd 5)
-- >   ]
--
-- Unimplemented exercises still contain 'undefined', which throws when
-- evaluated. We catch that and report it as TODO rather than crashing the
-- whole run, so you can implement the exercises one at a time.
module Check (check, checkThat, runTests) where

import Control.Exception (SomeException, evaluate, try)
import Control.Monad (unless)
import System.Exit (exitFailure)

data Result = Pass | Fail String | Todo

-- | Compare an actual value against an expected one.
check :: (Eq a, Show a) => String -> a -> a -> IO (String, Result)
check name actual expected = do
  outcome <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  case outcome of
    Left _      -> pure (name, Todo)
    Right True  -> pure (name, Pass)
    Right False -> do
      shown <- safeShow actual
      pure (name, Fail ("expected " ++ show expected ++ ", got " ++ shown))

-- | Assert that a Bool is True. Use for properties and for values that
-- have no Show instance (functions, IO actions).
checkThat :: String -> Bool -> IO (String, Result)
checkThat name b = do
  outcome <- try (evaluate b) :: IO (Either SomeException Bool)
  pure $ case outcome of
    Left _      -> (name, Todo)
    Right True  -> (name, Pass)
    Right False -> (name, Fail "expected True, got False")

safeShow :: Show a => a -> IO String
safeShow x = do
  outcome <- try (evaluate (length (show x) `seq` show x)) :: IO (Either SomeException String)
  pure (either (const "<error while evaluating>") id outcome)

-- | Run a list of checks, print a report, exit non-zero if anything failed.
runTests :: String -> [IO (String, Result)] -> IO ()
runTests title checks = do
  putStrLn ("\n== " ++ title ++ " ==")
  results <- sequence checks
  mapM_ report results
  let n     = length results
      passed = length [() | (_, Pass)   <- results]
      todos  = length [() | (_, Todo)   <- results]
      failed = n - passed - todos
  putStrLn ""
  putStrLn (show passed ++ "/" ++ show n ++ " passed"
            ++ (if todos  > 0 then ", " ++ show todos  ++ " not implemented" else "")
            ++ (if failed > 0 then ", " ++ show failed ++ " FAILED" else ""))
  unless (passed == n) exitFailure

report :: (String, Result) -> IO ()
report (name, Pass)   = putStrLn ("  PASS  " ++ name)
report (name, Todo)   = putStrLn ("  todo  " ++ name)
report (name, Fail m) = putStrLn ("  FAIL  " ++ name ++ "\n          " ++ m)
