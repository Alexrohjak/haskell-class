-- | Week 5 — the lecturer's sheet: oppgaver uke5 (uke 38).
--
--     ./check.sh 5 --oppg          just this sheet
--     ./check.sh 5 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke38/exercises/uke5.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
-- This sheet is about HIGHER-ORDER FUNCTIONS and FOLDS (his lecture 5,
-- 5-HO-hand.pdf), and oppgave 5 declares a data type and an Eq instance.
-- The book track covers those in weeks 6 and 7 -- Hutton 7 and 8 -- so the
-- lecturer is ahead of the tutorial again: LESSON.md in ../week06 and
-- ../week07 is the reading for this sheet.
--
-- Tasks 2.b, 3 and 4 say "enkel foldl eller foldr", and 1.a says "ved å bruke
-- zipW". The tests can only check the answers, never the method, so for those
-- a green light means "correct", not "done".
module Oppgaver where

import Data.Char (digitToInt)

-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Programmer funksjon
--     zipW :: (a -> b -> c) -> [a] -> [b] -> [c]
--   som gjør det samme som zipWith gjør, dvs. zipper two lister ved å anvende
--   funksjonen i første argumentet på respektive par av elementer fra hver
--   liste inntil en av listene blir tomme, f.eks.:
--     zipW plus [4,5,6,7] [1,2,3] = [5,7,9]
--     zipW (-) [4,5,6,7] [1,2,5] = [3,3,1]
-- ---------------------------------------------------------------------------

zipW :: (a -> b -> c) -> [a] -> [b] -> [c]
zipW _ [] _ = []
zipW _ _ [] = []
zipW f (x:xs) (y:ys) = f x y : zipW f xs ys

-- plus a b = a + b

-- ---------------------------------------------------------------------------
-- Oppgave 1.a
--
--   Programmer funksjonen zip ved å bruke zipW.
--
-- Called zip' so it doesn't clash with the Prelude's zip.
-- ---------------------------------------------------------------------------

zip' :: [a] -> [b] -> [(a, b)]
zip' = zipW (\x y -> (x, y))

-- ---------------------------------------------------------------------------
-- Oppgave 2
--
--   Vi kan konvertere String som representerer et tall til Int ved å si
--   "read str :: Int". Du skal programmere denne funksjonen selv og du kan
--   bruke her funksjon
--     digitToInt :: Char -> Int
--   fra Data.Char.
--
-- (digitToInt is already imported at the top of the file.)
--
-- Oppgave 2.a
--
--   Bruk mønstre for å programmere
--     strToInt :: String -> Int
--   som konverterer en String til en Int
--     strToInt "2" == 2,
--     strToInt "1398" == 1398.
-- 10 + 3 = 13
-- 130 + 9 =
--
-- Oppgave 2.b
--
--   Programmer nå funksjonen strToInt ved å bruke enkel foldl eller foldr.
--
-- So it appears twice: strToInt with patterns, strToIntF with a fold. The
-- tests hold both to the same answers. The empty string and negative numbers
-- aren't part of the task and aren't tested.
-- ---------------------------------------------------------------------------

strToInt :: String -> Int
strToInt [] = 0
strToInt (x:xs) = (digitToInt x * m) + strToInt xs
  where m = 10 ^ length xs

strToIntF :: String -> Int
strToIntF xs = foldl (\acc c -> acc * 10 + digitToInt c) 0 xs

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Et heltallspolynom an * x^n + ... + a1 * x + a0 representeres som en liste
--   med koeffisienter [an,...,a1,a0]. Bruk enkel foldl eller foldr for å
--   definere evaluering
--     poly :: [Int] -> Int -> Int
--   av polynomet gitt i første argumentet med x verdi gitt i andre, f.eks.:
--     poly [3,1,1] 2 == 15 (dvs. 3*2^2 + 2^1 + 1)
--     poly [5,0,2] 3 == 47 (dvs. 5*3^2 + 2)
--
-- The empty coefficient list isn't specified and isn't tested.
-- ---------------------------------------------------------------------------

poly :: [Int] -> Int -> Int
poly xs x = foldl (\acc c -> acc + polyLedd c x) 0 (revIndex xs)

revIndex :: [a] -> [(a, Int)]
revIndex xs = zip xs (reverse [0..length xs - 1])

polyLedd :: (Int, Int) -> Int -> Int
polyLedd (coeffisient, potens) x = coeffisient * (x ^ potens)

-- poly xs x = foldl (\acc c -> acc * x + c) 0 xs
-- [3,1,1] 2
-- 1 = acc 0, c 3 -> 0*2 + 3
-- 2 = acc 3, c 1 -> (0*2 + 3)*2 + 1
-- 3 = acc 7, c 1 -> ((0*2 + 3)*2 + 1)*2 + 1
-- evaluate, innermost first:
-- 4 =           (3*2 + 1)*2 + 1
-- 5 =                  7*2 + 1
-- 6 =


-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Bruk enkel foldl eller foldr for å programmer funksjon
--     kompress :: (Eq a) => [a] -> [a]
--   som fjerner påfølgende duplikater fra an liste, f.eks.:
--     kompress "aababbccc" = "ababc"
--     kompress [1,1,1,2,2,2] = [1,2]
-- ---------------------------------------------------------------------------

kompress :: (Eq a) => [a] -> [a]
kompress xs = foldl cond [] xs

cond :: Eq a => [a] -> a -> [a]
cond [] c = [c]
cond xs c
  | c == last xs = xs
  | otherwise = xs ++ [c]

-- ---------------------------------------------------------------------------
-- Oppgave 5
--
--   Mengder (forstått matematisk) kan konstrueres med tre operasjoner. En
--   mengde er enten
--   - den tomme mengden Ø, eller
--   - en mengde {x} med kun ett element x, eller
--   - en sum X ∪ Y av to mengder X og Y.
--
-- Oppgave 5.a
--
--   Definer Haskell datatype som uttrykker mengder på denne måten, dvs. fyll
--   inn for ...:
--     data Set a = ... | ... | ...
--
-- The declaration below has no constructors yet, which is legal Haskell and
-- lets the file compile until you write them. The names are yours to choose,
-- so the tests can't know them. They build sets through the three one-liners
-- underneath instead: once your data type is in, make each of them just one
-- of your constructors. They are plumbing for the tests, not part of the task.
--
-- Don't derive Eq -- writing it by hand is 5.d.
-- ---------------------------------------------------------------------------

data Set a = Empty | En a | Sum (Set a) (Set a)

-- | Ø
tomM :: Set a
tomM = Empty

-- | {x}
enM :: a -> Set a
enM = En

-- | X ∪ Y
sumM :: Set a -> Set a -> Set a
sumM = Sum

-- ---------------------------------------------------------------------------
-- Oppgave 5.b
--
--   Definer funksjon
--     med :: Eq a => a -> Set a -> Bool
--   som bestemmer om første argumentet er et element av mengden i andre
--   argumentet.
-- ---------------------------------------------------------------------------

med :: Eq a => a -> Set a -> Bool
med x Empty = False
med x (En y) = x == y
med x (Sum y z) = med x y || med x z

-- ---------------------------------------------------------------------------
-- Oppgave 5.c
--
--   Definer funksjon
--     delm :: Eq a => Set a -> Set a -> Bool
--   som bestemmer om den første mengden er en delmengde av den andre (dvs.
--   ethvert element av den første er også med i den andre).
-- ---------------------------------------------------------------------------

delm :: Eq a => Set a -> Set a -> Bool
delm Empty y = True
delm (En x) y = med x y
delm (Sum x z) y = delm x y && delm z y

-- ---------------------------------------------------------------------------
-- Oppgave 5.d
--
--   To mengder er like hvis de har de samme elementene. For en (Eq a) type a,
--   gjør typen (Set a) til en instans av Eq, dvs. fullfør følgende
--   definisjonen ved å definere likhestsfunksjon (==) for elementer av typen
--   (Set a):
--     instance  (Eq a) => Eq (Set a) where
--       x == y = ...
-- ---------------------------------------------------------------------------

instance (Eq a) => Eq (Set a) where
  x == y = delm x y && delm y x
