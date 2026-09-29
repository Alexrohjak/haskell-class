-- | Week 6 — the lecturer's sheet: oppgaver uke6 (uke 39).
--
--     ./check.sh 6 --oppg          just this sheet
--     ./check.sh 6 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke39/exercises/uke6.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
-- This sheet is about DATA TYPES and their NATURAL FOLDS (his lecture 6,
-- 6-typer(kap8).pdf). foldr is Hutton 7, this folder's LESSON.md; declaring
-- your own types is Hutton 8, ../week07/LESSON.md. Read both for this sheet.
--
-- Oppgave 2 is Hutton 8.5 and 8.6 -- folde, eval and size for Expr. The book
-- track already has those, so they are not repeated here: they are Exercise 6
-- in ../week07/Exercises.hs (folde, evalE, sizeE), checked by
-- ./check.sh 7 --book. One difference: the tutorial's Expr also has Mul, so
-- its folde takes one more function than the book's.
--
-- Two tasks ask you to work out a TYPE: 3.c ("tenk først hvilken type den skal
-- ha") and 4.a (the sheet writes foldL's argument types as "..." on purpose).
-- So foldN and foldL below have no type signature -- writing it is part of the
-- task. The stubs compile without one, and the tests never say what the type
-- is: foldN is only checked through nat2Int, and foldL only through the
-- property the sheet states and through list. Put your signature in above
-- your definition.
--
-- Oppgave 1 says "v.hj.a. foldr" and 3.d/4.b say "bruk foldN"/"bruk foldL".
-- The tests can only check the answers, never the method, so for those a
-- green light means "correct", not "done".
--
-- 3.b and 5 are paper tasks: questions in comments, no tests.
module Oppgaver where

-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Skriv følgende funksjonen for kartesisk produkt v.hj.a. foldr:
--     cp :: [[a]] -> [[a]]
--     cp [] = [[]]
--     cp (xs:xss) = [ x:ys | x <- xs, ys <- cp xss ]
--
-- The recursive definition above is the specification; the tests compare
-- your cp against it.
-- ---------------------------------------------------------------------------

cp :: [[a]] -> [[a]]
cp = foldr (\xs r -> [x:ys | x <- xs, ys <- r]) [[]]

-- ---------------------------------------------------------------------------
-- Oppgave 2
--
--   Oppgaver 8.5 og 8.6 fra boken.
--
-- Not here: see the header. They are Exercise 6 in ../week07/Exercises.hs.
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Naturlige tall (heltall >= 0) kan representers som
--     data Nat = Z | S Nat
--
-- Copied as given. There is no deriving clause, because the tests don't need
-- one: so GHCi can't print a Nat. Add 'deriving Show' yourself if you want
-- to look at them.
-- ---------------------------------------------------------------------------

data Nat = Z | S Nat

-- ---------------------------------------------------------------------------
-- Oppgave 3.a
--
--   Skriv 0, 1, og 7 i denne representasjonen.
--
-- A paper answer, but give it names so it can be checked. The tests check
-- these through your nat2Int (3.d), so they stay 'todo' until 3.d is done.
-- ---------------------------------------------------------------------------

zero, one, seven :: Nat
zero  = Z
one   = S Z
seven = S (S (S (S (S (S (S Z))))))

-- ---------------------------------------------------------------------------
-- Oppgave 3.b
--
--   Hva er konstruktorer, og deres typer, for Nat?
--
-- On paper. Check yourself with :t in GHCi (./check.sh 6 --oppg --repl).
-- ---------------------------------------------------------------------------

-- Z :: Nat
-- S :: Nat -> Nat

-- ---------------------------------------------------------------------------
-- Oppgave 3.c
--
--   Definer naturlig fold for Nat, nemlig foldN; tenk først hvilken type den
--   skal ha.
--
-- No signature on purpose -- working out the type is the task. Write it
-- yourself above your definition. There are no direct tests of foldN: it is
-- checked through nat2Int.
-- ---------------------------------------------------------------------------
foldN :: b -> (b -> b) -> Nat -> b
foldN z s Z = z
foldN z s (S n) = s (foldN z s n)

-- ---------------------------------------------------------------------------
-- Oppgave 3.d
--
--   Bruk foldN for å definere konversjon nat2Int :: Nat -> Int.
-- ---------------------------------------------------------------------------

nat2Int :: Nat -> Int
nat2Int = foldN 0 (\z -> z + 1)

-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Typen av ikke-tomme lister med elementer av type a kunne defineres ved
--     data List a = Wrap a | Cons a (List a)
--
--   `foldr` er naturlig fold for lister, slik at `foldr (:) []` er identitet
--   på lister, dvs. foldr (:) [] xs == xs, for envher liste xs::[a]. En
--   tilsvarende egenskap for
--     foldL :: ... -> ... -> Pist a -> b
--   blir at `foldL Wrap Cons` er identiteten på `List a`, dvs.
--   foldL Wrap Cons ls == ls, for enhver ls::List a.
--
-- ("Pist a" is a typo in the sheet for "List a".)
--
-- The data type is copied as given, plus 'deriving (Show, Eq)': the sheet's
-- examples in 4.b show GHCi printing a List, and the tests compare them.
-- ---------------------------------------------------------------------------

data List a = Wrap a | Cons a (List a)
  deriving (Show, Eq)

-- ---------------------------------------------------------------------------
-- Oppgave 4.a
--
--   Definer foldL slik at denne egenskapen holder.
--
-- No signature on purpose -- the sheet leaves the two argument types as
-- "...", and filling them in is the task. Write it yourself above your
-- definition. The tests check the property the sheet states,
-- foldL Wrap Cons ls == ls, and use foldL through your list (4.b).
-- ---------------------------------------------------------------------------

foldL = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 4.b
--
--   Bruk foldL (og evt. andre fold) for å definere funksjoner
--     clist :: [a] -> List a
--     list :: List a -> [a]
--   s.a., f.eks.:
--     ghci> clist [1, 2, 3]
--     Cons 1 (Cons 2 (Wrap 3))
--   og
--     ghci> list (Cons 1 (Cons 2 (Wrap 3)))
--     [1, 2, 3]
--
-- A List is never empty, so clist [] has no sensible answer; it isn't part of
-- the task and isn't tested.
-- ---------------------------------------------------------------------------

clist :: [a] -> List a
clist = undefined

list :: List a -> [a]
list = undefined

-- ---------------------------------------------------------------------------
-- Oppgave 5
--
--   Dette er et litt vanskeligere spørsmål for spesialinteresserte. Bevis ved
--   induksjon at:
--     foldr f c (xs ++ ys) == foldr f (foldr f c ys) xs
--
-- On paper.
-- ---------------------------------------------------------------------------
