-- | Week 7 — the lecturer's sheet: oppgaver uke7 (uke 40).
--
--     ./check.sh 7 --oppg          just this sheet
--     ./check.sh 7 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke40/exercises/uke7.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
-- This sheet is about IO (his lecture 7, 7-IO-hand.pdf, and Hutton 10). Every
-- task is an IO action, so the tests run your actions with stdin fed from a
-- string and stdout captured, then look at what was printed. The sheet never
-- says what your prompts or messages should say, so the tests don't either:
-- they only look for the RESULTS in what you print, and print whatever you
-- like around them.
--
-- An action that keeps asking for input after the tests have run out of it
-- shows up as a FAIL ("asked for more input"), not a todo. That usually means
-- it didn't stop when it should have.
--
-- Everything builds on your OPN evaluator from sheet 4, task 6. Both weeks'
-- modules are called Oppgaver, so one can't import the other: your tokMat,
-- evalOPN and eval are copied in at the bottom of this file.
module Oppgaver where

import Data.Char (isDigit)

-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Definer en aksjon
--     expr :: String -> IO ()
--   som leser fra skjermen et uttrykk i OPN (oppgave 6, uke 4; bruk helst
--   funksjonen eval fra den tidligere oppgaven) og skriver ut resultatet av
--   dets evaluering. Dette gjentas inntil brukeren oppgir tallet 0.
--
-- The sheet doesn't say what expr's String argument is for -- a prompt to
-- show, or the first expression to evaluate. Pick one and say which in a
-- comment. The tests pass either way: they call expr "1 2 +" and only check
-- what comes from the lines it reads.
-- ---------------------------------------------------------------------------

expr :: String -> IO ()
expr = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 2
--
--   Definer en aksjon
--     lesev :: IO ()
--   som ber brukeren om navn på
--   (a) en fil fra hvilken den skal lese input, og
--   (b) en fil til hvilken den skal skrive resultatet.
--   Hver linje i filen (a) antas å inneholde ett uttrykk i OPN. Aksjonen
--   leser hver linje, evaluerer uttrykket, og skriver resultatet i en ny
--   linje i filen (b).
--
-- The tests type the two file names on two lines, (a) first, then read file
-- (b) and expect one result per line.
-- ---------------------------------------------------------------------------

lesev :: IO ()
lesev = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Definer en aksjon
--     main::IO ()
--   for en interaksjon der bruker kan gi følgende kommandoer:
--     exp uttrk – der uttrk er et uttrykk i OPN - evalueringsresultatet av
--                 uttrk skrives på skjermen;
--     les fil-a fil-b – aksjonen lesev fra oppgave 2 utføres med filnavn
--                       fil-a og fil-b;
--     q – main avslutes og kontrollen returnerer til ghci.
--
-- Note that "les" hands main the file names on the command line, while lesev
-- in oppgave 2 asks for them. Working out how to share the evaluating part
-- between the two is part of the task.
-- ---------------------------------------------------------------------------

main :: IO ()
main = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Utvid main fra oppgave 3 med kommandoer:
--     asf filnavn - som leser et OPN uttrykk fra filen med filnavn og viser
--                   dets AST på skjermen.
--     pre uttrk – der uttrk er i OPN; aksjonen bygger AST for det og skriver
--                 uttrykket på skjermen i PN (dvs., polsk eller prefiks
--                 notasjon)
--     inf uttrk – som aksjonen over, bare at den skriver på skjermen
--                 uttrykket i vanlig infiks notasjon (med nødvendige
--                 parenteser).
--   Definer først en passende datatype Ast som konstrueres for input
--   uttrykket.
--
-- Ast is yours to design, so the tests never look inside it: they check pre
-- and inf through what main prints, ignoring spaces. "Nødvendige parenteser"
-- is taken literally -- only the brackets the meaning needs, so 1 2 - 3 -
-- is 1-2-3 but 1 2 3 - - is 1-(2-3). asf's output depends entirely on your
-- Ast's Show, so it has no tests: try it in GHCi.
--
-- The empty declaration below compiles as it is. Give it constructors (and
-- 'deriving Show', for asf).
-- ---------------------------------------------------------------------------

data Ast

-- ---------------------------------------------------------------------------
-- Copied from week04/Oppgaver.hs (sheet 4, task 6), with tokMat from week03.
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

tokMat :: String -> [String]
tokMat [] = []
tokMat (x:xs)
  | x == ' ' = tokMat xs
  | isDigit x = takeWhile isDigit (x:xs) : tokMat (dropWhile isDigit(x:xs))
  | otherwise = [x] : tokMat xs
