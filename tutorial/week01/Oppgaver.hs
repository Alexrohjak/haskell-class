-- | Week 1 — the lecturer's sheet: oppgaver uke1 (uke 34).
--
--     ./check.sh 1 --oppg          just this sheet
--     ./check.sh 1 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke34/exercises/uke1.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
--   "Oppgavene i boken løses uavhengig av oppgavene som gis hver uke.
--    Spørsmål om oppgavene i boken kan også tas opp i gruppene."
module Oppgaver where

-- ---------------------------------------------------------------------------
-- Oppgave 1
--
--   Definer funksjon
--     plu :: [Int] -> Int -> [Int]
--   som tar en liste av tall xs og et tall k, og returnerer listen xs med
--   hvert tall økt med k, f.eks. plu [1,2,5] 4 = [5,6,9].
-- ---------------------------------------------------------------------------

plu :: [Int] -> Int -> [Int]
plu [] k = []
plu (x:xs) k = x + k : plu xs k

-- ---------------------------------------------------------------------------
-- Oppgave 2
--
--   Definer funksjon
--     pali :: String -> Bool
--   som returnerer True hvis inputstrengen er en palindrome (identisk lest
--   forfra og bakfra), og False ellers.
-- ---------------------------------------------------------------------------

pali :: String -> Bool
pali xs = xs == reverse xs

-- ---------------------------------------------------------------------------
-- Oppgave 3
--
--   Justering av tekst i kolonner krever forskyvning til venstre eller til
--   høyre. En måte er å legge til passende antall blanker i starten eller
--   enden av strengen, f.eks.:
--     hjuster 6 "word" = "  word"
--   mens
--     vjuster 6 "word" = "word  "
--
--   Definer disse to funksjonene. Hva gjør de når input er lengre enn den
--   oppgitte lengden? Er det det man skulle ønske, og hvis ikke, hvordan
--   ville du løse det?
--
-- The sheet gives no type signatures; these are the obvious ones.
--
-- The tests don't touch the "input longer than the width" case -- that's the
-- question the sheet asks YOU. Answer it here, in a comment:
--
--   Svar: It gives just an empty string, so the hjuster function just
--   returns "word"
-- ---------------------------------------------------------------------------

hjuster :: Int -> String -> String
hjuster k xs = replicate (k - length xs) ' ' ++ xs

vjuster :: Int -> String -> String
vjuster k xs = xs ++ replicate (k - length xs)' '

-- ---------------------------------------------------------------------------
-- Oppgave 4
--
--   Definer funksjon
--     evens :: [a] -> [a]
--   som returnerer subliste av argumentlisten med kun elementer fra like
--   posisjoner, f.eks.
--     evens "abcde" = "ace"
--   og tilsvarende funksjon
--     odds :: [a] -> [a]
--   som returnerer sublisten med elementer fra ulike posisjoner, f.eks.
--     odds "abcde" = "bd" .
-- ---------------------------------------------------------------------------

evens :: [a] -> [a]
evens [] = []
evens (x:xs) = x : odds xs

odds :: [a] -> [a]
odds [] = []
odds (x:xs) = evens xs

-- ---------------------------------------------------------------------------
-- Oppgave 5
--
--   Definer nå en funksjon
--     evensOdds :: [a] -> ([a],[a])
--   som returnerer par av sublister
--     evensOdds xs = (evens xs, odds xs)
--   men som gjør det ved å traversere input kun én gang.
--
-- The tests can only check the RESULT. "Kun én gang" -- one pass over the
-- input -- is invisible to them, so a green light here doesn't mean done.
-- That part is what the idiom review is for.
-- ---------------------------------------------------------------------------

evensOdds :: [a] -> ([a], [a])
evensOdds [] = ([], [])
evensOdds (x:xs) = (x : o, e)
  where (e, o) = evensOdds xs
