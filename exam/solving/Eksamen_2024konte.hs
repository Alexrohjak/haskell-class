module Eksamen_2024konte where
import Data.List

{-
  # INF122 — Konteeksamen februar 2025 (2024konte)

  Universitetet i Bergen, Fakultet for vitenskap og teknologi — Norsk

  | | |
  |---|---|
  | Eksamen i | INF-122 Funksjonell programmering |
  | Dato | Februar 2025 KONTE.............. |
  | Tid | 3 timer |
  | Antall sider | 3 |
  | Tillatte hjelpemidler | Ingen |

  - Prosentsatsene angir *kun omtrentlig* vekting ved sensur og forventet tidsforbruk.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de trenges i andre delproblemer.
  - Programmer og angi typen til alle hjelpefunksjoner som du selv innfører.
-}

{-
  ## 1 Programmer følgende funksjoner (20%)
-}

{-
  **1.1.** `kompress::Eq a=>[a]->[a]` fjerner sammenhengende duplikater fra en liste, f.eks.:

  ```haskell
  kompress "aabaaaccd" = "abacd"
  kompress [1,2,3,3,3,3,2,2,2] = [1,2,3,2]
  ```
-}

kompress :: Eq a => [a] -> [a]
kompress [] = []
kompress [a] = [a]
kompress (x:y:xs)
  | x == y = kompress (y:xs)
  | otherwise = x : kompress (y:xs)

{-
  **1.2.** `pakk::Eq a=>[a]->[[a]]` pakker sammenhengende duplikater i separate lister, f.eks.:

  ```haskell
  pakk "aabaaaccd" = ["aa","b","aaa","cc","d"]
  pakk [1,2,3,3,3,3,2,2,2] = [[1],[2],[3,3,3,3],[2,2,2]]
  ```
-}

pakk :: Eq a => [a] -> [[a]]
pakk [] = []
pakk [a] = [[a]]
pakk (x:y:xs) 
  | x == y = (x : first) : rest
  | otherwise = [x] : first : rest  
  where (first:rest) = pakk (y:xs)

{-
  **1.3.** `lkode::Eq a=>[a]->[(a,Int)]` "lengdekoder" en liste ved å erstatte hvert segment av sammenhengende duplikater med kun ett slikt element og lengden av segmentet, f.eks.:

  lkode "aabaaaccd" = [('a',2),('b',1),('a',3),('c',2),('d',1)]
  lkode [1,2,3,3,3,3,2,2,2] = [(1,**1**),(2,**1**),(3,**4**),(2,**3**)]

  (Lengder markeres i det siste eksempelet med tykkskrift kun for å øke lesbarheten.)
-}

lkode :: Eq a => [a] -> [(a, Int)]
lkode xs = [(head g, length g) | g <- pakk xs] 

{-
  **1.4.** `dekode::[(a,Int)]->[a]` gjenskaper den opprinelige listen fra dens lengdekode produsert av `lkode`. (Det skal gjelde at `dekode(lkode xs) == xs`.) F.eks.:

  dekode [('a',2),('b',1),('a',3),('c',2),('d',1)] = "aabaaaccd"
  dekode [(1,**1**),(2,**1**),(3,**4**),(2,**3**)] = [1,2,3,3,3,3,2,2,2]
-}

dekode :: [(a, Int)] -> [a]
dekode xs = concat [replicate b a | (a, b) <- xs]


{-
  ## 2 Halerekursjon (10%)

  For et ikke-negativt input-tall, gir følgende funksjon `True` hvis det er odd, og `False` ellers.

  ```haskell
  erOdd 0 = False
  erOdd n = not(erOdd (n-1))
  ```

  Er definisjonen halerekursiv? Hvis ikke, gi en halerekursiv definisjon av `erOdd`.
-}

-- Koden er IKKE halerekursiv, siden rekursjonen skjer i det indre uttrykket, 
-- der etter rekursjonen er ferdig må resultatet andvendes med not, dermed skjer
-- rekursjonen ikke sist. For at halerekursjon skal skje må rekorsjonen være det 
-- siste som blir kallt, altså være det yttre uttrykket.

erOdd :: Int -> Bool
erOdd n = erOdd' False n

erOdd' :: Bool -> Int -> Bool
erOdd' acc 0 = acc
erOdd' acc n = erOdd' (not acc) (abs n - 1)


{-
  ## 3 Høyereordens funksjoner (20%)

  Typen

  ```haskell
  data Nat = Z | S Nat deriving (Show, Eq)
  ```

  representerer naturlige tall med `Z` for 0 og `S n` for n + 1 (`S Z` er 1, `S(S Z)` er 2, osv.) Naturlig fold for `Nat` er:

  ```haskell
  foldn s z Z = z
  foldn s z (S n) = s (foldn s z n)
  ```
-}

{-
  **3.1.** Angi typen til `foldn` (uten å avlede den formelt med Hindley-Milner).

  Bruk `foldn` for å definere følgende funksjoner:
-}

data Nat = Z | S Nat
  deriving (Show, Eq)

foldn :: (b -> b) -> b -> Nat -> b 
foldn s z Z = z
foldn s z (S n) = s (foldn s z n)


{-
  **3.2.** `erOdd:Nat->Bool` – som sier `True` hvis input `Nat` er odd, og `False` ellers, f.eks.:

  ```haskell
  erOdd (S (S Z)) = False,  erOdd Z = False  og  erOdd (S (S (S Z))) = True.
  ```
-}

erOdde :: Nat -> Bool
erOdde = foldn not False


{-
  **3.3.** `arab::Nat->Int` – som konverterer et tall fra datatypen `Nat` til tilsvarende `Int`, f.eks.:

  ```haskell
  arab (S(S(S(S Z)))) = 4  og  arab (S(S Z)) = 2.
  ```
-}

arab :: Nat -> Int
arab = foldn (1 +) 0

{-
  **3.4.** `plus::Nat->Nat->Nat` – som gir summen av argumenter, f.eks.:

  ```haskell
  plus (S(S Z)) (S Z) = S(S(S Z))  og  plus Z (S(S Z)) = S(S Z).
  ```
-}

plus :: Nat -> Nat -> Nat
plus m n = foldn S n m

{-
  **3.5.** `mult::Nat->Nat->Nat` – som multipliserer argumenter, f.eks.:

  ```haskell
  mult (S(S(S Z))) (S(S Z)) = S(S(S(S(S(S Z))))),  mult Z (S(S Z)) = Z  og
  mult (S(S(S(S Z)))) (S(S(S Z))) = S(S(S(S(S(S(S(S(S(S(S(S Z))))))))))).
  ```
-}

mult :: Nat -> Nat -> Nat
mult m n = foldn (plus n) Z m


{-
  ## 4 Plassering av n dronninger (30%)

  Oppgaven er å implementere en funksjon `dro::Int->[[Int]]` som gir alle plasseringer av n dronninger på et (n × n)-brett slik at ingen to slår hverandre. En dronning slår brikker som står i samme rad, samme kolonne eller på en av to diagonaler bestemt av dronningens posisjon. I eksempel (A) under, d = (4, 2) slår c = (3, 1) langs den ene diagonalen, og b = (2, 4) langs den andre; d slår også a = (1, 2) siden de står i samme kolonne. (B) og (C) er *løsninger* – ingen dronning slår en annen. (Prikker markerer tomme posisjoner.)

  ```
       1 2 3 4              1 2 3 4              1 2 3 4
    1  . a . .           1  . a . .           1  . . a .
    2  . . . b           2  . . . b           2  b . . .
    3  c . . .           3  c . . .           3  . . . c
    4  . d . .           4  . . d .           4  . d . .
    (A) [2, 4, 1, 2]     (B) [2, 4, 1, 3]     (C) [3, 1, 4, 2]
  ```

  En plassering av n brikker på et (n × n)-brett representeres som en liste med n tall [k1, k2, ..., kn], der hver 1 ≤ ki ≤ n. Den tolkes som plasseringen [(1, k1), (2, k2), ..., (n, kn)], dvs. rad 1 har en brikke i kolonne k1, rad 2 i kolonne k2, osv. Listen [2, 4, 1, 2] representerer plasseringen (A), nemlig [a = (1, 2), b = (2, 4), c = (3, 1), d = (4, 2)]. Denne representasjonen sikrer at ingen to dronninger står i samme rad. I tillegg, hvis alle tallene ki, 1 ≤ ki ≤ n, er forskjellige (dvs. listen er en *permutasjon* av listen [1, 2, ..., n]) står ingen to dronninger i samme kolonne, f.eks. (B) og (C).
-}




{-
  **4.1.** Programmer funksjon `diag::(Int,Int)->(Int,Int)->Bool` som bestemmer om to dronninger i input posisjoner slår hverandre langs noen av diagonaler, dvs. `diag (x1,y1) (x2,y2) = True` hvis (x1,y1) og (x2,y2) er på samme diagonalen; ellers er det `False`, f.eks.:

  ```haskell
  diag (4,2) (3,1) = diag (2,4) (4,2) = diag (4,1) (2,3) = True,
  diag (4,2) (1,2) = diag (3,4) (4,2) = diag (4,1) (2,4) = False.
  ```
-}

diag :: (Int, Int) -> (Int, Int) -> Bool
diag (x1, y1) (x2, y2) = dr == dk
  where dr = abs(x1 - x2)
        dk = abs(y1 - y2)



{-
  **4.2.** Programmer funksjon `test::[Int]->Bool` som antar at input er en permutasjon av [1, 2, ..., n] og returnerer `True` hvis den representerer en løsning, dvs. plassering av n dronninger der ingen to slår hverandre; ellers returnerer den `False`. F.eks.,

  ```haskell
  test [1,4,3,2] = False, mens test [2,4,1,3] = True.
  ```
-}

test :: [Int] -> Bool
test xs = and [not (diag x y)| x <- list, y <- list, x < y]
  where list = zip [1..] xs


{-
  **4.3.** Anta en funksjon `perm::[a]->[[a]]` som for en inputliste [a1, ..., ak] returnerer en liste med alle dens permutasjoner. Bruk den og funksjon `test` for å definere funksjon `dro::Int->[[Int]]` som for et input n gir en liste med alle løsninger for n dronninger.
-}

dro :: Int -> [[Int]]
dro n = filter test (permN [1..n])


{-
  **4.4.** Definer selv funksjon `perm` uten å bruke `permutations` (fra `Data.List`).
-}

permN :: [a] -> [[a]]
permN [] = [[]]
permN (x:xs) = [q | p <- permN xs, q <- settInn x p]

settInn :: a -> [a] -> [[a]]
settInn n [] = [[n]]
settInn n (x:xs) = [n : x : xs] ++ [x : ys | ys <- rest]
  where rest = settInn n xs

{-
  ## 5 Litt IO (20%)

  Vi bruker den samme representasjonen som i forrige oppgave og du kan bruke alle funksjoner derfra, selv om du ikke har programmert dem. I denne oppgaven forutsetter vi at antallet n av dronninger (og størrelsen av brettet) er 1 ≤ n ≤ 9.
-}




{-
  **5.1.** Gitt en permutasjon av [1, 2, ..., n] som representerer en plassering av n brikker som i forrige oppgave, programmer aksjon `vis::[Int]->IO()` (og evt. hjelpeaksjoner og -funksjoner) som skriver den ut på skjermen som eksemplene (A), (B), (C) i forrige oppgave (uten den nederste linjen). F.eks., `vis [2,4,1,3]` skal gi følgende utskrift (tilsvarende (B); alle brikker markeres med "x" istedenfor forskjellige bokstaver):

  ```
    1 2 3 4
  1 . x . .
  2 . . . x
  3 x . . .
  4 . . x .
  ```

  Husk prikker for markering av tomme posisjoner samt mellomrom mellom påfølgende tegn.
-}




{-
  **5.2.** Programmer aksjon `losn::Int->IO()` (og evt. hjelpeaksjoner og -funksjoner) som for input n begynner å vise alle løsninger for n dronninger, én om gangen, vhj. aksjonen `vis`. Etter at brukeren kaller `losn n` fra GHCi (med et siffer n), vises første løsning og brukeren fortsetter ved å velge én kommando:

  - RET (dvs. tom inputlinje, kun RETurn knappen): vis neste løsning,
  - et siffer 1 ≤ n ≤ 9: begynn å vise løsninger for den nye n,
  - q: avslutt aksjonen og returner til GHCi.

  Når brukeren trykker RET etter siste løsning for den aktuelle parameteren n har blitt vist, gir aksjonen mulighet til å velge en ny verdi n eller avslutte ved q.

  Lykke til!
  Michał Walicki
-}
