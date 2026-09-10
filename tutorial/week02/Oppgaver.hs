-- | Week 2 — the lecturer's sheet: oppgaver uke2 (uke 35).
--
--     ./check.sh 2 --oppg          just this sheet
--     ./check.sh 2 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke35/exercises/uke2.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
--
-- This sheet is mostly TYPES, which is exam material in its purest form: on
-- 2 December you will be asked for types on paper with no GHCi. So work each
-- one out by hand first, write your answer into the comment, and only THEN ask
-- GHCi. Only two answers here are code the tests can see: e7 and alleBoolFns.
-- For everything else the compiler is the checker:
--
--   * ":t expr" in GHCi gives the most general type of an expression.
--   * A signature you write in this file either compiles or it doesn't.
--
-- docs/checking-your-work.md has more on checking answers nobody tests.
module Oppgaver where

-- ---------------------------------------------------------------------------
-- Oppgave 1  -- paper, then :t
--
--   Bestem typer til følgende uttrykk:
--
--     False :: ?
--     5 + 8 :: ?
--     (+) 2 :: ?
--     (["foo", "bar"], 'a')  :: ?
--     [(True, []), (False, [['a']])]  :: ?
--     \x y ->  y !! x  :: ?
--     [ take, drop, \x y ->  [ y !! x ] ] :: ?
--
-- Svar:
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Oppgave 2  -- fill in the question marks
--
--   Fyll inn spørsmålstegn:
--
-- The definitions are already here, so the file compiles. For each one, write
-- your type in place of the ? and uncomment the line. If it still compiles,
-- the type is valid; compare it against :t to see if it's the MOST general.
--
-- The sheet's e3 and e4 use typographic quotes (“a”, ‘a’). Those aren't
-- Haskell -- they're copied here as the "a" and 'a' that were meant.
-- ---------------------------------------------------------------------------

-- e1 :: ?
e1 = [False, True, False]

-- e2 :: ?
e2 = [[1,2],[3,4]]

-- e3 :: ?
e3 = [ ("a",7) ]

-- e4 :: ?
e4 = [ ('a',7) ]

-- e5 :: ?
e5 x = x * 2

-- e6 :: ?
e6 (x,y) = x

-- e7 is the other way round: the type is given, you write the definition.
e7 :: a -> (a,a)
e7 = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 3  -- paper, then :t
--
--   Gi mest generell type for hver funksjon definert under
--
--     app f x = f x
--     com f g x = f (g x)
--     sub f g x = (f x) (g x)
--     fix f = f (fix f)
--     selv f = f f
--
-- Not copied into the file as code: with no signatures that would just be
-- GHC doing the exercise for you. Once you have your answers on paper, try
-- each one in GHCi as  let app f x = f x  and then  :t app.
--
-- Svar:
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Oppgave 4  -- paper
--
--   Hvilke av ligningene nedenfor er feiltypet? For de som er riktig typet,
--   hva kan du si om typen til xs, og hvilke av dem holder?
--
--     [] : xs = xs
--     [] : xs = [[],xs]
--     xs : [] = xs
--     xs : [] = [xs]
--     xs : xs = [xs,xs]
--     xs : [xs] = [xs,xs]
--     [[]] ++ xs = xs
--     [[]] ++ xs = [xs]
--     [[]] ++ xs = [[],xs]
--     [[]] ++ [xs] = [[],xs]
--     [xs] ++ [] = [xs]
--     [xs] ++ [xs] = [xs,xs]
--
-- Svar:
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Oppgave 5  -- paper, and one piece of code
--
--   Det finnes to ting (True og False) av type Bool. Hvor mange forskjellige
--   ting finnes med hver av følgende typer:
--
--     1. Bool -> Bool
--     2. Bool -> Bool -> Bool
--     3. Bool -> Bool -> Bool -> Bool
--     4. (Bool, Bool)
--     5. (Bool, Bool) -> Bool
--     6. (Bool, Bool, Bool)
--     7. (Bool, Bool, Bool) -> Bool
--     8. (Bool -> Bool) -> Bool
--     9. (Bool -> Bool -> Bool) -> Bool
--     10.((Bool -> Bool) -> Bool) -> Bool
--
--   (Hint: Hvis mengdene A og B har henholdsvis a og b elementer, er
--   antallet funksjoner fra A til B lik b^a (b opphøyd i a).)
--
-- Svar:
--
--   Definer i Haskell alle funksjoner med typen Bool -> Bool.
--
-- Define each one as its own named function, then list them all in
-- alleBoolFns. The tests check that no two in the list behave the same and
-- that none is missing -- so they also check your answer to 5.1.
-- ---------------------------------------------------------------------------

alleBoolFns :: [Bool -> Bool]
alleBoolFns = undefined
