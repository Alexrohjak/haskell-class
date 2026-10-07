-- | Week 9 — the lecturer's sheet: oppgaver uke9 (uke 42).
--
--     ./check.sh 9 --oppg          just this sheet
--     ./check.sh 9 --oppg --repl   GHCi with this file loaded
--
-- The book exercises for the week are next door in Exercises.hs; these are
-- the ones Walicki hands out. The original text is
-- weeks/uke42/exercises/uke9.txt, and it is the source of truth -- the task
-- statements below are copied from it verbatim.
--
-- There are no reference answers for this file, on purpose: the lecturer asks
-- that AI not solve these, and the groups don't hand out solutions either.
-- The tests check what the sheet specifies and nothing more. When they're
-- green, ask for an idiom review.
--
-- This sheet is about TYPE INFERENCE: Hindley-Milner and unification. That is
-- in no chapter of Hutton -- his lecture notes are the only source, and they
-- are not in weeks/uke42/slides/ yet.
--
-- DEL I is eight paper tasks: derive a type by hand, the way the exam will
-- ask. They are questions in comments, with no tests. GHCi's :t will tell you
-- whether you landed on the right type (up to the names of the type
-- variables), but only ask it AFTER the derivation is on paper -- the exam
-- marks the equations, not the last line.
--
-- DEL II is code: the unification algorithm you used by hand in DEL I. Once
-- unify is green you have a second way to check DEL I: write your equations
-- as a [(Type, Type)] and see whether unify gives the type you derived.
--
-- Two things about the tests. They never go through your Show instance
-- except in task 1, so subst, occursIn and unify can go green in any order.
-- And every unify check has a 5-second limit: this algorithm loops forever
-- when a rule puts back what another rule took away, and that shows up as a
-- FAIL ("still running"), not a hang.
module Oppgaver where

-- ===========================================================================
-- DEL I - TYPEAVLEDNING
--
--   Bruk Hindley-Milner (og deretter unifikasjon) for å besvare spørsmål i
--   denne delen.
--   Husk at funksjonsapplikasjon assosierer til venstre, mens
--   funksjonsabstraksjon, dvs. ->, til høyre. Altså:
--           a b c            er det samme som    ((a b) c),
--   mens    \x -> \y -> x y  er det samme som    \x -> (\y -> (x y)) .
--
-- All on paper. Write your derivations wherever you like; a comment under
-- each task works.
-- ===========================================================================

-- ---------------------------------------------------------------------------
-- Oppgave I.1
--
--   Gitt følgende definisjon
--       pro x y = x
--   finn typen til pro, dvs. et typeuttrykk t slik at
--       pro :: t
--   eller vis at pro er feiltypet.
--   (Hint: skriv først en ekvivalent definisjon på formen: pro = …)
--
-- pro is left as a comment on purpose: defined for real, the editor would
-- show its type on hover. Uncomment it when you want to ask :t.
-- ---------------------------------------------------------------------------

-- pro x y = x

-- ---------------------------------------------------------------------------
-- Oppgave I.2
--
--   Finn typen til (pro 2) fra punkt 1, eller vis at det er feiltypet.
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Oppgaver I.3 - I.8
--
--   Finn typer til følgende uttrykk eller vis at de er feiltypet:
--
--   3. \x -> \y -> x y
--
--   4. \x -> \y -> (x y) x
--
--   5. \x -> \y -> x (y x)
--
--   6. \x -> \y -> x y x
--
--   7. \x -> x (\y -> x y)
--
--   8. \x -> \y -> \z -> (x z) (y z)
-- ---------------------------------------------------------------------------

-- ===========================================================================
-- DEL II - UNIFIKASJON
--
--   Oppgaven er å implementere unifikasjonsalgoritme for en liten del av
--   Haskells typespråk, som innholder kun typevariabler og funksjonstyper.
--   Vi skal bruke
--
--       data Type = Var String | Arrow Type Type
--          deriving Eq
--
--   F.eks., `a -> b` representeres som `Arrow (Var "a") (Var "b")`,
--   `Int -> Int -> Bool` som
--   `Arrow (Var "Int") (Arrow (Var "Int") (Var "Bool"))` og
--   `(Int -> Int) -> Bool` som
--   `Arrow (Arrow (Var "Int") (Var "Bool")) (Var "Int")`.
--
-- The last example looks like a slip in the sheet: that value has Bool and
-- the second Int swapped. Work out which type it really represents -- it is
-- a good warm-up for task 1.
-- ===========================================================================

data Type = Var String | Arrow Type Type
  deriving Eq

-- ---------------------------------------------------------------------------
-- Oppgave II.1
--
--   Gjør Type til en instans av Show klassen ved å deklarere
--       instance Show Type where
--           show ... =
--   og definere funksjon `show` slik at, f.eks.:
--
--       ghci> show $ Arrow (Var "Int") (Arrow (Var "Int") (Var "Bool"))
--           "Int -> Int -> Bool"
--       evt. "Int -> (Int -> Bool)", og
--
--       ghci> show $ Arrow (Arrow (Var "a") (Var "b")) (Var "c")
--           "(a -> b) -> c"
--
-- The sheet allows both spellings of the first example, so the tests do too:
-- they read your string back as a type and compare it with the value shown.
-- Brackets that aren't needed and extra spaces are fine; brackets that ARE
-- needed and missing are not.
-- ---------------------------------------------------------------------------

instance Show Type where
  show = undefined

-- ---------------------------------------------------------------------------
-- Oppgave II.2
--
--   Unifikasjon krever substitusjon av termer for variabler (av typetermer
--   for typevariabler fra Type). Notasjon for substitutsjon
--       F[x\t]
--   betyr: "uttrykket F med hver x erstattet med t". F.eks.
--       `(a -> b)[b\c]` blir `a -> c`.
--
--   Definer funksjon `subst :: String -> Type -> Type -> Type`, der
--   - det første argumentet er navnet til typevariabelen som skal
--     substituteres for (x eller b over)
--   - det andre argumentet er typeuttrykk som skal substituteres inn (t
--     eller c over)
--   - det tredje argumnetet er typeuttrykk i hvilken vi substituterer (F
--     eller (a->b) over)
--
--   For eksempel:
--       ghci> subst "b" (Var "c") (Arrow (Var "a") (Var "b")) -- (a -> b)[c/b]
--       a -> c
--
--       ghci> subst "Int" (Var "Double") (Arrow (Var "Int") (Arrow (Var "Int") (Var "Bool")))
--       Double -> Double -> Bool
--
--   GHCis output ser ut som det gjør pga. show funksjon du har definert i
--   Type som instans av Show.
-- ---------------------------------------------------------------------------

subst :: String -> Type -> Type -> Type
subst = undefined

-- ---------------------------------------------------------------------------
-- Oppgave II.3
--
--   Definer funksjon
--       `occursIn :: String -> Type -> Bool`
--
--   som tar et (type)variabelnavn og et typeuttrykk og sier om variabelen
--   forekommer i uttrykket, f.eks.:
--
--       ghci> occursIn "x" (Arrow (Var "x") (Var "y"))
--       True
--
--       ghci> occursIn "x" (Var "int")
--       False
-- ---------------------------------------------------------------------------

occursIn :: String -> Type -> Bool
occursIn = undefined

-- ---------------------------------------------------------------------------
-- Oppgave II.4
--
--   Unifikasjon for typesjekking foretas med tanke på å unifisere den
--   initielle typevariabelen, som vi kaller "t" (dvs. Var "t"). Implementer
--   funksjon
--       unify :: [(Type, Type)] -> String -> Type
--   som tar
--   - en liste med ligninger - hvert par (s,t)::(Type,Type) er en ligning
--     s=t,
--   - navnet på den initielle typevariabelen,
--   og returnerer typeuttrykk som vellykket unifikasjon tilordner til den
--   initielle typevariabelen.
--
--   Med "t" som den initielle typevariabelen, går algoritmen gjennom listen
--   av ligninger og utfører operasjon tilsvarende dens definisjon fra
--   forelesninger, avhengig av elementet i starten av listen:
--   1. (Var "t", x) flyttes til slutten av listen, mens
--      (x, Var "t") fjernes og (Var "t", x) plasseres på slutten av listen;
--   2. (Var x, y), der x ikke forekommer i y, fjernes mens hver `Var x` i
--      resten av listen substitueres med y
--   3. (Arrow x y, Arrow a b) erstattes med (x,a) og (y,b)
--   4. (y, Var x) erstattes med (Var x, y)
--   5. Enhver annen situasjon gir en feilmelding og mislykket unifikasjon.
--   Passende halerekursive kall skal utføres og algoritmen terminerer når
--   listen har kun ett element (Var "t",x) - x returneres.
--
--   F.eks.:
--
--     unify [(Arrow (Var "a") (Var "b"), Var "t"), (Var "a", Arrow (Var "c") (Var "d"))] "t"
--   ⇒ unify [(Var "t", Arrow (Var "a") (Var "b")), (Var "a", Arrow (Var "c") (Var "d"))] "t" -- Rule 4
--   ⇒ unify [(Var "a", Arrow (Var "c") (Var "d")), (Var "t", Arrow (Var "a") (Var "b"))] "t" -- Rule 1
--   ⇒ unify [(Var "t", Arrow (Arrow (Var "c") (Var "d")) (Var "b"))] "t" -- Rule 2
--   ⇒ Arrow (Arrow (Var "c") (Var "d")) (Var "b") -- returneres
--
-- "Gir en feilmelding" is tested as a call to error with a message of your
-- own. A pattern-match failure because no equation of unify matched counts
-- as a FAIL: rule 5 is a rule, so it gets a case.
--
-- The tests only look at the type that comes out, never at the steps, and
-- they stick to equation lists where the sheet's rules leave no choice about
-- the answer.
-- ---------------------------------------------------------------------------

unify :: [(Type, Type)] -> String -> Type
unify = undefined
