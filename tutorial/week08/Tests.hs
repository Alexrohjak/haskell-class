module Main where

import Check
import Control.Exception (SomeException, try)
import Exercises

-- An unimplemented exercise is still 'undefined'. For a PURE value the harness
-- catches that itself and reports 'todo'. An IO action throws when it is RUN,
-- which happens before 'check' ever sees it -- so catch it here and hand
-- 'check' an undefined value instead, keeping the todo behaviour.
runIO :: IO a -> IO a
runIO act = do
  r <- try act
  case r of
    Left e  -> failed e
    Right x -> return x

failed :: SomeException -> IO a
failed _ = return undefined

blinker :: LifeBoard
blinker = [(2,3),(3,3),(4,3)]

main :: IO ()
main = runTests "Week 8 -- Hutton ch. 10"
  -- Exercise 1 runs real IO actions, then compares what they produced.
  [ do { r <- runIO (pairIO (return (1 :: Int)) (return 'x'))
       ; check "pairIO" r (1, 'x') }
  , do { r <- runIO (pairIO (return "a") (return [1 :: Int]))
       ; check "pairIO other types" r ("a", [1]) }
  , do { r <- runIO (sequenceIO [return (1 :: Int), return 2, return 3])
       ; check "sequenceIO" r [1,2,3] }
  , do { r <- runIO (sequenceIO ([] :: [IO Int]))
       ; check "sequenceIO []" r [] }
  , do { r <- runIO (sequenceIO [return 'a'])
       ; check "sequenceIO one" r "a" }
  , do { r <- runIO (mapMIO (\x -> return (x * 2)) [1,2,3 :: Int])
       ; check "mapMIO" r [2,4,6] }
  , do { r <- runIO (mapMIO (\x -> return (show x)) [1,2 :: Int])
       ; check "mapMIO changes type" r ["1","2"] }
  , do { r <- runIO (mapMIO return ([] :: [Int]))
       ; check "mapMIO []" r [] }

  , check "next 1"              (next 1)                      2
  , check "next 2"              (next 2)                      1
  , check "next twice"          (next (next 1))               1
  , check "finished all zero"   (finished [0,0,0,0,0])        True
  , check "finished []"         (finished [])                 True
  , check "finished one left"   (finished [0,0,1,0,0])        False
  , check "finished initial"    (finished initialNim)         False
  , check "valid 2 3"           (valid [5,4,3,2,1] 2 3)       True
  , check "valid exact"         (valid [5,4,3,2,1] 2 4)       True
  , check "valid too many"      (valid [5,4,3,2,1] 5 2)       False
  , check "valid zero"          (valid [5,4,3,2,1] 1 0)       False
  , check "valid negative"      (valid [5,4,3,2,1] 1 (-1))    False
  , check "valid row too big"   (valid [5,4,3,2,1] 9 1)       False
  , check "valid row zero"      (valid [5,4,3,2,1] 0 1)       False
  , check "valid empty row"     (valid [0,4,3,2,1] 1 1)       False
  , check "move 2 3"            (move [5,4,3,2,1] 2 3)        [5,1,3,2,1]
  , check "move first row"      (move [5,4,3,2,1] 1 5)        [0,4,3,2,1]
  , check "move last row"       (move [5,4,3,2,1] 5 1)        [5,4,3,2,0]

  , check "showRow 1 5"         (showRow 1 5)                 "1: * * * * *"
  , check "showRow 3 3"         (showRow 3 3)                 "3: * * *"
  , check "showRow 5 1"         (showRow 5 1)                 "5: *"
  , check "showRow 5 0"         (showRow 5 0)                 "5: "
  , check "showBoard [1,0]"     (showBoard [1,0])             "1: *\n2: "
  , check "showBoard initial"   (showBoard initialNim)
      "1: * * * * *\n2: * * * *\n3: * * *\n4: * *\n5: *"
  , check "showBoard no trailing \\n" (last (showBoard initialNim))  '*'

  , check "playMoves two"       (playMoves [5,4,3,2,1] [(2,3),(1,5)])  [0,1,3,2,1]
  , check "playMoves invalid"   (playMoves [5,4,3,2,1] [(5,9)])        [5,4,3,2,1]
  , check "playMoves none"      (playMoves [5,4,3,2,1] [])             [5,4,3,2,1]
  , check "playMoves mixed"     (playMoves [5,4,3,2,1] [(1,2),(9,1),(1,3)])  [0,4,3,2,1]
  , check "playMoves to end"    (finished (playMoves initialNim
      [(1,5),(2,4),(3,3),(4,2),(5,1)]))                       True

  , check "match \"haskell\" \"ael\"" (match "haskell" "ael") "-a--ell"
  , check "match nothing"       (match "haskell" "")          "-------"
  , check "match everything"    (match "abc" "abc")           "abc"
  , check "match empty secret"  (match "" "abc")              ""
  , check "match repeats"       (match "aaa" "a")             "aaa"
  , check "won exact"           (won "haskell" "haskell")     True
  , check "won reordered"       (won "abc" "cba")             True
  , check "won partial"         (won "haskell" "ael")         False
  , check "won nothing"         (won "abc" "")                False

  , check "parseMove \"2 3\""   (parseMove "2 3")             (Just (2,3))
  , check "parseMove padded"    (parseMove "  2  3 ")         (Just (2,3))
  , check "parseMove one"       (parseMove "2")               Nothing
  , check "parseMove letters"   (parseMove "a b")             Nothing
  , check "parseMove empty"     (parseMove "")                Nothing
  , check "parseMove three"     (parseMove "1 2 3")           Nothing
  , check "parseMove mixed"     (parseMove "2 x")             Nothing
  , check "parseMove big"       (parseMove "10 20")           (Just (10,20))

  , check "wrap off left"       (wrap (0,1))                  (10,1)
  , check "wrap off right"      (wrap (11,1))                 (1,1)
  , check "wrap inside"         (wrap (3,4))                  (3,4)
  , check "wrap off top"        (wrap (1,0))                  (1,10)
  , check "wrap off bottom"     (wrap (1,11))                 (1,1)
  , check "wrap corner"         (wrap (0,0))                  (10,10)
  , check "neighbs count"       (length (neighbs (3,4)))      8
  , check "neighbs no self"     (elem (3,4) (neighbs (3,4)))  False
  , check "neighbs all wrapped" (all (\(x,y) -> x >= 1 && x <= width
                                              && y >= 1 && y <= height)
                                     (neighbs (1,1)))         True
  , check "liveneighbs 1"       (liveneighbs [(2,3),(3,3)] (2,3))  1
  , check "liveneighbs 0"       (liveneighbs [(2,3)] (9,9))        0
  , check "liveneighbs 2"       (liveneighbs blinker (3,2))        3
  , check "survivors blinker"   (survivors blinker)           [(3,3)]
  , check "survivors none"      (survivors [(1,1)])           []
  , check "births blinker"      (births blinker)              [(3,2),(3,4)]
  , check "births none"         (births [(1,1)])              []
  , check "nextgen blinker"     (nextgen blinker)             [(3,3),(3,2),(3,4)]
  , check "blinker oscillates"  (nextgen (nextgen blinker))   [(3,3),(2,3),(4,3)]
  , check "blinker period 2"    (all (`elem` nextgen (nextgen blinker)) blinker)  True
  , check "nextgen empty"       (nextgen [])                  []
  , check "lone cell dies"      (nextgen [(5,5)])             []
  ]
