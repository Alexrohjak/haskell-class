-- | Week 8 — the lecturer's sheet: oppgaver uke8 (uke 41).
--
--     ./check.sh 8 --oppg          just this sheet
--     ./check.sh 8 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke41/exercises/uke8.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
-- This sheet is about GRAMMARS and PARSING (his lecture 8,
-- weeks/uke41/slides/8-grammatikk-hand.pdf). That is in no chapter of
-- Hutton that is pensum: his notes are the only source. The sheet is one
-- program built in five steps -- tokenise and parse a boolean expression,
-- collect its atoms, list every valuation of them, evaluate under one, and
-- finally list the valuations that make the expression true.
--
-- The sheet has three places where its text and its examples disagree. Each
-- is pointed out where it comes up; in all three the tests follow the
-- examples, or accept both readings.
module Oppgaver where
import Data.Char

-- ---------------------------------------------------------------------------
--   Vi behandler grammatikken for boolske uttrykk, med startsymbolet B:
--       B ::= A|B | A
--   (i "A|B" er "|" et terminal symbol, men mellom det og "A", er det et
--   metasymbol i grammatikken vår!)
--       A ::= N & A | N
--       N ::= !C
--       C ::= Atom | T | F | (B)
--       Atom ::= lowerLetter+
--
--   Atom er en vilkårlig ikke-tom sekvens av småbokstaver, T og F er
--   konstanter (for True og False, som ikke er Atomer), ! er negasjon, &
--   konjunksjon og | disjunksjon. F.eks., er
--       bad & (alle | !z)
--       T | F & T
--   lovlige boolske uttrykk. Merk at ! har høyeste presendens og | laveste;
--   både & og | assosierer til høyre. Det siste uttrykket parses som
--   "T | (F & T)" og er logisk ekvivalent med T, mens "!F | T" er logisk
--   ekvivalent med T, ulikt "!(F | T)" som er ekvivalent med F.
--
--   Vi skal benytte følgende datatypen for boolske ASTer:
--
--       data Bst = T | F | Atom String | Or Bst Bst | And Bst Bst | Not Bst deriving (Eq,Show,Read)
--
-- First disagreement: read literally, "N ::= !C" puts a ! in front of every
-- operand, and then neither of the sheet's two "lovlige" expressions is
-- legal. The examples settle it: the ! is optional. How you write that rule
-- is yours to decide. The tests never use a doubled negation ("!!a"), since
-- whether that is legal depends on how you write it.
-- ---------------------------------------------------------------------------

data Bst = T | F | Atom String | Or Bst Bst | And Bst Bst | Not Bst
  deriving (Eq, Show, Read)

-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Definer funksjoner
--       tokenise :: String -> [String], og
--       parse :: String -> Bst.
--   Den første lager en liste av tokens, mens den andre returnerer et Bst
--   for et korrekt boolsk uttrykk.
--   F.eks.:
--       parse "T | F & T" = Or T (And F T)
--       parse  "!(a & !a) & !b" = And (Not (And (At "a") (Not (At "a")))) (Not (At "b"))
--       parse  "!a & !a & !b"   = And (Not (At "a")) (And (Not (At "a")) (Not (At "b")))
--
-- Second disagreement: the examples say At where the data type says Atom.
-- The data type wins; the tests expect Atom "a".
--
-- The sheet gives no example of tokenise's output, so the tests only check
-- what "a list of tokens" has to mean: put back together the tokens are the
-- input without its spaces, and an atom of several letters stays in one
-- piece. parse is only ever given correct expressions.
-- ---------------------------------------------------------------------------

tokenise :: String -> [String]
tokenise [] = []
tokenise (x:xs)
  | isSpace x = tokenise xs
  | isLower x = atom : tokenise rest
  | otherwise = [x] : tokenise xs
  where (atom, rest) = span isLower (x:xs)

parse :: String -> Bst
parse = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 2
--
--   Definer funksjon
--       atomer :: Bst -> [String]
--   som returnerer listen av forskjellige Atomer som forekommer i Bst. (T og
--   F regnes ikke som Atomer.)
--
-- The task doesn't say what order the list is in, so these tests don't
-- either. The example in task 5 does: look at it before you choose.
-- ---------------------------------------------------------------------------

atomer :: Bst -> [String]
atomer = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Definer en funksjon
--       vals :: [String] -> [[(String,Bst)]], evt.
--       vals :: [a] -> [[(a,Bst)]], for en vilkårlig type a,
--   som for en inputliste med forskjellige Atomer gir en liste med alle
--   deres valueringer (en valuering av n Atomer er en liste med n par, med
--   en verdi T eller F assosiert med hvert Atom fra listen). F.eks.
--       vals ["a","b"] = [ [("a",T),("b",T)], [("a",T),("b",F)],
--                          [("a",F),("b",T)], [("a",F),("b",F)] ]
--
-- The stub has the first signature. Swap it for the general one if you want
-- it; the tests only use Strings, so they pass with either.
--
-- What vals [] is, the sheet doesn't say, and the tests don't ask. It
-- matters in task 5.
-- ---------------------------------------------------------------------------

vals :: [String] -> [[(String, Bst)]]
vals = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Definer funksjon
--       ev :: Bst -> [(String,Bst)] -> Bst
--   som gitt et t::Bst og en liste v::[(String,Bst)] tilsvarende en
--   valuering av Atomer i t, returnerer boolsk verdi - T eller F - av t
--   under valueringen v, f.eks.:
--       ev T [] = T
--       ev (Or F (And F T)) [] = F
--       ev (Atom "a") [("a",T)] = T
--       ev (Or (Atom "a") (Not (Atom "b"))) [("a",F),("b",T)] = F
--
-- The tests always give a valuation that covers every atom in the tree.
-- ---------------------------------------------------------------------------

ev :: Bst -> [(String, Bst)] -> Bst
ev = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 5
--
--   Definer funksjon
--       models :: String -> [ [(String,Bst)] ]
--   som for en inputstring med et lovlig boolsk uttrykk, gir listen av alle
--   valueringene av dets Atomer, som gjør uttrykket T(true). Hvis ingen slik
--   finnes får man altså en tom liste. F.eks.:
--       models "T | F & T" = [] -- siden uttrykket ikke har noen Atomer
--       models "!a & a" = []
--       models "b & (a | !z)" = [ [("b",T),("a",T),("z",T)],
--                                 [("b",T),("a",T),("z",F)],
--                                 [("b",T),("a",F),("z",F)] ]
--
-- Third disagreement: the sheet says above that "T | F & T" is equivalent to
-- T, and here that it has no models. Whether an expression with no atoms has
-- zero valuations or exactly one (the empty one) is the vals [] question
-- from task 3. The tests accept [] and [[]] for that example. Pick one, and
-- say in a comment which and why -- it is a good exam-style question.
--
-- The third example is tested exactly as written, order included. The other
-- models tests don't care about order.
-- ---------------------------------------------------------------------------

models :: String -> [[(String, Bst)]]
models = undefined
