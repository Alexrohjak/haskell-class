module Main where

import Data.List (sort)

import Check
import Oppgaver

main :: IO ()
main = runTests "Week 3 -- oppgaver uke3"
  [ check "toUppers \"Miss Universe\""  (toUppers "Miss Universe")   "MISS UNIVERSE"
  , check "toUppers \"\""               (toUppers "")                ""
  , check "toUppers leaves non-letters" (toUppers "a1 b2!?")         "A1 B2!?"
  , check "toUppers \"ABC\""            (toUppers "ABC")             "ABC"

  , check "group \"Mississippi\""       (group "Mississippi")        ["M","i","ss","i","ss","i","pp","i"]
  , check "group []"                    (group ([] :: [Int]))        []
  , check "group [7]"                   (group [7 :: Int])           [[7]]
  , check "group [1,1,2,3,3,3]"         (group [1,1,2,3,3,3 :: Int]) [[1,1],[2],[3,3,3]]
  , check "group \"aaa\""               (group "aaa")                ["aaa"]
  , check "group \"abab\""              (group "abab")               ["a","b","a","b"]
  , checkThat "concat (group xs) == xs"
      (and [ concat (group xs) == xs | xs <- ["", "a", "aab", "Mississippi", "  x  "] ])

  , check "elTall ['a','a','a']"        (elTall ['a','a','a'])       ('a',3)
  , check "elTall \"x\""                (elTall "x")                 ('x',1)
  , check "elTall [5,5]"                (elTall [5,5 :: Int])        (5,2)

  , check "letterFreq \"Hello World\" (any order)"
      (sort (letterFreq "Hello World"))
      (sort [('D',1),('E',1),('H',1),('L',3),('O',2),('R',1),('W',1),(' ',1)])
  , check "letterFreq \"\""             (letterFreq "")              []
  , check "letterFreq counts across case (any order)"
      (sort (letterFreq "aAbA"))        [('A',3),('B',1)]
  , check "letterFreq \"zz\""           (letterFreq "zz")            [('Z',2)]

  , check "tokMat \"10 - 2 * 4\""       (tokMat "10 - 2 * 4")        ["10","-","2","*","4"]
  , check "tokMat \"(10 - 2) * 4\""     (tokMat "(10 - 2) * 4")      ["(","10","-","2",")","*","4"]
  , check "tokMat \"\""                 (tokMat "")                  []
  , check "tokMat \"42\""               (tokMat "42")                ["42"]
  , check "tokMat \"8 / 2\""            (tokMat "8 / 2")             ["8","/","2"]
  , check "tokMat \"((1 + 23))\""       (tokMat "((1 + 23))")        ["(","(","1","+","23",")",")"]
  , check "tokMat an OPN string (uke4 needs this)"
      (tokMat "12 5 * 1 +")             ["12","5","*","1","+"]

  , check "langTok \"|eks -> eks + 10\"" (langTok "|eks -> eks + 10") ["|","eks","->","eks","+","10"]
  , check "langTok \"| x -> x\""         (langTok "| x -> x")         ["|","x","->","x"]
  , check "langTok nested lambdas"
      (langTok "|x -> |y -> x * y")      ["|","x","->","|","y","->","x","*","y"]
  , check "langTok minus is not an arrow"
      (langTok "|x -> x - 1")            ["|","x","->","x","-","1"]
  , check "langTok with no spaces at all"
      (langTok "|x->x-1")                ["|","x","->","x","-","1"]
  ]
