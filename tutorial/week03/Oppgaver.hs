-- | Week 3 — the lecturer's sheet: oppgaver uke3 (uke 36).
--
--     ./check.sh 3 --oppg          just this sheet
--     ./check.sh 3 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke36/exercises/uke3.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
--   "We will start by building a small program to analyse letter frequency
--    (used to break ciphers)"
--
-- Import whatever you need here. One warning: Data.List exports a 'group' of
-- its own -- the very function oppgave 2 has you write -- so if you import
-- Data.List, hide it:  import Data.List hiding (group)
module Oppgaver where
import Data.Char (isDigit)

-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Definer funksjon
--     toUppers :: String -> String
--   som konverterer alle bokstaver i en streng til store bokstaver, f.eks.:
--     ghci> toUppers "Miss Universe"
--     "MISS UNIVERSE"
-- ---------------------------------------------------------------------------

toUppers :: String -> String
toUppers = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 2
--
--   Definer funksjon
--     group :: Eq a => [a] -> [[a]]
--   som gruperer påfølgende identiske elementer i inputlisten i hver sin
--   liste, f.eks.:
--     ghci> group "Mississippi"
--     ["M","i","ss","i","ss","i","pp","i"]
-- ---------------------------------------------------------------------------

group :: Eq a => [a] -> [[a]]
group = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Definer funksjon
--     elTall :: [a] -> (a,Int)
--   som gitt en liste med identiske elementer returnerer elementet og
--   listens lengde, f.eks.:
--     ghci> elTall ['a','a','a']
--     ('a',3)
--
-- The sheet says nothing about the empty list, so neither do the tests.
-- ---------------------------------------------------------------------------

elTall :: [a] -> (a, Int)
elTall = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Bruk funksjoner 1-3 (og andre som du evt. trenger og definerer) for å
--   definere
--     letterFreq :: String -> [(Char,Int)]
--   som returnerer liste med tegn i inputstrenger, hvert med antallet av dets
--   forekomster i input, f.eks.:
--     ghci> letterFreq "Hello World"
--     [('D', 1), ('E',1), ('H', 1), ('L', 3), ('O', 2), ('R', 1), ('W', 1), (' ', 1)]
--
-- The example lists the letters A-Z and then the space, which is not the
-- order anything in Haskell sorts them in (' ' comes before 'A'). So the tests
-- only check WHICH pairs you return, not their order. Pick an order and be
-- able to say why.
-- ---------------------------------------------------------------------------

letterFreq :: String -> [(Char, Int)]
letterFreq = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 5
--
--   Definer en tokeniser
--     tokMath :: String -> [String]
--   for matematiske uttrykk, f.eks:
--     ghci> tokMat "10 - 2 * 4"
--     ["10","-","2","*","4"]
--     ghci> tokMat "(10 - 2) * 4"
--     ["(","10","-","2",")","*","4"]
--   Det er kun tall og ingen variabler i uttrykkene.
--
-- The sheet calls it tokMath in the signature and tokMat everywhere else --
-- including uke4, which reuses it. So it's tokMat here.
-- ---------------------------------------------------------------------------

tokMat :: String -> [String]
tokMat [] = []
tokMat (x:xs)
  | x == ' ' = tokMat xs
  | isDigit x = takeWhile isDigit (x:xs) : tokMat (dropWhile isDigit(x:xs))
  | otherwise = [x] : tokMat xs

-- ---------------------------------------------------------------------------
--   Følgende spørsmål er litt mer utfordrende. Ingen grunn til panikk hvis du
--   ikke får dem til.
--
-- Oppgave 6
--
--   Vi lager et programmeringsspråk med lambda-uttrykk lignende til Haskell
--   sine, men som kan ha kun ett argument og markeres med '|' istedenfor '\',
--   f.eks.:
--     | x -> x
--   er en identitesfunksjon. Et slikt lambda-uttrykk starter altså med |,
--   etterfulgt av et variablenavn (en streng som starter med en liten bokstav
--   og inneholder kun bokstaver), deretter -> og et vilkårlig uttrykk (enten
--   aritmetisk med binære +,-,* og /, eller et nytt lambda-uttrykk med et nytt
--   argument). Definer en tokeniser
--     langTok :: String -> [String]
--   f.eks.:
--     ghci> langTok "|eks -> eks + 10"
--     ["|", "eks", "->", "eks", "+", "10"]
-- ---------------------------------------------------------------------------

langTok :: String -> [String]
langTok = undefined
