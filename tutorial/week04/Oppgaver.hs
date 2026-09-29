-- | Week 4 — the lecturer's sheet: oppgaver uke4 (uke 37).
--
--     ./check.sh 4 --oppg          just this sheet
--     ./check.sh 4 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke37/exercises/uke4.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
-- This sheet is about RECURSION (his lecture 4, 4-rekursjon-handout.pdf).
-- The book track doesn't get there until week 5 -- Hutton 6 -- so this is
-- where the lecturer is a week ahead of the tutorial.
--
-- Several tasks say HOW to solve them: recursively, with a list
-- comprehension, tail-recursively, mutually recursively. The tests can only
-- check the answers, never the method, so for those a green light means
-- "correct", not "done". The method is what the idiom review looks at.
module Oppgaver where

import Data.Char (isDigit)
-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Strengen "127" representerer tallet 127, men typer er forskjellige:
--   "127"::String og 127::Int. En slik streng str, som representerer et
--   heltall, kan konverteres til Int ved å be Haskell om å lese den som Int,
--   nemlig
--     read str :: Int,
--   er et uttrykk og
--     (read "127" :: Int) == 127.
--   Programmer en rekursiv funksjon
--     strInt :: [String] -> [Int]
--   som konverterer en liste av strenger, der hver representerer et heltall,
--   til en liste av tilsvarende tall.
--
--   (Omvendt, et tall 127 kan konverteres til en streng ved å si show 127,
--   f.eks.: show 127 == "127".)
-- ---------------------------------------------------------------------------

strInt :: [String] -> [Int]
strInt = undefined

-- ---------------------------------------------------------------------------
--   Oppgavene 2 og 3 skal løses på to måter: ved å bruke (1) listekomprehensjon
--   og (2) rekursjon.
--
-- So each one appears twice below: ...LK with a list comprehension, ...Rek
-- with recursion. The tests hold both to the same answers.
--
-- Oppgave 2
--
--   Programmer funksjon fjern :: String -> Char -> String
--   som fjerner alle forekomster av tegnet i andre argumentet fra strengen i
--   første argumentet. F.eks.:
--     fjern "ab cd ef" ' '   ==  "abcdef"
--     fjern "ab cd cf" 'c'  ==  "ab d f"
-- ---------------------------------------------------------------------------

fjernLK :: String -> Char -> String
fjernLK s c = [x | x <- s, x /= c]

fjernRek :: String -> Char -> String
fjernRek [] c = []
fjernRek(x:xs) c
  | x == c = fjernRek xs c
  | otherwise = x : fjernRek xs c

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Programmer funksjon tegnpos :: Char -> String -> [Int]
--   som returnerer liste med alle posisjonene i inputstrenger der inputtegnet
--   forekommer, f.eks.
--     tegnpos 'n' "Tannenberg 1410" == [2,3,5]
--     tegnpos '1' "Tannenberg 1410" == [11,13]
-- ---------------------------------------------------------------------------

tegnposLK :: Char -> String -> [Int]
tegnposLK c s = [i | (x, i) <- zip s [0..], x == c]

tegnposRek :: Char -> String -> [Int]
tegnposRek c (str) = tegnposRek' c (str) 0

tegnposRek' :: Char -> String -> Int -> [Int]
tegnposRek' _ [] _ = []

tegnposRek' c (x:xs) y
  | x == c = y : tegnposRek' c xs (y + 1)
  | otherwise = tegnposRek' c xs (y + 1)

-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Funksjon isOdd :: Int -> Bool, kan defineres, f.eks., på følgende måte:
--     isOdd 0 = False
--     isOdd n = not (isOdd (n-1))
--   Definer isOdd
--   (a) med halerekursjon
--   (b) med gjensidig rekursjon ved å definere også isEven.
--
-- (a) is isOddHale. (b) is the pair isOddGj / isEvenGj, each defined in
-- terms of the other. Negative input isn't part of the task and isn't tested.
-- ---------------------------------------------------------------------------

isOddHale :: Int -> Bool
isOddHale = undefined

isOddGj :: Int -> Bool
isOddGj = undefined

isEvenGj :: Int -> Bool
isEvenGj = undefined

-- ---------------------------------------------------------------------------
--   Følgende spørsmål er mer utfordrende. Ingen grunn til panikk hvis du ikke
--   får dem til.
--
-- Oppgave 5
--
--   Fibonacci sekvens starter med tallene: 1, 1, 2, 3, 5, 8, 13, ... og kan
--   defineres som
--     f 0 = 1
--     f 1 = 1
--     f n = f (n-1) + f (n-2)
--
--   Definer rekursivt listen fibs :: [Integer]. (Definisjonen skal altså ha
--   formen
--     fibs = ... fibs ...
--   der uttrykket på høyre side bruker listen fibs og gir en liste. Funksjon
--   zipWith, som lager en liste ved å anvende en gitt funksjon på elementer
--   fra to argumentlister, kan bli nyttig her.)
--
-- fibs is infinite, so the tests only ever look at a prefix of it. If
-- ./check.sh hangs here, your fibs recurses before producing its first
-- element.
-- ---------------------------------------------------------------------------

fibs :: [Integer]
fibs = 1 : 1 : zipWith (+) (fibs) (drop 1 fibs)


-- ---------------------------------------------------------------------------
-- Oppgave 6
--
--   Omvendt polsk notasjon (OPN) tillater å skrive aritmetiske uttrykk uten
--   paranteser. Den plasserer nemlig operatorer etter argumenter. Her antar vi
--   at alle operatorer tar to argumenter. For eksempel, blir "(1 - 22) * 7"
--   skrevet som "1 22 - 7 *", mens "1 - (22 * 7)" som "1 22 7 * -".
--
--   OPN ble brukt i første kalkulatorer, fordi den gir enkel og effektiv
--   evaluering. Vi tenker oss nemlig at mens vi leser et uttrykk i OPN,
--   lagrer vi dets tokens som er tall på en stabel inntil vi leser en
--   operator. Operatoren anvendes så på to siste elementene som fjernes fra
--   stabelen, og resultatet pushes på toppen. Vi fortsetter inntil hele
--   uttrykket er lest og stabelen inneholder kun ett topp element. F.eks. for
--   uttrykket "1 22 - 7 *" pusher vi først 1 og 22 på stabelen; ved innlesing
--   av - henter vi 22 og 1, regner ut 1-22 og pusher resultatet på stabelen.
--   Deretter leser vi 7 som pushes på toppen av stabelen og, ved innlesing av
--   *, popper vi 7 og -21, ganger de, pusher -147 på stabelen og avslutter,
--   siden hele uttrykket ble lest og stabelen inneholder evalueringsresultatet.
--
--   Skriv en evaluator
--     evalOPN :: [Int] -> [String] -> Int
--   som bruker det første argumentet som stabel, mens det andre argumentet er
--   output fra tokMat (oppgave 5 i uke3) anvendt på en streng med et OPN
--   uttrykk. F.eks.:
--     ghci> evalOPN [] ["12", "5", "*", "1", "+"]
--     61
--
--   Definer nå funksjon
--     eval :: String -> Int
--   som tar in en streng med et OPN uttrykk og evaluerer inpututtrykket
--   v.hj.a. tokMat og evalOPN, f.eks.:
--     ghci> eval "1 2 3 * +"
--     7
--     ghci> eval "12 5 * 1 -"
--     59
--
-- The type above is the corrected one: the lecturer's announcement of 9 Sep
-- ("Skrivefeil i oppgave 6, uke 4") fixed [[String]] to [String].
--
-- eval needs tokMat from uke3. Both weeks' modules are called Oppgaver, so
-- one can't import the other: copy your tokMat from week03/Oppgaver.hs into
-- the stub below. Until you do, the eval tests stay 'todo'.
-- ---------------------------------------------------------------------------

evalOPN :: [Int] -> [String] -> Int
evalOPN [x] [] = x
evalOPN (y:x:rest) ("+":ts) = evalOPN (x + y : rest) ts
evalOPN (y:x:rest) ("-":ts) = evalOPN (x - y : rest) ts
evalOPN (y:x:rest) ("*":ts) = evalOPN (x * y : rest) ts
evalOPN (y:x:rest) ("/":ts) = evalOPN (x `div` y : rest) ts
evalOPN stack (t:ts) = evalOPN (read t : stack) ts

eval :: String -> Int
eval s = evalOPN x (tokMat s)
  where x = []

-- Copied from week03/Oppgaver.hs.
tokMat :: String -> [String]
tokMat [] = []
tokMat (x:xs)
  | x == ' ' = tokMat xs
  | isDigit x = takeWhile isDigit (x:xs) : tokMat (dropWhile isDigit(x:xs))
  | otherwise = [x] : tokMat xs
