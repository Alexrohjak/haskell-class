module Main where

import Check
import Oppgaver

main :: IO ()
main = runTests "Week 4 -- oppgaver uke4"
  [ check "strInt [\"1\",\"22\",\"-3\"]"   (strInt ["1","22","-3"])          [1,22,-3]
  , check "strInt []"                      (strInt [])                       []
  , check "strInt [\"127\"]"               (strInt ["127"])                  [127]

  , check "fjernLK \"ab cd ef\" ' '"       (fjernLK "ab cd ef" ' ')          "abcdef"
  , check "fjernLK \"ab cd cf\" 'c'"       (fjernLK "ab cd cf" 'c')          "ab d f"
  , check "fjernLK \"\" 'x'"               (fjernLK "" 'x')                  ""
  , check "fjernLK \"aaa\" 'a'"            (fjernLK "aaa" 'a')               ""
  , check "fjernLK \"abc\" 'z'"            (fjernLK "abc" 'z')               "abc"
  , check "fjernRek \"ab cd ef\" ' '"      (fjernRek "ab cd ef" ' ')         "abcdef"
  , check "fjernRek \"ab cd cf\" 'c'"      (fjernRek "ab cd cf" 'c')         "ab d f"
  , check "fjernRek \"\" 'x'"              (fjernRek "" 'x')                 ""
  , check "fjernRek \"aaa\" 'a'"           (fjernRek "aaa" 'a')              ""
  , check "fjernRek \"abc\" 'z'"           (fjernRek "abc" 'z')              "abc"

  , check "tegnposLK 'n' \"Tannenberg 1410\""  (tegnposLK 'n' "Tannenberg 1410")  [2,3,5]
  , check "tegnposLK '1' \"Tannenberg 1410\""  (tegnposLK '1' "Tannenberg 1410")  [11,13]
  , check "tegnposLK 'z' \"abc\""              (tegnposLK 'z' "abc")              []
  , check "tegnposLK 'a' \"\""                 (tegnposLK 'a' "")                 []
  , check "tegnposLK 'a' \"aaa\""              (tegnposLK 'a' "aaa")              [0,1,2]
  , check "tegnposRek 'n' \"Tannenberg 1410\"" (tegnposRek 'n' "Tannenberg 1410") [2,3,5]
  , check "tegnposRek '1' \"Tannenberg 1410\"" (tegnposRek '1' "Tannenberg 1410") [11,13]
  , check "tegnposRek 'z' \"abc\""             (tegnposRek 'z' "abc")             []
  , check "tegnposRek 'a' \"\""                (tegnposRek 'a' "")                []
  , check "tegnposRek 'a' \"aaa\""             (tegnposRek 'a' "aaa")             [0,1,2]

  , check "isOddHale 0"                    (isOddHale 0)                     False
  , check "isOddHale 1"                    (isOddHale 1)                     True
  , check "isOddHale 7"                    (isOddHale 7)                     True
  , check "isOddHale 10"                   (isOddHale 10)                    False
  , check "isOddGj 0"                      (isOddGj 0)                       False
  , check "isOddGj 1"                      (isOddGj 1)                       True
  , check "isOddGj 7"                      (isOddGj 7)                       True
  , check "isOddGj 10"                     (isOddGj 10)                      False
  , check "isEvenGj 0"                     (isEvenGj 0)                      True
  , check "isEvenGj 1"                     (isEvenGj 1)                      False
  , check "isEvenGj 10"                    (isEvenGj 10)                     True
  , checkThat "isOddGj n == odd n, for 0..50"
      (and [ isOddGj n == odd n | n <- [0..50] ])
  , checkThat "isOddHale n == odd n, for 0..50"
      (and [ isOddHale n == odd n | n <- [0..50] ])

  , check "take 7 fibs"                    (take 7 fibs)                     [1,1,2,3,5,8,13]
  , check "take 1 fibs"                    (take 1 fibs)                     [1]
  , check "fibs !! 20"                     (fibs !! 20)                      10946

  , check "evalOPN [] [\"12\",\"5\",\"*\",\"1\",\"+\"]"
      (evalOPN [] ["12","5","*","1","+"])  61
  , check "evalOPN: (1 - 22) * 7"          (evalOPN [] ["1","22","-","7","*"])  (-147)
  , check "evalOPN: 1 - (22 * 7)"          (evalOPN [] ["1","22","7","*","-"])  (-153)
  , check "evalOPN [] [\"42\"]"            (evalOPN [] ["42"])               42

  , check "eval \"1 2 3 * +\""             (eval "1 2 3 * +")                7
  , check "eval \"12 5 * 1 -\""            (eval "12 5 * 1 -")               59
  , check "eval \"1 22 - 7 *\""            (eval "1 22 - 7 *")               (-147)
  , check "eval \"20 4 /\""                (eval "20 4 /")                   5
  ]
