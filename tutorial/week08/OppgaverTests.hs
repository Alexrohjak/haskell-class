module Main where

import Check
import Oppgaver

import Data.Char (isSpace)
import Data.List (nub, sort)

a, b, c, d, z :: Bst
a = Atom "a"
b = Atom "b"
c = Atom "c"
d = Atom "d"
z = Atom "z"

-- | The tokens put back together: the input with its spaces taken out.
glued :: String -> Bool
glued s = concat (tokenise s) == filter (not . isSpace) s

-- | A list of valuations with the order taken out of it, both of the
-- valuations and of the pairs inside each one. Bst has no Ord, so the value
-- becomes a Bool.
unordered :: [[(String, Bst)]] -> [[(String, Bool)]]
unordered = sort . map (sort . map (\(x, v) -> (x, v == T)))

-- | Every valuation lists exactly these atoms, in this order, each with T or F.
wellFormed :: [String] -> [[(String, Bst)]] -> Bool
wellFormed xs = all (\v -> map fst v == xs && all ((`elem` [T, F]) . snd) v)

main :: IO ()
main = runTests "Week 8 -- oppgaver uke8"
  [ checkThat "tokenise \"bad & (alle | !z)\": the tokens are the input without spaces"
      (glued "bad & (alle | !z)")
  , checkThat "tokenise \"T | F & T\": the tokens are the input without spaces"
      (glued "T | F & T")
  , checkThat "tokenise \"!(a&!a)&!b\": the same with no spaces to begin with"
      (glued "!(a&!a)&!b")
  , checkThat "tokenise \"bad & (alle | !z)\": bad and alle are one token each"
      (all (`elem` tokenise "bad & (alle | !z)") ["bad", "alle"])
  , checkThat "tokenise \"  a   |b \": no token is or contains a space"
      (glued "  a   |b " && not (any (any isSpace) (tokenise "  a   |b ")))

  , check "parse \"T | F & T\" (the sheet's example)"
      (parse "T | F & T")                 (Or T (And F T))
  , check "parse \"!(a & !a) & !b\" (the sheet's example)"
      (parse "!(a & !a) & !b")            (And (Not (And a (Not a))) (Not b))
  , check "parse \"!a & !a & !b\" (the sheet's example)"
      (parse "!a & !a & !b")              (And (Not a) (And (Not a) (Not b)))
  , check "parse \"bad & (alle | !z)\" (the sheet's legal expression)"
      (parse "bad & (alle | !z)")         (And (Atom "bad") (Or (Atom "alle") (Not z)))
  , check "parse \"a\""                   (parse "a")                 a
  , check "parse \"T\" -- a constant, not an atom" (parse "T")        T
  , check "parse \"F\" -- a constant, not an atom" (parse "F")        F
  , check "parse \"!a\""                  (parse "!a")                (Not a)
  , check "parse \"a | b\""               (parse "a | b")             (Or a b)
  , check "parse \"a & b\""               (parse "a & b")             (And a b)
  , check "parse \"a | b | c\" -- | associates to the right"
      (parse "a | b | c")                 (Or a (Or b c))
  , check "parse \"a & b & c\" -- & associates to the right"
      (parse "a & b & c")                 (And a (And b c))
  , check "parse \"a & b | c & d\" -- & binds tighter than |"
      (parse "a & b | c & d")             (Or (And a b) (And c d))
  , check "parse \"a | b & c | d\""
      (parse "a | b & c | d")             (Or a (Or (And b c) d))
  , check "parse \"(a | b) & c\" -- brackets override"
      (parse "(a | b) & c")               (And (Or a b) c)
  , check "parse \"a & (b | c) & d\""
      (parse "a & (b | c) & d")           (And a (And (Or b c) d))
  , check "parse \"!F | T\" -- ! binds tightest"
      (parse "!F | T")                    (Or (Not F) T)
  , check "parse \"!(F | T)\""            (parse "!(F | T)")          (Not (Or F T))
  , check "parse \"!a & b\""              (parse "!a & b")            (And (Not a) b)
  , check "parse \"((a))\""               (parse "((a))")             a
  , check "parse \"a&!(b|c)\" -- no spaces"
      (parse "a&!(b|c)")                  (And a (Not (Or b c)))
  , check "parse \"  a   |b \" -- stray spaces"
      (parse "  a   |b ")                 (Or a b)

  , check "atomer T"                      (atomer T)                  []
  , check "atomer (Or T (And F T)) -- T and F are not atoms"
      (atomer (Or T (And F T)))           []
  , check "atomer (Atom \"a\")"           (atomer a)                  ["a"]
  , check "atomer of b & (a | !z), in any order"
      (sort (atomer (And b (Or a (Not z)))))                          ["a", "b", "z"]
  , check "atomer of !(a & !a) & !b, in any order -- a only once"
      (sort (atomer (And (Not (And a (Not a))) (Not b))))             ["a", "b"]
  , check "atomer of a | (a | (a | a)) -- a only once"
      (atomer (Or a (Or a (Or a a))))                                 ["a"]
  , check "atomer of (bad & alle) | !bad, in any order"
      (sort (atomer (Or (And (Atom "bad") (Atom "alle")) (Not (Atom "bad")))))
      ["alle", "bad"]

  , check "vals [\"a\",\"b\"] (the sheet's example)"
      (vals ["a", "b"])
      [ [("a",T),("b",T)], [("a",T),("b",F)], [("a",F),("b",T)], [("a",F),("b",F)] ]
  , check "vals [\"a\"], in any order"
      (unordered (vals ["a"]))            [[("a",False)], [("a",True)]]
  , check "length (vals [\"a\",\"b\",\"c\"])"
      (length (vals ["a", "b", "c"]))     8
  , checkThat "vals [\"a\",\"b\",\"c\"]: each valuation is a, b, c in order, with T or F"
      (wellFormed ["a", "b", "c"] (vals ["a", "b", "c"]))
  , checkThat "vals [\"a\",\"b\",\"c\"]: no valuation appears twice"
      (let vs = vals ["a", "b", "c"] in nub vs == vs)
  , check "length (vals [\"p\",\"q\",\"r\",\"s\",\"u\"])"
      (length (nub (vals ["p", "q", "r", "s", "u"])))                 32

  , check "ev T [] (the sheet's example)"                (ev T [])                   T
  , check "ev (Or F (And F T)) [] (the sheet's example)" (ev (Or F (And F T)) [])    F
  , check "ev (Atom \"a\") [(\"a\",T)] (the sheet's example)"
      (ev a [("a",T)])                    T
  , check "ev (a | !b) [a=F, b=T] (the sheet's example)"
      (ev (Or a (Not b)) [("a",F),("b",T)])                           F
  , check "ev F []"                       (ev F [])                   F
  , check "ev (Not T) []"                 (ev (Not T) [])             F
  , check "ev (Not F) []"                 (ev (Not F) [])             T
  , check "ev (Atom \"a\") [(\"a\",F)]"   (ev a [("a",F)])            F
  , check "ev (And ..) for all four pairs of constants"
      [ ev (And x y) [] | x <- [T, F], y <- [T, F] ]                  [T, F, F, F]
  , check "ev (Or ..) for all four pairs of constants"
      [ ev (Or x y) [] | x <- [T, F], y <- [T, F] ]                   [T, T, T, F]
  , check "ev (b & (a | !z)) [b=T, a=F, z=F]"
      (ev (And b (Or a (Not z))) [("b",T),("a",F),("z",F)])           T
  , check "ev (b & (a | !z)) [b=T, a=F, z=T]"
      (ev (And b (Or a (Not z))) [("b",T),("a",F),("z",T)])           F
  , check "ev (a & b) [b=T, a=T] -- the valuation in another order"
      (ev (And a b) [("b",T),("a",T)])    T
  , check "ev (!(a & !a) & !b) [a=T, b=F]"
      (ev (And (Not (And a (Not a))) (Not b)) [("a",T),("b",F)])      T

  , check "models \"b & (a | !z)\" (the sheet's example, in its order)"
      (models "b & (a | !z)")
      [ [("b",T),("a",T),("z",T)], [("b",T),("a",T),("z",F)], [("b",T),("a",F),("z",F)] ]
  , check "models \"!a & a\" (the sheet's example)"
      (models "!a & a")                   []
  , checkThat "models \"T | F & T\" (the sheet's example): [] or [[]]"
      (models "T | F & T" `elem` [[], [[]]])
  , check "models \"F & T\" -- no atoms and false"
      (models "F & T")                    []
  , check "models \"a\""                  (models "a")                [[("a",T)]]
  , check "models \"!a\""                 (models "!a")               [[("a",F)]]
  , check "models \"a & a\" -- one atom, not two"
      (models "a & a")                    [[("a",T)]]
  , check "models \"a | !a\", in any order"
      (unordered (models "a | !a"))       [[("a",False)], [("a",True)]]
  , check "models \"a & b\", in any order"
      (unordered (models "a & b"))        [[("a",True),("b",True)]]
  , check "models \"!(a | b)\", in any order"
      (unordered (models "!(a | b)"))     [[("a",False),("b",False)]]
  , check "length (models \"a | b | c\")"
      (length (models "a | b | c"))       7
  , check "models \"bad & !alle\", in any order"
      (unordered (models "bad & !alle"))  [[("alle",False),("bad",True)]]
  ]
