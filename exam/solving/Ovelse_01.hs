module Ovelse_01 where

{-
  # Øvingssett 1: listefunksjoner, halerekursjon og enkel fold

  Skrevet i stilen til del 1 og 2 i eksamenssettene. Dette er ikke en ekte
  eksamen. Samme regler som på eksamen:

  - Programmer og angi typen til alle hjelpefunksjoner som du selv innfører.
  - Løsninger av delproblemer som du ikke har besvart kan antas gitt dersom de
    trenges i andre delproblemer.
-}

{-
  ## A  Programmer følgende funksjoner

  (A.1–A.3 bygger på hverandre, slik som i 2024konte del 1.)
-}

{-
  **A.1.** `fjernLike :: Eq a => a -> [a] -> [a]` fjerner alle forekomster av
  et gitt element fra en liste, f.eks.:

  ```haskell
  fjernLike 'a' "banana"   = "bnn"
  fjernLike 3 [3,1,3,2]    = [1,2]
  ```
-}




{-
  **A.2.** `unike :: Eq a => [a] -> [a]` beholder bare den første forekomsten
  av hvert element, f.eks.:

  ```haskell
  unike "banana"       = "ban"
  unike [3,1,3,2,1]    = [3,1,2]
  ```
-}




{-
  **A.3.** `forekomster :: Eq a => [a] -> [(a,Int)]` teller hvor mange ganger
  hvert element forekommer i hele listen (ikke bare sammenhengende, slik som
  `lkode`). Elementene kommer i rekkefølgen de først dukker opp, f.eks.:

  ```haskell
  forekomster "banana"       = [('b',1),('a',3),('n',2)]
  forekomster [3,1,3,2,1]    = [(3,2),(1,2),(2,1)]
  ```
-}




{-
  **A.4.** `splittPaa :: Eq a => a -> [a] -> [[a]]` deler en liste opp i
  biter ved hver forekomst av et skilletegn. Skilletegnet selv blir borte, og
  to skilletegn etter hverandre gir en tom bit, f.eks.:

  ```haskell
  splittPaa ',' "ab,c,,d"      = ["ab","c","","d"]
  splittPaa ' ' "hei på deg"   = ["hei","på","deg"]
  splittPaa ',' ""             = [""]
  ```
-}




{-
  ## B  Halerekursjon

  For hver funksjon: er definisjonen halerekursiv? Begrunn svaret. Hvis den
  ikke er det, gi en halerekursiv definisjon.
-}

{-
  **B.1.**

  ```haskell
  lengde []     = 0
  lengde (_:xs) = 1 + lengde xs
  ```
-}




{-
  **B.2.** For heltall `b` og ikke-negativ `n`:

  ```haskell
  potens b 0 = 1
  potens b n = b * potens b (n-1)
  ```
-}




{-
  **B.3.** For en ikke-tom liste:

  ```haskell
  siste [x]    = x
  siste (_:xs) = siste xs
  ```
-}




{-
  ## C  Enkel fold

  Bruk `foldr` eller `foldl` som angitt. Ingen eksplisitt rekursjon.
-}

{-
  **C.1.** Definer `produkt :: [Int] -> Int` med `foldr`, f.eks.:

  ```haskell
  produkt [2,3,4]   = 24
  produkt []        = 1
  ```
-}




{-
  **C.2.** Definer `antall :: (a -> Bool) -> [a] -> Int` med `foldr`. Den
  teller hvor mange elementer som oppfyller predikatet, f.eks.:

  ```haskell
  antall even [1,2,3,4,6]      = 3
  antall (== 'a') "banana"     = 3
  ```
-}




{-
  **C.3.** Definer `snu :: [a] -> [a]` med `foldl`, f.eks.:

  ```haskell
  snu [1,2,3]   = [3,2,1]
  snu "hei"     = "ieh"
  ```
-}




{-
  **C.4.** Definer `alle :: (a -> Bool) -> [a] -> Bool` med `foldr`. Den gir
  `True` hvis alle elementene oppfyller predikatet, f.eks.:

  ```haskell
  alle even [2,4,6]   = True
  alle even [2,3,6]   = False
  alle even []        = True
  ```
-}




{-
  **C.5.** Velg riktige svar (uten GHCi først):

  `foldr (\x acc -> x - acc) 0 [1,2,3]` gir:
  (a) `-6`   (b) `0`   (c) `2`   (d) `6`

  `foldl (-) 0 [1,2,3]` gir:
  (a) `-6`   (b) `0`   (c) `2`   (d) `6`

  Skriv utregningen med parenteser for begge.
-}
