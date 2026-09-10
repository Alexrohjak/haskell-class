module Main where

import Data.List (nub, sort)

import Check
import Oppgaver

-- What a Bool -> Bool does, written down as a value that can be compared.
behaviour :: (Bool -> Bool) -> (Bool, Bool)
behaviour f = (f False, f True)

everyBehaviour :: [(Bool, Bool)]
everyBehaviour = [ (a, b) | a <- [False, True], b <- [False, True] ]

main :: IO ()
main = runTests "Week 2 -- oppgaver uke2"
  [ check "e7 3"                   (e7 (3 :: Int))               (3,3)
  , check "e7 'x'"                 (e7 'x')                      ('x','x')
  , check "e7 \"ab\""              (e7 "ab")                     ("ab","ab")

  , checkThat "alleBoolFns: no two behave the same"
      (let bs = map behaviour alleBoolFns in length bs == length (nub bs))
  , checkThat "alleBoolFns: none missing"
      (sort (nub (map behaviour alleBoolFns)) == everyBehaviour)
  ]
